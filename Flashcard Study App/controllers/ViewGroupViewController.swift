//
//  ViewGroupViewController.swift
//  Flashcard Study App
//
//  Created by Thomas Bruhn on 11/11/24.
//

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
        NavigationView {
            List(collections) { collection in
                NavigationLink(destination: ViewCollectionViewController(collection: collection)) {
                    Text(collection.name ?? "Unknown Collection")
                }
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
    }
}


