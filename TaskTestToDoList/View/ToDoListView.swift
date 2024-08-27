//
//  ToDoListView.swift
//  TaskTestToDoList
//
//  Created by Hakob Ghlijyan on 27.08.2024.
//

import SwiftUI
import SwiftData

struct ToDoListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var todoItems: [ToDoItem]

    @State private var isPresentingNewTaskView = false
    @State private var editingTask: ToDoItem?

    var body: some View {
        NavigationView {
            List {
                ForEach(todoItems) { item in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(item.title)
                                .font(.headline)
                            Text("Создана: \(item.dateCreated, formatter: itemFormatter)")
                                .font(.footnote)
                                .foregroundColor(.gray)
                        }
                        Spacer()
                        Image(systemName: item.isCompleted ? "checkmark.circle.fill" : "circle")
                            .foregroundColor(item.isCompleted ? .green : .red)
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        editingTask = item
                    }
                }
                .onDelete(perform: deleteTask)
            }
            .navigationTitle("ToDo List")
            .navigationBarItems(trailing: Button(action: {
                isPresentingNewTaskView = true
            }) {
                Image(systemName: "plus")
            })
            .sheet(isPresented: $isPresentingNewTaskView) {
                NewTaskView()
            }
            .sheet(item: $editingTask) { task in
                EditTaskView(task: task)
            }
        }
    }

    func deleteTask(at offsets: IndexSet) {
        for index in offsets {
            let task = todoItems[index]
            modelContext.delete(task) // Удаление задачи из контекста
        }
    }
}

#Preview {
    ToDoListView()
}
