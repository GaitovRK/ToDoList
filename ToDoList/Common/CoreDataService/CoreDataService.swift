//
//  CoreDataService.swift
//  ToDoList
//
//  Created by Rashid Gaitov on 21.02.2025.
//

import Foundation
import UIKit
import CoreData

final class CoreDataService {
    
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    func addEntity<T: NSManagedObject>(ofType type: T.Type, withData data: [String: Any]) {
        let entity = T(context: context)
        for (key, value) in data {
            entity.setValue(value, forKey: key)
        }
        saveContext()
    }

    func fetchEntities<T: NSManagedObject>(
        ofType type: T.Type,
        withPredicate predicate: NSPredicate? = nil,
        completion: @escaping ([T]) -> Void
    ){
        let fetchRequest = NSFetchRequest<T>(entityName: String(describing: type))
        fetchRequest.predicate = predicate
        
        do {
            let data = try context.fetch(fetchRequest)
            DispatchQueue.main.async {
                completion(data)
            }
        } catch {
            print("Failed to fetch entities: \(error)")
            completion([])
        }
    }

    func updateEntity<T: NSManagedObject>(_ type: T.Type, withData data: [String: Any]) {
        print("Updating entity")
        let entity = T(context: context)
        for (key, value) in data {
        entity.setValue(value, forKey: key)
        }
        saveContext()
    }

    func deleteEntity<T: NSManagedObject>(_ entity: T) {
        print("Deleting entity")
        context.delete(entity)
        saveContext()
    }
    
    private func saveContext() {
        do {
            try context.save()
        } catch {
            print("Failed to save context: \(error)")
        }
    }
}


extension Task {
    init(coreDataTask: TaskCoreData) {
        self.id = Int(coreDataTask.id)
        self.title = coreDataTask.title ?? "No title"
        self.isCompleted = coreDataTask.isCompleted
        self.creationDate = coreDataTask.creationDate ?? Date()
        self.description = coreDataTask.taskDescription ?? ""
    }
}

extension TaskCoreData {
    func update(with task: Task) {
        self.id = Int32(task.id)
        self.title = task.title
        self.isCompleted = task.isCompleted
        self.creationDate = task.creationDate
        self.taskDescription = task.description
    }
}
