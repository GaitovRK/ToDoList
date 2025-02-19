//
//  TaskListPresenter.swift
//  ToDoList
//
//  Created by Rashid Gaitov on 17.02.2025.
//

import Foundation

protocol TaskListPresenter: AnyObject {
    func viewDidLoad(view: TaskListView)
}


final class TaskListPresenterImplementation: TaskListPresenter {
    
    weak var view: TaskListViewController?
    var interactor: TaskListInteractorInput
    var router: TaskListRouter
    
    init(interactor: TaskListInteractorInput, router: TaskListRouter) {
        self.interactor = interactor
        self.router = router
    }
    
    func viewDidLoad(view: TaskListView) {
        interactor.fetchTaskList()
        print("Presenter viewDidLoad")
    }
}

extension TaskListPresenterImplementation: TaskListInteractorOutput {
    func fetchTasksSuccess(tasks: [Task]) {
        view?.show(tasks: tasks)
    }
    
//    func fetchTasksFailure(error: Error) {
//        view?.fetchTasksFailure(error: error)
//    }
    
    
}
