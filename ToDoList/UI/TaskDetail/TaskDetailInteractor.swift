//
//  TaskDetailInteractor.swift
//  ToDoList
//
//  Created by Rashid Gaitov on 21.02.2025.
//

import Foundation

protocol TaskDetailInteractorInput {
    func fetchTask()
}

protocol TaskDetailInteractorOutput {
    func fetchTaskSuccess(task: Task)
    func fetchTaskFailure(error: Error?)
}

final class TaskDetailInteractor: TaskDetailInteractorInput {
    var repo: TasksRepository
    var output: TaskDetailInteractorOutput?
    
    init(repo: TasksRepository) {
        self.repo = repo
    }
    
    func fetchTask() {
        
    }
}
