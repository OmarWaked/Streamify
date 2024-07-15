//
//  NotesView.swift
//  App
//
//  Created by Rayan Waked on 7/13/24.
//

// MARK: - Import
import SwiftUI
import Combine

// MARK: - View
struct NotesView: View {
    @StateObject private var viewModel = NotesViewModel()
    
    var body: some View {
        VStack {
            content
        }
        .environmentObject(viewModel) // Make viewModel available to subviews
    }
}

// MARK: - Extension
private extension NotesView {
    // Content
    var content: some View {
        NavigationView {
            VStack {
                if !viewModel.notes.isEmpty {
                    SearchBar(text: $viewModel.searchText)
                        .padding(.horizontal)
                }
                
                if viewModel.notes.isEmpty {
                    Text("No notes, add one above.")
                        .foregroundColor(.gray)
                        .padding()
                } else {
                    List {
                        ForEach(viewModel.filteredNotes) { note in
                            NavigationLink(destination: NoteDetailView(note: binding(for: note))) {
                                Text(note.title)
                            }
                        }
                        .onDelete(perform: viewModel.deleteNotes)
                    }
                }
            }
            .navigationTitle("Notes")
            .navigationBarItems(trailing: Button(action: {
                viewModel.addNote()
            }) {
                Image(systemName: "plus")
            })
        }
    }
    
    private func binding(for note: Note) -> Binding<Note> {
        guard let noteIndex = viewModel.notes.firstIndex(where: { $0.id == note.id }) else {
            fatalError("Note not found")
        }
        return $viewModel.notes[noteIndex]
    }
}

// MARK: - Preview
#Preview {
    NotesView()
}
