//
//  TodoModel.swift
//  Solis
//
//  Created by Rayan Waked on 7/13/24.
//

// MARK: - Import
import SwiftUI
import Combine

// MARK: - To-do Item Structure
struct TodoItem: Identifiable, Codable, Equatable {
    let id: UUID
    var title: String
    var isCompleted: Bool
    
    init(id: UUID = UUID(), title: String, isCompleted: Bool) {
        self.id = id
        self.title = title
        self.isCompleted = isCompleted
    }
    
    static func == (lhs: TodoItem, rhs: TodoItem) -> Bool {
        lhs.id == rhs.id
    }
}

// MARK: - To-do Item Functionality
class TodoViewModel: ObservableObject {
    @Published var todos: [TodoItem] = []
    @Published var searchText: String = ""
    
    private let todosKey = "todos"
    
    init() {
        loadTodos()
    }
    
    var filteredTodos: [TodoItem] {
        if searchText.isEmpty {
            return todos
        } else {
            return todos.filter { $0.title.lowercased().contains(searchText.lowercased()) }
        }
    }
    
    func addTodo() {
        let newTodo = TodoItem(title: "New Task", isCompleted: false)
        todos.append(newTodo)
        saveTodos()
    }
    
    func deleteTodos(at offsets: IndexSet) {
        todos.remove(atOffsets: offsets)
        saveTodos()
    }
    
    func update(todo: TodoItem) {
        if let index = todos.firstIndex(where: { $0.id == todo.id }) {
            todos[index] = todo
            saveTodos()
        }
    }
    
    func toggleCompletion(for todo: TodoItem) {
        if let index = todos.firstIndex(where: { $0.id == todo.id }) {
            todos[index].isCompleted.toggle()
            saveTodos()
        }
    }
    
    private func saveTodos() {
        if let encoded = try? JSONEncoder().encode(todos) {
            UserDefaults.standard.set(encoded, forKey: todosKey)
        }
    }
    
    private func loadTodos() {
        if let savedData = UserDefaults.standard.data(forKey: todosKey),
           let decoded = try? JSONDecoder().decode([TodoItem].self, from: savedData) {
            todos = decoded
        } else {
            todos = [] // Ensuring todos is initialized if decoding fails
        }
    }
}
