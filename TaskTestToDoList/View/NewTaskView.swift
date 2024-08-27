//
//  NewTaskView.swift
//  TaskTestToDoList
//
//  Created by Hakob Ghlijyan on 27.08.2024.
//

import SwiftUI

// Представление для добавления новой задачи
struct NewTaskView: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var todoItems: [ToDoItem]

    @State private var title: String = ""
    @State private var description: String = ""
    @State private var isCompleted: Bool = false

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
            .navigationTitle("Новая задача")
            .navigationBarItems(leading: Button("Отмена") {
                presentationMode.wrappedValue.dismiss()
            }, trailing: Button("Сохранить") {
                addNewTask()
                presentationMode.wrappedValue.dismiss()
            })
        }
    }

    // Функция добавления новой задачи
    func addNewTask() {
        let newTask = ToDoItem(
            title: title,
            description: description,
            dateCreated: Date(),
            isCompleted: isCompleted
        )
        todoItems.append(newTask)
    }
}

#Preview {
    ToDoListView()
}
