//
//  TasksRepository.swift
//  ToDoList
//
//  Created by Rashid Gaitov on 17.02.2025.
//

import Foundation
//The data layer interface enforces an abstraction: what, not how. This note was written by myself, since I tend to mix logic.

protocol TasksRepositoryProtocol {
    func fetchTasks(completion: @escaping ([Task]) -> Void)
//    func addTask(task: Task)
//    func editTask(task: Task)
    func saveTask(task: Task)
    func deleteTask(id: Int)
}

final class TasksRepository: TasksRepositoryProtocol {
    var networkService = NetworkService()
    var coreDataService = CoreDataService()
    
//    var tasks: [Task]
    
    func fetchTasks(completion: @escaping ([Task]) -> Void) {
        //1. Check if it is the first launch
        let didLaunchBefore = UserDefaults.standard.bool(forKey: "didLaunchBefore")
        
        if (!didLaunchBefore) {
            UserDefaults.standard.set(true, forKey: "didLaunchBefore")
            networkService.get(path: nil) { [weak self] tasks in
                guard let self = self else { return }
                
                //2. Save to Core Data
                for task in tasks {
                    let taskData: [String: Any] = [
                        "id": task.id,
                        "title": task.title,
                        "isCompleted": task.isCompleted,
                        "creationDate": task.creationDate,
                        "taskDescription": task.description,
                    ]
                    self.coreDataService.addEntity(ofType: TaskCoreData.self, withData: taskData)
                }
                print("First: \(tasks)")
                
                //3. Return tasks
                completion(tasks)
            }
        } else {
            self.coreDataService.fetchEntities(ofType: TaskCoreData.self) { taskData in
                let tasks = taskData.map({ task in
                    Task(coreDataTask: task)
                })
                print("Second: \(tasks)")
                completion(tasks)
            }
        }
    }
    
    func saveTask(task: Task) {
        let taskData: [String: Any] = [
            "id": task.id,
            "title": task.title,
            "isCompleted": task.isCompleted,
            "creationDate": task.creationDate,
            "taskDescription": task.description,
        ]
        
        let predicate = NSPredicate(format: "id == %d", task.id)
        coreDataService.fetchEntities(ofType: TaskCoreData.self, withPredicate: predicate) { tasks in
            if let task = tasks.first {
                self.coreDataService.updateEntity(TaskCoreData.self, withPredicate: predicate, withData: taskData)
            } else {
                self.coreDataService.addEntity(ofType: TaskCoreData.self, withData: taskData)
            }
        }
    }
    
    func addTask(task: Task) {
        let taskData: [String: Any] = [
            "id": task.id,
            "title": task.title,
            "isCompleted": task.isCompleted,
            "creationDate": task.creationDate,
            "taskDescription": task.description,
        ]
        coreDataService.addEntity(ofType: TaskCoreData.self, withData: taskData)
        
    }
    
    func editTask(task: Task) {
        let taskData: [String: Any] = [
            "id": task.id,
            "title": task.title,
            "isCompleted": task.isCompleted,
            "creationDate": task.creationDate,
            "taskDescription": task.description,
        ]
        let predicate = NSPredicate(format: "id == %d", task.id)
        coreDataService.updateEntity(TaskCoreData.self, withPredicate: predicate, withData: taskData)
    }
    
    func deleteTask(id: Int) {
        let predicate = NSPredicate(format: "id == %d", id)
        coreDataService.fetchEntities(ofType: TaskCoreData.self, withPredicate: predicate) { tasks in
            if let task = tasks.first {
                self.coreDataService.deleteEntity(task)
                print("Deleted task with id: \(id)")
            } else {
                print("No task found with id: \(id)")
            }
        }
    }
}
