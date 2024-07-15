//
//  TodoView.swift
//  App
//
//  Created by Rayan Waked on 7/13/24.
//

// MARK: - Import
import SwiftUI

// MARK: - View
struct TodoView: View {
    @StateObject private var viewModel = TodoViewModel()
    @State private var showingEditView = false
    @State private var currentTodo: TodoItem?
    
    var body: some View {
        NavigationView {
            VStack {
                if !viewModel.todos.isEmpty {
                    SearchBar(text: $viewModel.searchText)
                        .padding(.horizontal)
                }
                
                if viewModel.todos.isEmpty {
                    Text("No to-do items, add one above.")
                        .foregroundColor(.gray)
                        .padding()
                } else {
                    List {
                        ForEach(viewModel.filteredTodos) { todo in
                            HStack {
                                Button(action: {
                                    viewModel.toggleCompletion(for: todo)
                                }) {
                                    Image(systemName: todo.isCompleted ? "checkmark.circle.fill" : "circle")
                                        .foregroundColor(todo.isCompleted ? .green : .primary)
                                }
                                .buttonStyle(BorderlessButtonStyle())
                                
                                Text(todo.title)
                                    .foregroundColor(.primary)
                                    .strikethrough(todo.isCompleted)
                                    .opacity(todo.isCompleted ? 0.8 : 1.0)
                                    .onTapGesture {
                                        currentTodo = todo
                                        showingEditView = true
                                    }
                            }
                        }
                        .onDelete(perform: viewModel.deleteTodos)
                    }
                }
            }
            .navigationTitle("To-Do")
            .navigationBarItems(trailing: Button(action: {
                viewModel.addTodo()
                currentTodo = viewModel.todos.last
                showingEditView = true
            }) {
                Image(systemName: "plus")
            })
            .sheet(isPresented: $showingEditView) {
                if let currentTodo = currentTodo {
                    AddEditTodoView(todo: currentTodo, viewModel: viewModel)
                }
            }
        }
    }
}

// MARK: - Add/Edit Todo View
struct AddEditTodoView: View {
    @State var todo: TodoItem
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: TodoViewModel
    
    var body: some View {
        NavigationView {
            Form {
                TextField("Title", text: $todo.title)
                    .foregroundColor(.primary)
                Toggle(isOn: $todo.isCompleted) {
                    Text("Completed")
                        .foregroundColor(.primary)
                }
            }
            .navigationTitle(todo.title.isEmpty ? "New Task" : "Edit Task")
            .navigationBarItems(leading: Button("Cancel") {
                presentationMode.wrappedValue.dismiss()
            }, trailing: Button("Save") {
                viewModel.update(todo: todo)
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
}

// MARK: - Preview
#Preview {
    TodoView()
}
