//
//  Protocols.swift
//  ToDoList
//
//  Created by Rashid Gaitov on 17.02.2025.
//

import Foundation

protocol TaskListInteractorInput {
}

protocol TaskListInteractorOutput {
}


protocol TaskListPresenter: AnyObject {
    func viewDidLoad(view: TaskListView)
}

protocol TaskListView: AnyObject {
}

protocol TaskListRouter {
}

protocol TaskListRepo: AnyObject {
}
