//
//  Todo.swift
//  TaskTestToDoList
//
//  Created by Hakob Ghlijyan on 27.08.2024.
//

import SwiftUI
import Combine

// Модель для данных, получаемых из API
struct TodoResponse: Codable {
    let todos: [TodoItemDTO]
}

struct TodoItemDTO: Codable {
    let id: Int
    let todo: String
    let completed: Bool
    let userId: Int
}
// Функция для загрузки задач из API Async
func loadTodosFromAsync() async throws -> [TodoItemDTO] {
    let url = URL(string: "https://dummyjson.com/todos")!
    let (data, _) = try await URLSession.shared.data(from: url)
    let todoResponse = try JSONDecoder().decode(TodoResponse.self, from: data)
    return todoResponse.todos
}
// Функция для загрузки задач из API Combine
func loadTodosFromCombine() -> AnyPublisher<[TodoItemDTO], Error> {
    let url = URL(string: "https://dummyjson.com/todos")!
    return URLSession.shared.dataTaskPublisher(for: url)
        .map(\.data)
        .decode(type: TodoResponse.self, decoder: JSONDecoder())
        .map(\.todos)
        .eraseToAnyPublisher()
}

// Функция для загрузки задач из API Escaping
func loadTodosFromEscaping(completion: @escaping (Result<[TodoItemDTO], Error>) -> Void) {
    let url = URL(string: "https://dummyjson.com/todos")!
    let task = URLSession.shared.dataTask(with: url) { data, response, error in
        if let error = error {
            completion(.failure(error))
            return
        }
        guard let data = data else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data"])))
            return
        }
        do {
            // Декодируйте ответ API
            let todoResponse = try JSONDecoder().decode(TodoResponse.self, from: data)
            completion(.success(todoResponse.todos))
        } catch {
            completion(.failure(error))
        }
    }
    task.resume()
}
