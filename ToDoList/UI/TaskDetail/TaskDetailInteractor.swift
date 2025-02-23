//
//  TaskDetailInteractor.swift
//  ToDoList
//
//  Created by Rashid Gaitov on 21.02.2025.
//

import Foundation

protocol TaskDetailInteractorInput {
    func fetchTask()
//    func editTask(task: Task)
//    func addTask(task: Task)
    func saveTask(task: Task)
}

protocol TaskDetailInteractorOutput {
    func fetchTaskSuccess(task: Task)
    func fetchTaskFailure(error: Error?)
    func didUpdateTask(_ task: Task)
}

final class TaskDetailInteractor: TaskDetailInteractorInput {
    func addTask(task: Task) {
        repo.addTask(task: task)
    }
    
    var repo: TasksRepository
    var output: TaskDetailInteractorOutput?
    
    init(repo: TasksRepository) {
        self.repo = repo
    }
    
    func fetchTask() {
        
    }
    
    func saveTask(task: Task) {
        repo.saveTask(task: task)
    }
    
//    func editTask(task: Task) {
//        repo.editTask(task: task)
//    }
}
