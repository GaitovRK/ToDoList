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
}
