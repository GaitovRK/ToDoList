//
//  TaskDetailPresenter.swift
//  ToDoList
//
//  Created by Rashid Gaitov on 21.02.2025.
//

import Foundation

protocol TaskDetailPresenterProtocol {
    func viewDidLoad(view: TaskDetailView)
    func saveTask(task: Task)
}

final class TaskDetailPresenter: TaskDetailPresenterProtocol {
    var view: TaskDetailView?
    var interactor: TaskDetailInteractorInput
    var router: TaskDetailRouter
    
    init(interactor: TaskDetailInteractorInput, router: TaskDetailRouter) {
        self.interactor = interactor
        self.router = router
    }
    
    func viewDidLoad(view: TaskDetailView) {
        self.view = view
    }
    
//    func editTask(task: Task) {
//        interactor.editTask(task: task)
//    }
//
//    func addTask(task: Task) {
//        interactor.addTask(task: task)
//    }
    
    func saveTask(task: Task) {
        interactor.saveTask(task: task)
    }
}

extension TaskDetailPresenter: TaskDetailInteractorOutput {
    func fetchTaskFailure(error: Error?) {
        
    }
    
    func didUpdateTask(_ task: Task) {
        view?.displayUpdatedTask(task)
    }
    
    func fetchTaskSuccess(task: Task) {
        view?.show(task: task)
    }
    
}
