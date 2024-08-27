//
//  ToDoListView.swift
//  TaskTestToDoList
//
//  Created by Hakob Ghlijyan on 27.08.2024.
//

import SwiftUI

// Главный экран приложения, отображающий список задач
struct ToDoListView: View {
    @State private var todoItems: [ToDoItem] = [] // Состояние для хранения списка задач
    @State private var isPresentingNewTaskView = false // Флаг для отображения экрана добавления новой задачи
    @State private var editingTask: ToDoItem? // Состояние для редактируемой задачи
    
    var body: some View {
        NavigationView {
            List {
                ForEach(todoItems) { item in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(item.title)
                                .font(.headline)
                            Text(item.description)
                                .font(.subheadline)
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
                        editingTask = item // Устанавливаем текущую задачу для редактирования
                    }
                }
                .onDelete(perform: deleteTask) // Удаление задачи
            }
            .navigationTitle("ToDo List")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        isPresentingNewTaskView = true
                    }, label: {
                        Image(systemName: "plus")
                    })
                }
            }
            .sheet(isPresented: $isPresentingNewTaskView) {
                NewTaskView(todoItems: $todoItems)
            }
            .sheet(item: $editingTask) { task in
                EditTaskView(todoItems: $todoItems, task: task)
            }
        }
    }

    // Функция удаления задачи
    func deleteTask(at offsets: IndexSet) {
        todoItems.remove(atOffsets: offsets)
    }
    
    // Функция перемещения задачи
    func moveTask(frome source:IndexSet, to destionation: Int) {
        todoItems.move(fromOffsets: source, toOffset: destionation)
    }
}


#Preview {
    ToDoListView()
}
