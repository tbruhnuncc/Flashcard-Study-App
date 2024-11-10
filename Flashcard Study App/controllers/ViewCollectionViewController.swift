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
    
    var body: some View {
        NavigationView {
            VStack {
                ScrollView {
                    LazyVStack {
                        ForEach(flashcards) { flashcard in
                            FlashcardView(flashcard: flashcard)
                        }
                    }
                    .padding(.horizontal)
                }
                .navigationTitle("Collection")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            showingAddScreen.toggle()
                        } label: {
                            Label("Add flashcard", systemImage: "plus")
                        }
                    }
                }
                .sheet(isPresented: $showingAddScreen) {
                    AddFlashcardViewController()
                }
            }
        }
    }
}

#Preview {
    AddFlashcardViewController()
}

struct FlashcardView: View {
    var flashcard: Flashcard

    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .leading, spacing: 10) {
                Text(flashcard.frontText ?? "Front Text")
                    .font(.headline)
                Text(flashcard.backText ?? "Back Text")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            .padding()
            .frame(width: geometry.size.width - 32) // Adjust the width to have padding on both sides
            .background(Color.white)
            .cornerRadius(10)
            .shadow(radius: 5)
            .padding(.horizontal, 16) // Add horizontal padding so the card does not touch the edges
        }
        .frame(height: 150) // Give a fixed height or use .frame(minHeight: 150)
    }
}

