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
    @Environment(\.dismiss) private var dismiss
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
                dismiss()
            }, trailing: Button("Сохранить") {
                saveChanges()
                dismiss()
            })
        }
    }

    func saveChanges() {
        task.title = title
        task.isCompleted = isCompleted
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
