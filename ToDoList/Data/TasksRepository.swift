//
//  TasksRepository.swift
//  ToDoList
//
//  Created by Rashid Gaitov on 17.02.2025.
//

import Foundation

protocol TaskListRepo: AnyObject {
    func fetchTasks(completion: @escaping ([Task]?, Error?) -> Void)
}

protocol TasksRepositoryProtocol {
    func fetchTasks(completion: @escaping ([Task]) -> Void)
    
    func searchTasks(query: String, completion: @escaping ([Task]) -> Void)
    
    func createTask()
    func editTask()
    func deleteTask()
}
