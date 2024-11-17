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
        }
        .navigationTitle(collection.name ?? "Collection")
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
            AddFlashcardViewController(collection: collection)
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
            VStack {
                if showingBack {
                    Text(flashcard.backText ?? "Back Text")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center) // Make the text fill the space
                } else {
                    Text(flashcard.frontText ?? "Front Text")
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center) // Same for the front text
                }
            }
            .padding() // Padding around the whole view, not inside the frame
            .background(Color.white)
            .cornerRadius(10)
            .shadow(radius: 5)
            .onTapGesture {
                withAnimation {
                    showingBack.toggle()
                }
            }
            .frame(
                minHeight: 180, // Set minimum height
                maxHeight: 250, // Set max height
                alignment: .center // Center the entire flashcard
            )
        }
        .frame(minHeight: 180) // Ensure the GeometryReader itself has a minimum height
    }
}


