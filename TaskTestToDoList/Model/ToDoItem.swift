//
//  ToDoItem.swift
//  TaskTestToDoList
//
//  Created by Hakob Ghlijyan on 27.08.2024.
//

import SwiftData
import SwiftUI

@Model
final class ToDoItem {
    @Attribute(.unique) var id: UUID
    var title: String
    var dateCreated: Date
    var isCompleted: Bool

    init(title: String, dateCreated: Date = Date(), isCompleted: Bool = false) {
        self.id = UUID()
        self.title = title
        self.dateCreated = dateCreated
        self.isCompleted = isCompleted
    }
}

