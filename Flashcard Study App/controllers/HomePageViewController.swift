import SwiftUI

struct HomePageViewController: View {
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: []) var groups: FetchedResults<Group>
    
    @State private var showingAddScreen = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(groups) { group in
                    NavigationLink(destination: ViewGroupViewController(group: group)) {
                        Text(group.name ?? "Unknown Group")
                    }
                }
                .onDelete(perform: deleteGroup)
            }
            .navigationTitle("Flashcard Study App")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingAddScreen.toggle()
                    } label: {
                        Label("Add a Group", systemImage: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddScreen) {
                AddGroupViewController()
            }
        }
    }
    
    func deleteGroup(at offsets: IndexSet) {
        for index in offsets {
            let group = groups[index]
            moc.delete(group)
        }
        
        do {
            try moc.save()
        } catch {
            print("Error saving context after deletion: \(error.localizedDescription)")
        }
    }
}
