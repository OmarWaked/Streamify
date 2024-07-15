//
//  NoteDetailView.swift
//  App
//
//  Created by Omar Waked on 7/14/24.
//

import Foundation
import SwiftUI

// MARK: - Detailed Note View
struct NoteDetailView: View {
    @Binding var note: Note
    @EnvironmentObject var viewModel: NotesViewModel
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Title")
                .font(.headline)
                .padding(.horizontal)
                .padding(.top)
            
            TextField("Title", text: $note.title)
                .font(.title)
                .padding(.horizontal)
                .textFieldStyle(PlainTextFieldStyle())
                .onChange(of: note.title) { _ in
                    viewModel.updateNote()
                }
            
            Divider()
                .padding(.horizontal)
            
            Text("Content")
                .font(.headline)
                .padding(.horizontal)
                .padding(.top)
            
            TextEditor(text: $note.content)
                .padding(.horizontal)
                .padding(.bottom)
                .onChange(of: note.content) { _ in
                    viewModel.updateNote()
                }
            
            Spacer()
        }
        .navigationTitle("Details")
        .navigationBarItems(trailing: Button(action: {
            viewModel.deleteNote(note)
            presentationMode.wrappedValue.dismiss()
        }) {
            Image(systemName: "trash")
                .foregroundColor(.red)
        })
    }
}
