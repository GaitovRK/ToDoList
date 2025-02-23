//
//  CoreDataService.swift
//  ToDoList
//
//  Created by Rashid Gaitov on 21.02.2025.
//

import Foundation
import UIKit
import CoreData

protocol CoreDataServiceProtocol {
    func addEntity<T: NSManagedObject>(ofType type: T.Type, withData data: [String: Any])
    func fetchEntities<T: NSManagedObject>(
        ofType type: T.Type,
        withPredicate predicate: NSPredicate?,
        completion: @escaping ([T]) -> Void
    )
    func updateEntity<T: NSManagedObject>(
        _ type: T.Type,
        withPredicate predicate: NSPredicate?,
        withData data: [String: Any]
    )
    func deleteEntity<T: NSManagedObject>(_ entity: T)
}

final class CoreDataService: CoreDataServiceProtocol {
    
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

    func updateEntity<T: NSManagedObject>(
        _ type: T.Type,
        withPredicate predicate: NSPredicate? = nil,
        withData data: [String: Any]
    ) {
        let fetchRequest = NSFetchRequest<T>(entityName: String(describing: type))
            fetchRequest.predicate = predicate

            do {
                let results = try context.fetch(fetchRequest)
                if let entityToUpdate = results.first {
                    for (key, value) in data {
                        entityToUpdate.setValue(value, forKey: key)
                    }
                    saveContext()
                } else {
                    print("No entity found with the identifier ")
                }
            } catch {
                print("Failed to fetch entity: \(error)")
            }
    }

    func deleteEntity<T: NSManagedObject>(_ entity: T) {
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
