//
//  TaskListInteractor.swift
//  ToDoList
//
//  Created by Rashid Gaitov on 17.02.2025.
//

import Foundation

class TaskListInteractor: TaskListInteractorInput {
    func fetchTaskList() {
        
    }
    
    func addTask(title: String, description: String) {
        
    }
    
    func editTask(at index: Int, title: String, description: String) {
        
    }
    
    func deleteTask(at index: Int) {
        
    }
    
    func searchTasks(with query: String) -> [Task] {
        return [Task(title: "Task 1", description: "Description 1", creationDate: Date(), isCompleted: false)]
    }
    
    func getAllTasks() -> [Task] {
        return [Task(title: "Task 1", description: "Description 1", creationDate: Date(), isCompleted: false)]
    }
    
    var output: TaskListInteractorOutput?
    private var repo: TaskListRepo?
    
    init(repo: TaskListRepo) {
        self.repo = repo
    }
}

class TaskListRepoImplementation: TaskListRepo {
    func fetchTasks(completion: @escaping ([Task]?, Error?) -> Void) {
        
    }
}   
