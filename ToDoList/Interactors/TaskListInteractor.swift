//
//  TaskListInteractor.swift
//  ToDoList
//
//  Created by Rashid Gaitov on 17.02.2025.
//

import Foundation

class TaskListInteractor: TaskListInteractorInput {
    var output: TaskListInteractorOutput?
    private var repo: TaskListRepo?
    
    init(repo: TaskListRepo) {
        self.repo = repo
    }
}
