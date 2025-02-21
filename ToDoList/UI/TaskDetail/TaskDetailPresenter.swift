//
//  TaskDetailPresenter.swift
//  ToDoList
//
//  Created by Rashid Gaitov on 21.02.2025.
//

import Foundation

protocol TaskDetailPresenterProtocol {
    func viewDidLoad(view: TaskDetailView)
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
}

extension TaskDetailPresenter: TaskDetailInteractorOutput {
    func fetchTaskSuccess(task: Task) {
        view?.show(task: task)
    }
    
    func fetchTaskFailure(error: Error?) {
        
    }
}
