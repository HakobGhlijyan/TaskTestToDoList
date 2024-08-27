//
//  ToDoListView.swift
//  TaskTestToDoList
//
//  Created by Hakob Ghlijyan on 27.08.2024.
//
import SwiftUI
import SwiftData
import Combine

struct ToDoListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(
        sort: \ToDoItem.dateCreated,
        order: .reverse,
        animation: .bouncy
    ) private var todoItems: [ToDoItem]
    @Query(
        filter: #Predicate<ToDoItem> { !$0.isCompleted },
        sort: \ToDoItem.dateCreated, 
        order: .reverse,
        animation: .bouncy
    ) private var todoItemsInProgress: [ToDoItem]


    @State private var isPresentingNewTaskView = false
    @State private var editingTask: ToDoItem?
    
    @AppStorage("dataLoaded") private var dataLoaded = false
    @State private var cancellables: Set<AnyCancellable> = []
    
    @State private var showingSection1 = true
    @State private var showingSection2 = true
    
    var body: some View {
        NavigationView {
            ZStack {
                if !dataLoaded {
                    ProgressView("Загрузка задач...") // Индикатор загрузки
                } else {
                    List {
                        allToDoSection
                        inProgressSectionLayer
                    }
                }
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
                if !dataLoaded {
                    Task {
                        await loadDataAsync()
//                        loadDataCombine()
//                        loadDataEscaping()
                        dataLoaded = true
                    }
                }
            }
        }
    }
}


#Preview {
    ToDoListView()
}

extension ToDoListView {
    private var allToDoSection: some View {
        Section {
            if showingSection1 {
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
        } header: {
            SectionHeader(
                title: "All",
                isOn: $showingSection1,
                onLabel: "Hide",
                offLabel: "Show"
            )
        }
    }
    
    private var inProgressSectionLayer: some View {
        Section {
            if showingSection2 {
                ForEach(todoItemsInProgress) { item in
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
            }
        } header: {
            SectionHeader(
                title: "In Progress",
                isOn: $showingSection2,
                onLabel: "Hide",
                offLabel: "Show"
            )
        }
    }
}

//Func
extension ToDoListView {
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
                saveTodos(todos)
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
                    saveTodos(todos)
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

    func deleteTask(at offsets: IndexSet) {
        for index in offsets {
            let task = todoItems[index]
            modelContext.delete(task)
            print("Delete Data")
        }
        saveChanges()
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
