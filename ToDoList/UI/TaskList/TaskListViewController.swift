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
    func show(tasks: [Task]) {
        self.tasks = tasks
        self.tableView.reloadData()
    }
    
    var presenter: TaskListPresenter
    private let tableView = UITableView()
    private var tasks: [Task] = []
    private var filteredTasks: [Task] = []
    private let searchController = UISearchController(searchResultsController: nil)
    
    init(presenter: TaskListPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
        setupTableView()
        setupSearchController()
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

    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchController.isActive ? filteredTasks.count : tasks.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath) as? TaskTableViewCell else {
            return UITableViewCell()
        }
        let task = searchController.isActive ? filteredTasks[indexPath.row] : tasks[indexPath.row]
        cell.configure(with: task)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let taskIndex = searchController.isActive ? tasks.firstIndex(where: { $0.id == filteredTasks[indexPath.row].id }) : indexPath.row
        if let taskIndex = taskIndex {
            tasks[taskIndex].isCompleted.toggle()
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
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
}

extension TaskListViewController: UISearchBarDelegate {
    func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar) {
        print("Microphone button tapped")
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
