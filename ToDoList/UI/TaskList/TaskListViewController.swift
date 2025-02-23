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

final class TaskListViewController: UIViewController, TaskListView, UISearchResultsUpdating {
    
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
        tableView.reloadData()
    }
    
    func show(tasks: [Task]) {
        print("Show tasks: \(tasks)")
        self.tasks = tasks
        self.tableView.reloadData()
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

    // MARK: - UISearchResultsUpdating
    func updateSearchResults(for searchController: UISearchController) {
        let searchText = searchController.searchBar.text ?? ""
        filteredTasks = tasks.filter { task in
            task.title.lowercased().contains(searchText.lowercased()) ||
            task.description.lowercased().contains(searchText.lowercased())
        }
        tableView.reloadData()
    }
    
    func setupBottomBar() {
        bottomBar.backgroundColor = .secondarySystemBackground // Set a background color for visibility
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
        let uniqueID = (tasks.last?.id ?? 0) + 1
        let task = Task(id: uniqueID, title: "Новая Задача", description: "", creationDate: Date(), isCompleted: false)
        presenter.showTaskDetailView(navigationController: navigationController!, task: task)
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
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        deleteTask(at: indexPath.row)
        tableView.reloadData()
    }
    
    func getNumberOfTasks() -> Int{
        return searchController.isActive ? filteredTasks.count : tasks.count
    }
    
    func updateTask(task: Task) {
        presenter.editTask(task: task)
        tableView.reloadData()
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
            tableView.deleteRows(at: [indexPath], with: .left)
        }
        
        presenter.deleteTask(id: id)
        tableView.reloadData()
    }
    
    func convertIndexToID(index: Int) -> Int {
        let task = searchController.isActive ? filteredTasks[index] : tasks[index]
        let id = task.id
        return id
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

//extension TaskListViewController: TaskListInteractorOutput {
//    func fetchTasksSuccess(tasks: [Task]) {
//        self.tasks = tasks
//        self.tableView.reloadData()
//    }
//    
//    func fetchTasksFailure(error: Error) {
//        let alert = UIAlertController(title: "Alert", message: "Problem Fetching Tasks", preferredStyle: .alert)
//        alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
//        self.present(alert, animated: true, completion: nil)
//    }
//}
