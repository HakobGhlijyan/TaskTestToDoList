//
//  ToDoListViewModel.swift
//  TaskTestToDoList
//
//  Created by Hakob Ghlijyan on 27.08.2024.
//

import SwiftUI
import SwiftData
import Combine

@MainActor
final class ToDoListViewModel: ObservableObject {
    @Environment(\.modelContext) private var modelContext
    
    @Published var isPresentingNewTaskView = false
    @Published var editingTask: ToDoItem?
    
    @Published var cancellables: Set<AnyCancellable> = []
    
    @Published var showingSection1 = true
    @Published var showingSection2 = true

    //MARK: - All Func
    
    //Use async
    func loadDataAsync() async {
        do {
            let todos = try await loadTodosFromAsync()
            saveTodos(todos)
            print("Load Data for Async")
        } catch {
            print("Error download data: \(error.localizedDescription)")
        }
    }
    
    //Use combine
    func loadDataCombine() {
        loadTodosFromCombine()
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    print("Error download data: \(error.localizedDescription)")
                }
            }, receiveValue: { todos in
                self.saveTodos(todos)
                print("Load Data for Combine")
            })
            .store(in: &cancellables)
    }
    
    //Use escaping
    func loadDataEscaping() {
        loadTodosFromEscaping { result in
            switch result {
            case .success(let todos):
                DispatchQueue.main.async {
                    self.saveTodos(todos)
                    print("Load Data for Escaping")
                }
            case .failure(let error):
                print("Error download data: \(error.localizedDescription)")
            }
        }
    }

    //All func
    func saveTodos(_ todos: [TodoItemDTO]) {
        for todo in todos {
            let newTask = ToDoItem(title: todo.todo, isCompleted: todo.completed)
            modelContext.insert(newTask)
        }
        do {
            try modelContext.save()
            print("Save Todos Data")
        } catch {
            print("Error save data: \(error.localizedDescription)")
        }
    }

    func saveChanges() {
        do {
            try modelContext.save()
            print("Save Todos Change")
        } catch {
            print("Error delete data: \(error.localizedDescription)")
        }
    }
}

