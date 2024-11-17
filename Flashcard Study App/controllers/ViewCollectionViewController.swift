//
//  AddFlashcardViewController.swift
//  Flashcard Study App
//
//  Created by Thomas Bruhn on 11/2/24.
//

import SwiftUI

struct ViewCollectionViewController: View {
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: []) var flashcards: FetchedResults<Flashcard>
    
    @State private var showingAddScreen = false
    @State private var showingEditScreen = false
    @State private var selectedFlashcard: Flashcard?
    
    var collection: Collection
    
    init(collection: Collection) {
        self.collection = collection
        _flashcards = FetchRequest(
            sortDescriptors: [],
            predicate: NSPredicate(format: "collection == %@", collection)
        )
    }
    
    var body: some View {
        NavigationView {
            VStack {
                ScrollView {
                    LazyVStack {
                        ForEach(flashcards) { flashcard in
                            FlashcardView(flashcard: flashcard)
                                .contextMenu {
                                    Button(action: {
                                        // Edit action
                                        selectedFlashcard = flashcard
                                        showingEditScreen = true
                                    }) {
                                        Label("Edit", systemImage: "pencil")
                                    }
                                    Button(role: .destructive) {
                                        if let index = flashcards.firstIndex(of: flashcard) {
                                            deleteFlashcards(at: IndexSet(integer: index))
                                        }
                                    } label: {
                                        Label("Delete", systemImage: "trash")
                                    }
                                }
                        }
                    }
                    .padding(.horizontal)
                }
                .navigationTitle("Collection")
                .toolbar {
                    ToolbarItem(placement: .primaryAction) {
                        Button {
                            showingAddScreen.toggle()
                        } label: {
                            Label("Add flashcard", systemImage: "plus")
                        }
                    }
                }
                .sheet(isPresented: $showingAddScreen) {
                    AddFlashcardViewController(collection: collection)
                }
//                .sheet(isPresented: $showingEditScreen) {
//                    if let selectedFlashcard = selectedFlashcard {
//                        EditFlashcardViewController(flashcard: selectedFlashcard)
//                    }
//                }
            }
        }
    }
    
    private func deleteFlashcards(at offsets: IndexSet) {
        for index in offsets {
            let flashcard = flashcards[index]
            moc.delete(flashcard)
        }
        do {
            try moc.save()
        } catch {
            print("Failed to delete flashcards: \(error.localizedDescription)")
        }
    }
}

struct FlashcardView: View {
    var flashcard: Flashcard
    @State private var showingBack = false

    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .leading, spacing: 10) {
                if showingBack {
                    Text(flashcard.backText ?? "Back Text")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                } else {
                    Text(flashcard.frontText ?? "Front Text")
                }
            }
            .padding()
            .frame(width: geometry.size.width - 32) // Adjust the width to have padding on both sides
            .background(Color.white)
            .cornerRadius(10)
            .shadow(radius: 5)
            .padding(.horizontal, 16) // Add horizontal padding so the card does not touch the edges
            .onTapGesture {
                withAnimation {
                    showingBack.toggle()
                }
            }
        }
        .frame(height: 150) // Give a fixed height or use .frame(minHeight: 150)
    }
}


