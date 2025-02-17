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
    weak var view: TaskListView?
    var interactor: TaskListInteractorInput
    var router: TaskListRouter
    
    init(interactor: TaskListInteractorInput, router: TaskListRouter) {
        self.interactor = interactor
        self.router = router
    }
    
    func viewDidLoad(view: TaskListView) {
        
    }
}

extension TaskListPresenterImplementation: TaskListInteractorOutput {
    func fetchTasksSuccess(tasks: [Task]) {
        
    }
    
    func fetchTasksFailure(error: Error) {

    }
    
    
}
