//
//  TaskDetailRouter.swift
//  ToDoList
//
//  Created by Rashid Gaitov on 21.02.2025.
//

import Foundation

final class TaskDetailRouter {
    private weak var viewController: TaskDetailViewController?
    
    static func createTaskDetailModule() -> TaskDetailViewController {
        let repo = TasksRepository()
        let interactor = TaskDetailInteractor(repo: repo)
        let router = TaskDetailRouter()
        let presenter = TaskDetailPresenter(interactor: interactor, router: router)
        let view = TaskDetailViewController(presenter: presenter)

        router.viewController = view
        presenter.view = view
        interactor.output = presenter

        return view
    }
}
