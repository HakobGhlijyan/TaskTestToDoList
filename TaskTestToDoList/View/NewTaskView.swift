//
//  NewTaskView.swift
//  TaskTestToDoList
//
//  Created by Hakob Ghlijyan on 27.08.2024.
//

import SwiftUI
import SwiftData

struct NewTaskView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.presentationMode) var presentationMode

    @State private var title: String = ""
    @State private var isCompleted: Bool = false

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Название")) {
                    TextField("Введите название", text: $title)
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

    func addNewTask() {
        let newTask = ToDoItem(title: title, isCompleted: isCompleted)
        modelContext.insert(newTask) // Вставка новой задачи в контекст
        saveChanges()
    }

    func saveChanges() {
        do {
            try modelContext.save() // Сохранение изменений
        } catch {
            print("Ошибка при добавлении задачи: \(error.localizedDescription)")
        }
    }
}

#Preview {
    ToDoListView()
}
