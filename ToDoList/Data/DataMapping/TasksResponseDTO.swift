//
//  TasksResponseDTO.swift
//  ToDoList
//
//  Created by Rashid Gaitov on 19.02.2025.
//

import Foundation

struct TasksResponseDTO: NetworkParsable {
    let id: Int
    var title: String
    var description: String
    let creationDate: Date
    var isCompleted: Bool
    
    static func parse(data: [String : Any]) -> TasksResponseDTO? {
        return TasksResponseDTO(
            id: data["id"] as! Int,
            title: data["todo"] as! String,
            description: data["todo"] as! String,
            creationDate: Date(),
            isCompleted: data["completed"] as! Bool)
    }
    
    func toDomain() -> Task {
        return .init(
            id: id,
            title: title,
            description: description,
            creationDate: creationDate,
            isCompleted: isCompleted
        )
    }
}

struct TaskResponse {
    let todos: [TasksResponseDTO]
    let total: Int
    let skip: Int
    let limit: Int
}
