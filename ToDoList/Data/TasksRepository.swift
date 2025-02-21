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
    
//    func searchTasks(query: String, completion: @escaping ([Task]) -> Void)
    
    func createTask()
    func editTask()
    func deleteTask()
}

final class TasksRepository: TasksRepositoryProtocol {
    var networkService = NetworkService()
    var coreDataService = CoreDataService()
    
//    var tasks: [Task]
    
    func fetchTasks(completion: @escaping ([Task]) -> Void) {
        //1. Check if it is the first launch
        let didLaunchBefore = UserDefaults.standard.bool(forKey: "isFirstLaunch")
        
        if (!didLaunchBefore) {
            print("1 launch")
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
                
                //3. Return tasks
                completion(tasks)
            }
        } else {
            print("2+ launch")
            let tasksData = self.coreDataService.fetchEntities(ofType: TaskCoreData.self)
            var tasks: [Task]
            
            tasks = tasksData.map({ task in
                Task(coreDataTask: task)
            })
            
            completion(tasks)
            UserDefaults.standard.set(false, forKey: "didLaunchBefore")
        }
        
        
    }
    
//    func searchTasks(query: String, completion: @escaping ([Task]) -> Void) {
//        
//    }
    
    func createTask() {
        
    }
    
    func editTask() {
        
    }
    
    func deleteTask() {
        
    }

}
