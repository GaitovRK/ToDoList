//
//  TaskListRouter.swift
//  ToDoList
//
//  Created by Rashid Gaitov on 17.02.2025.
//

import Foundation
import UIKit
protocol TaskListRouterProtocol {
}

final class TaskListRouter: TaskListRouterProtocol {
    weak var viewController: UIViewController?
    
    static func createTaskListModule() -> TaskListViewController {
        let repo = TasksRepository()
        let interactor = TaskListInteractor(repo: repo)
        let router = TaskListRouter()
        let presenter = TaskListPresenter(interactor: interactor, router: router)
        let view = TaskListViewController(presenter: presenter)

        router.viewController = view
        presenter.view = view
        interactor.output = presenter
        
        return view
    }
    
    static func pushToTaskDetailScreen(navigationController: UINavigationController, task: Task) {
        let taskDetailModule = TaskDetailRouter.createTaskDetailModule()
        taskDetailModule.show(task: task)
        navigationController.pushViewController(taskDetailModule, animated: true)
    }
}
