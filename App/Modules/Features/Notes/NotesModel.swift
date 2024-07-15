//
//  NoteModel.swift
//  Solis
//
//  Created by Rayan Waked on 7/13/24.
//
// MARK: - Import
import SwiftUI
import Combine

// MARK: - Note Structure
struct Note: Identifiable, Codable {
    let id = UUID()
    var title: String
    var content: String
}

// MARK: - Note Functionality
class NotesViewModel: ObservableObject {
    @Published var notes: [Note] = []
    @Published var searchText: String = ""
    
    private let notesKey = "notes"
    
    init() {
        loadNotes()
    }
    
    var filteredNotes: [Note] {
        if searchText.isEmpty {
            return notes
        } else {
            return notes.filter { $0.title.lowercased().contains(searchText.lowercased()) }
        }
    }
    
    func addNote() {
        let newNote = Note(title: "New Note", content: "")
        notes.append(newNote)
        saveNotes()
    }
    
    func deleteNotes(at offsets: IndexSet) {
        notes.remove(atOffsets: offsets)
        saveNotes()
    }
    
    func deleteNote(_ note: Note) {
        if let index = notes.firstIndex(where: { $0.id == note.id }) {
            notes.remove(at: index)
            saveNotes()
        }
    }
    
    func updateNote() {
        saveNotes()
    }
    
    private func saveNotes() {
        if let encoded = try? JSONEncoder().encode(notes) {
            UserDefaults.standard.set(encoded, forKey: notesKey)
        }
    }
    
    private func loadNotes() {
        if let savedData = UserDefaults.standard.data(forKey: notesKey),
           let decoded = try? JSONDecoder().decode([Note].self, from: savedData) {
            notes = decoded
        }
    }
}
