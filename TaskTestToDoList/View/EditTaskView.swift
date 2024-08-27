//
//  EditTaskView.swift
//  TaskTestToDoList
//
//  Created by Hakob Ghlijyan on 27.08.2024.
//

import SwiftUI
import SwiftData

struct EditTaskView: View {
    @Environment(\.modelContext) private var modelContext
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

    func saveChanges() {
        task.title = title
        task.isCompleted = isCompleted
        // Сохранение изменений после редактирования
        do {
            try modelContext.save()
        } catch {
            print("Ошибка при сохранении изменений: \(error.localizedDescription)")
        }
    }
}

#Preview {
    ToDoListView()
}
