//
//  TaskListViewController.swift
//  ToDoList
//
//  Created by Rashid Gaitov on 17.02.2025.
//

import Foundation
import UIKit

protocol TaskListView: AnyObject {
    func show(tasks: [Task])
}

final class TaskListViewController: UIViewController, TaskListView {
    
    var presenter: TaskListPresenter
    private let tableView = UITableView()
    private let bottomBar = UIView()
    private let numberOfTasksLabel = UILabel()
    private var tasks: [Task] = []
    private var filteredTasks: [Task] = []
    private let searchController = UISearchController(searchResultsController: nil)
    
    init(presenter: TaskListPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
        setupTableView()
        setupSearchController()
        setupBottomBar()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewDidLoad(view: self)
        title = "Задачи"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        presenter.viewDidLoad(view: self)
        updateUI()
    }
    
    func show(tasks: [Task]) {
        self.tasks = tasks
        updateUI()
    }
    
    private func updateUI() {
        self.tasks.sort { $0.id > $1.id }
        tableView.reloadData()
        numberOfTasksLabel.text = "\(getNumberOfTasks()) Задач"
    }

    private func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        searchController.searchBar.showsBookmarkButton = true
        searchController.searchBar.setImage(UIImage(systemName: "mic.fill"), for: .bookmark, state: .normal)
        searchController.searchBar.delegate = self

        if let textField = searchController.searchBar.value(forKey: "searchField") as? UITextField {
            textField.heightAnchor.constraint(equalToConstant: 36).isActive = true
        }

        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
    }

    
    func setupBottomBar() {
        bottomBar.backgroundColor = .secondarySystemBackground
        bottomBar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bottomBar)

        numberOfTasksLabel.font = .systemFont(ofSize: 11)
        numberOfTasksLabel.translatesAutoresizingMaskIntoConstraints = false
        bottomBar.addSubview(numberOfTasksLabel)
        
        let addTaskButton = UIButton(type: .system)
        addTaskButton.setImage(UIImage(systemName: "square.and.pencil"), for: .normal)
        addTaskButton.translatesAutoresizingMaskIntoConstraints = false
        addTaskButton.addTarget(self, action: #selector(addTaskButtonTapped), for: .touchUpInside)
        bottomBar.addSubview(addTaskButton)
        
        NSLayoutConstraint.activate([
            bottomBar.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            bottomBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomBar.heightAnchor.constraint(equalToConstant: 50),
            
            numberOfTasksLabel.centerXAnchor.constraint(equalTo: bottomBar.centerXAnchor),
            numberOfTasksLabel.centerYAnchor.constraint(equalTo: bottomBar.centerYAnchor),
            
            addTaskButton.centerXAnchor.constraint(equalTo: bottomBar.trailingAnchor, constant: -34),
            addTaskButton.centerYAnchor.constraint(equalTo: bottomBar.centerYAnchor),
            addTaskButton.heightAnchor.constraint(equalToConstant: 28),
            addTaskButton.widthAnchor.constraint(equalToConstant: 28)
        ])
    }
    
    @objc func addTaskButtonTapped() {
        let uniqueID = (tasks.first?.id ?? 0) + 1
        let task = Task(id: uniqueID, title: "Новая Задача", description: "", creationDate: Date(), isCompleted: false)
        presenter.showTaskDetailView(navigationController: navigationController!, task: task)
    }
    
    func getNumberOfTasks() -> Int{
        return searchController.isActive ? filteredTasks.count : tasks.count
    }
    
    func deleteTask(at index: Int) {
        let id = convertIndexToID(index: index)

        if searchController.isActive {
            let indexPath = IndexPath(row: index, section: 0)
            filteredTasks.remove(at: index)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        } else {
            let indexPath = IndexPath(row: index, section: 0)
            tasks.remove(at: index)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        
        presenter.deleteTask(id: id)
    }
    
    func convertIndexToID(index: Int) -> Int {
        let task = searchController.isActive ? filteredTasks[index] : tasks[index]
        let id = task.id
        return id
    }
}

extension TaskListViewController: UITableViewDataSource, UITableViewDelegate {
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true

        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(TaskTableViewCell.self, forCellReuseIdentifier: "TaskCell")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return getNumberOfTasks()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath) as? TaskTableViewCell else {
            return UITableViewCell()
        }
        let task = searchController.isActive ? filteredTasks[indexPath.row] : tasks[indexPath.row]
        cell.configure(with: task)
        cell.delegate = self
        cell.selectionStyle = .none
        let interaction = UIContextMenuInteraction(delegate: self)
        cell.addInteraction(interaction)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let task = searchController.isActive ? filteredTasks[indexPath.row] : tasks[indexPath.row]
        presenter.showTaskDetailView(navigationController: navigationController!, task: task)
    }
}

extension TaskListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchText = searchController.searchBar.text ?? ""
        filteredTasks = tasks.filter { task in
            task.title.lowercased().contains(searchText.lowercased()) ||
            task.description.lowercased().contains(searchText.lowercased())
        }
        tableView.reloadData()
    }
}

extension TaskListViewController: UISearchBarDelegate {
    func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar) {
        print("Microphone button tapped")
    }
}

extension TaskListViewController: TaskTableViewCellDelegate {
    func didTapTitleButton(in cell: TaskTableViewCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        let task = searchController.isActive ? filteredTasks[indexPath.row] : tasks[indexPath.row]
        // Call your function here
    }
}

extension TaskListViewController: UIContextMenuInteractionDelegate {
    func contextMenuInteraction(_ interaction: UIContextMenuInteraction, configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { suggestedActions in
            
            let locationInTableView = interaction.view?.convert(location, to: self.tableView) ?? location

            let indexPath = self.tableView.indexPathForRow(at: locationInTableView)
            var task = self.tasks[0]
            if let index = indexPath {
                task = self.searchController.isActive ? self.filteredTasks[index.row] : self.tasks[index.row]
            }
            
            let editAction = UIAction(title: "Редактировать", image: UIImage(systemName: "square.and.pencil")) { action in
                self.presenter.showTaskDetailView(navigationController: self.navigationController!, task: task)
            }
            
            let shareAction = UIAction(title: "Поделиться", image: UIImage(systemName: "square.and.arrow.up")) { action in
                self.presenter.shareTask(task: task)
            }
            
            let deleteAction = UIAction(title: "Удалить", image: UIImage(systemName: "trash"), attributes: .destructive) { action in
                self.deleteTask(at: indexPath!.row)
            }
            
            return UIMenu(title: "", children: [editAction, shareAction, deleteAction])
        }
    }
}
