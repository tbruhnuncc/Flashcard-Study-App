//
//  AddFlashcardViewController.swift
//  Flashcard Study App
//
//  Created by Thomas Bruhn on 11/2/24.
//

import SwiftUI

struct AddFlashcardViewController: View {
    @Environment(\.managedObjectContext) var moc
    @Environment(\.dismiss) var dismiss
    
    var collection: Collection
    
    @State private var frontText = ""
    @State private var backText = ""
    @State private var showToast = false
    @State private var toastMessage = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    
                    TextField("Text on the front of the flashcard", text: $frontText)
                    TextField("Text on the back of the flashcard", text: $backText)
                } header: {
                    Text("Fill out the front and back of the flashcard")
                }
                Section {
                    Button ("Save") {
                        if frontText.isEmpty || backText.isEmpty {
                            // Show the toast message if fields are empty
                            toastMessage = "Please fill out both the front and back of the flashcard."
                            showToast = true
                        } else {
                            let newFlashcard = Flashcard(context: moc)
                            newFlashcard.id = UUID()
                            newFlashcard.frontText = frontText // Updated to use front
                            newFlashcard.backText = backText   // Updated to use back
                            newFlashcard.collection = collection
                            
                            try? moc.save()
                            dismiss()
                        }
                    }
                }
            }
        }
        .overlay(
                        ToastView(message: toastMessage, isVisible: $showToast)
        )
    }
}
