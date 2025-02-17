//
//  Protocols.swift
//  ToDoList
//
//  Created by Rashid Gaitov on 17.02.2025.
//

import Foundation

protocol TaskListInteractorInput {
    func fetchTaskList()
    func addTask(title: String, description: String)
    func editTask(at index: Int, title: String, description: String)
    func deleteTask(at index: Int)
    func searchTasks(with query: String) -> [Task]
    func getAllTasks() -> [Task]
}

protocol TaskListInteractorOutput {
    func fetchTasksSuccess(tasks: [Task])
    func fetchTasksFailure(error: Error)
}


protocol TaskListPresenter: AnyObject {
    func viewDidLoad(view: TaskListView)
}

protocol TaskListView: AnyObject {
    func show(tasks: [Task])
}

protocol TaskListRouter {
}

protocol TaskListRepo: AnyObject {
    func fetchTasks(completion: @escaping ([Task]?, Error?) -> Void)
}
