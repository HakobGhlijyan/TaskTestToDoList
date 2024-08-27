//
//  ToDoItem.swift
//  TaskTestToDoList
//
//  Created by Hakob Ghlijyan on 27.08.2024.
//

import SwiftUI

// Модель данных задачи
struct ToDoItem: Identifiable {
    var id = UUID() // Уникальный идентификатор
    var title: String
    var description: String
    var dateCreated: Date
    var isCompleted: Bool
}
