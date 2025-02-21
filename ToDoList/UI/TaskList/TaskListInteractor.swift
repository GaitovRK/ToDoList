//
//  TaskListInteractor.swift
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
//    func fetchTasksFailure(error: Error)
}

class TaskListInteractor: TaskListInteractorInput {
    
    var output: TaskListInteractorOutput?
    private var repo: TasksRepository?
    
    init(repo: TasksRepository) {
        self.repo = repo
    }
    
    func fetchTaskList() {
        repo?.fetchTasks(completion: { tasks in
            self.output?.fetchTasksSuccess(tasks: tasks)
        })
    }
    
    func addTask(title: String, description: String) {
        
    }
    
    func editTask(at index: Int, title: String, description: String) {
        
    }
    
    func deleteTask(at index: Int) {
        
    }
    
    func searchTasks(with query: String) -> [Task] {
        return [Task(id: 1, title: "Task 1", description: "Description 1", creationDate: Date(), isCompleted: false)]
    }
    
    func getAllTasks() -> [Task] {
        return [Task(id: 2, title: "Task 1", description: "Description 1", creationDate: Date(), isCompleted: false)]
    }
    
    
}
