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
    @StateObject private var vm = ToDoListViewModel()
    
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

    @AppStorage("dataLoaded") private var dataLoaded = false
    
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
                        vm.isPresentingNewTaskView = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
                ToolbarItem(placement: .topBarLeading) {
                    EditButton()
                }
            }
            .sheet(isPresented: $vm.isPresentingNewTaskView) {
                NewTaskView()
            }
            .sheet(item: $vm.editingTask) { task in
                EditTaskView(task: task)
            }
            .onAppear {
                vm.setup(context: modelContext)
                
                if !dataLoaded {
                    Task {
                        await vm.loadDataAsync()
//                        vm.loadDataCombine()
//                        vm.loadDataEscaping()
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
            if vm.showingSection1 {
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
                        vm.editingTask = item
                    }
                }
                .onDelete(perform: deleteTask)
            }
        } header: {
            SectionHeader(
                title: "All",
                isOn: $vm.showingSection1,
                onLabel: "Hide",
                offLabel: "Show"
            )
        }
    }
    
    private var inProgressSectionLayer: some View {
        Section {
            if vm.showingSection2 {
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
                        vm.editingTask = item
                    }
                }
            }
        } header: {
            SectionHeader(
                title: "In Progress",
                isOn: $vm.showingSection2,
                onLabel: "Hide",
                offLabel: "Show"
            )
        }
    }
}

//Func deleteTask
extension ToDoListView {
    func deleteTask(at offsets: IndexSet) {
        for index in offsets {
            let task = todoItems[index]
            modelContext.delete(task)
            print("Delete Data")
        }
        vm.saveChanges()
    }
}
