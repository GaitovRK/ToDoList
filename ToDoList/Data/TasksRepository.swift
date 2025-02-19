//
//  TasksRepository.swift
//  ToDoList
//
//  Created by Rashid Gaitov on 17.02.2025.
//

import Foundation
//The data layer interface enforces an abstraction: what, not how. This note was written by myself, since I tend to mix logic.

protocol TasksRepositoryProtocol {
    func fetchTasks(completion: @escaping ([Task]) -> Void)
    
//    func searchTasks(query: String, completion: @escaping ([Task]) -> Void)
    
    func createTask()
    func editTask()
    func deleteTask()
}

final class TasksRepository: TasksRepositoryProtocol {
    var networkService = NetworkService()
    
    func fetchTasks(completion: @escaping ([Task]) -> Void) {
        networkService.get(path: nil, completion: completion)
    }
    
//    func searchTasks(query: String, completion: @escaping ([Task]) -> Void) {
//        
//    }
    
    func createTask() {
        
    }
    
    func editTask() {
        
    }
    
    func deleteTask() {
        
    }

}
