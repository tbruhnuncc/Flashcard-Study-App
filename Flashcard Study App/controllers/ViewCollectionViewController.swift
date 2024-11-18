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
        VStack {
            if showingBack {
                // Show back content: image + back text
                VStack {
                    if let imageData = flashcard.image, let uiImage = UIImage(data: imageData) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: .infinity, maxHeight: 250) // Use max width and reasonable height for image
                            .cornerRadius(10)
                    }
                    Text(flashcard.backText ?? "Back Text")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .padding(.top, 10)
                }
                .padding()
                .frame(maxWidth: .infinity, maxHeight: .infinity) // Ensure the back view expands to fill space
            } else {
                // Show front content: text
                Text(flashcard.frontText ?? "Front Text")
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity, maxHeight: .infinity) // Ensure the front text also fills the space
            }
        }
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 5)
        .padding(.horizontal, 16)
        .onTapGesture {
            withAnimation {
                showingBack.toggle()
            }
        }
        .frame(height: 300) // Fixed height for the card
    }
}



