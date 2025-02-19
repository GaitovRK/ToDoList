//
//  NetworkService.swift
//  ToDoList
//
//  Created by Rashid Gaitov on 19.02.2025.
//

import Foundation

protocol NetworkParsable {
    static func parse(data: [String : Any]) -> Self?
    func toDomain() -> Task
}

final class NetworkService {
    
    let pathURL = "https://dummyjson.com/todos"
    
    func get(
        path: String?,
        completion: @escaping ([Task]) -> Void
    ) {
        let urlString = path ?? pathURL
        
        guard let url = URL(string: urlString) else {
            completion([])
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in

            if let error = error {
                DispatchQueue.main.async {
                    print("Error fetching data: \(error)")
                }
                return
            }
            
            if let data = data, let jsonObject = try? JSONSerialization.jsonObject(with: data, options: []),
               let jsonDict = jsonObject as? [String: Any],
               let todosArray = jsonDict["todos"] as? [[String: Any]] {
                let taskDTOs = todosArray.compactMap { TasksResponseDTO.parse(data: $0) }
                let tasks = taskDTOs.map {$0.toDomain()}
                DispatchQueue.main.async {
                    completion(tasks)
                }
            }
        }
        task.resume()
    }
}
