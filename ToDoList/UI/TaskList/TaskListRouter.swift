//
//  TaskListRouter.swift
//  ToDoList
//
//  Created by Rashid Gaitov on 17.02.2025.
//

import Foundation
import UIKit
protocol TaskListRouter {
}

final class TaskListRouterImplementation: TaskListRouter {
    weak var viewController: UIViewController?
    
    static func createTaskListModule() -> TaskListViewController {
        let repo = TasksRepository()
        let interactor = TaskListInteractor(repo: repo)
        let router = TaskListRouterImplementation()
        let presenter = TaskListPresenterImplementation(interactor: interactor, router: router)
        let view = TaskListViewController(presenter: presenter)

        router.viewController = view
        presenter.view = view
        interactor.output = presenter
        
        return view
    }
}
