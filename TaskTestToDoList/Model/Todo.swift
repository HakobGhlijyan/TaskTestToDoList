//
//  Todo.swift
//  TaskTestToDoList
//
//  Created by Hakob Ghlijyan on 27.08.2024.
//

import SwiftUI

// Модель для данных, получаемых из API
struct TodoResponse: Codable {
    let todos: [TodoItemDTO]
}

struct TodoItemDTO: Codable {
    let id: Int
    let todo: String
    let completed: Bool
    let userId: Int
}
