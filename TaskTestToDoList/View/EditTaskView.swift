//
//  EditTaskView.swift
//  TaskTestToDoList
//
//  Created by Hakob Ghlijyan on 27.08.2024.
//

import SwiftUI
import SwiftData

struct EditTaskView: View {
    @Environment(\.modelContext) private var modelContext // Доступ к контексту SwiftData
    @Environment(\.presentationMode) var presentationMode
    var task: ToDoItem

    @State private var title: String
    @State private var isCompleted: Bool

    init(task: ToDoItem) {
        self.task = task
        self._title = State(initialValue: task.title)
        self._isCompleted = State(initialValue: task.isCompleted)
    }

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
        // Изменения автоматически отслеживаются в контексте
        task.title = title
        task.isCompleted = isCompleted
    }
}

#Preview {
    ToDoListView()
}
