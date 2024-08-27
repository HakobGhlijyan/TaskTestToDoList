//
//  EditTaskView.swift
//  TaskTestToDoList
//
//  Created by Hakob Ghlijyan on 27.08.2024.
//

import SwiftUI

// Представление для редактирования существующей задачи
struct EditTaskView: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var todoItems: [ToDoItem]
    
    var task: ToDoItem
    @State private var title: String
    @State private var description: String
    @State private var isCompleted: Bool

    init(todoItems: Binding<[ToDoItem]>, task: ToDoItem) {
        self._todoItems = todoItems
        self.task = task
        self._title = State(initialValue: task.title)
        self._description = State(initialValue: task.description)
        self._isCompleted = State(initialValue: task.isCompleted)
    }

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Название")) {
                    TextField("Введите название", text: $title)
                }

                Section(header: Text("Описание")) {
                    TextField("Введите описание", text: $description)
                }

                Section {
                    Toggle(isOn: $isCompleted) {
                        Text("Выполнена")
                    }
                }
            }
            .navigationTitle("Редактировать задачу")
            .navigationBarItems(leading: Button("Отмена") {
                presentationMode.wrappedValue.dismiss()
            }, trailing: Button("Сохранить") {
                saveChanges()
                presentationMode.wrappedValue.dismiss()
            })
        }
    }

    // Функция сохранения изменений задачи
    func saveChanges() {
        if let index = todoItems.firstIndex(where: { $0.id == task.id }) {
            todoItems[index].title = title
            todoItems[index].description = description
            todoItems[index].isCompleted = isCompleted
        }
    }
}

#Preview {
    ToDoListView()
}
