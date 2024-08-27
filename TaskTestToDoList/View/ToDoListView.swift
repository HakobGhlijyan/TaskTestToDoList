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
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        isPresentingNewTaskView = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
                ToolbarItem(placement: .topBarLeading) {
                    EditButton()
                }
            }
            .sheet(isPresented: $isPresentingNewTaskView) {
                NewTaskView()
            }
            .sheet(item: $editingTask) { task in
                EditTaskView(task: task)
            }
            .onAppear {
                loadInitialData()
            }
        }
    }

    func loadInitialData() {
        loadTodosFromAPI { result in
            switch result {
            case .success(let todos):
                DispatchQueue.main.async {
                    saveTodos(todos)
                }
            case .failure(let error):
                print("Ошибка при загрузке данных: \(error.localizedDescription)")
            }
        }
    }

    func saveTodos(_ todos: [TodoItemDTO]) {
        for todo in todos {
            let newTask = ToDoItem(title: todo.todo, isCompleted: todo.completed)
            modelContext.insert(newTask)
        }
        do {
            try modelContext.save()
        } catch {
            print("Ошибка при сохранении задач: \(error.localizedDescription)")
        }
    }

    func deleteTask(at offsets: IndexSet) {
        for index in offsets {
            let task = todoItems[index]
            modelContext.delete(task)
        }
        saveChanges()
    }

    func saveChanges() {
        do {
            try modelContext.save()
        } catch {
            print("Ошибка при удалении задач: \(error.localizedDescription)")
        }
    }
}

#Preview {
    ToDoListView()
}
