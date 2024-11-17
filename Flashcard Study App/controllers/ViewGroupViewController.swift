import SwiftUI

struct ViewGroupViewController: View {
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: []) var collections: FetchedResults<Collection>
    
    @State private var showingAddScreen = false
    var group: Group
    
    init(group: Group) {
        self.group = group
        _collections = FetchRequest(
            sortDescriptors: [],
            predicate: NSPredicate(format: "group == %@", group)
        )
    }
    
    var body: some View {
        List {
            ForEach(collections) { collection in
                NavigationLink(destination: ViewCollectionViewController(collection: collection)) {
                    Text(collection.name ?? "Unknown Collection")
                }
            }
            .onDelete(perform: deleteCollection)
        }
        .navigationTitle(group.name ?? "Group")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    showingAddScreen.toggle()
                } label: {
                    Label("Add a Collection", systemImage: "plus")
                }
            }
        }
        .sheet(isPresented: $showingAddScreen) {
            AddCollectionViewController(group: group)
        }
    }
    
    // Delete a collection when user swipes
    func deleteCollection(at offsets: IndexSet) {
        for index in offsets {
            let collection = collections[index]
            moc.delete(collection)
        }
        
        do {
            try moc.save()
        } catch {
            print("Error saving context after deletion: \(error.localizedDescription)")
        }
    }
}
