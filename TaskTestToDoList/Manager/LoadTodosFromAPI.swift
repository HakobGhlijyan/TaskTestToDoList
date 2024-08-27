//
//  LoadTodosFromAPI.swift
//  TaskTestToDoList
//
//  Created by Hakob Ghlijyan on 27.08.2024.
//

import SwiftUI
import SwiftData

// Функция для загрузки задач из API
func loadTodosFromAPI(completion: @escaping (Result<[TodoItemDTO], Error>) -> Void) {
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
