//
//  TaskListPresenter.swift
//  ToDoList
//
//  Created by Rashid Gaitov on 17.02.2025.
//

import Foundation
import UIKit

protocol TaskListPresenterProtocol: AnyObject {
    func viewDidLoad(view: TaskListView)
}


final class TaskListPresenter: TaskListPresenterProtocol {
    
    weak var view: TaskListViewController?
    var interactor: TaskListInteractorInput
    var router: TaskListRouterProtocol
    
    init(interactor: TaskListInteractorInput, router: TaskListRouterProtocol) {
        self.interactor = interactor
        self.router = router
    }
    
    func viewDidLoad(view: TaskListView) {
        interactor.fetchTaskList()
        print("Presenter viewDidLoad")
    }
    
    func showTaskDetailView(navigationController: UINavigationController, task: Task) {
        TaskListRouter.pushToTaskDetailScreen(navigationController: navigationController, task: task)
    }
    
    func deleteTask(id: Int) {
        interactor.deleteTask(id: id)
    }
    
    func editTask(task: Task) {
        interactor.editTask(task: task)
    }
}

extension TaskListPresenter: TaskListInteractorOutput {
    func fetchTasksSuccess(tasks: [Task]) {
        print("Fetch tasks success")
        view?.show(tasks: tasks)
    }
    
//    func fetchTasksFailure(error: Error) {
//        view?.fetchTasksFailure(error: error)
//    }
    
    
}
