//
//  HomePageViewController.swift
//  Flashcard Study App
//
//  Created by Thomas Bruhn on 11/11/24.
//

import SwiftUI

struct HomePageViewController: View {
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: []) var groups: FetchedResults<Group>
    
    @State private var showingAddScreen = false
    
    
    var body: some View {
        NavigationView {
            List(groups) { group in
                NavigationLink(destination: ViewGroupViewController(group: group)) {
                    Text(group.name ?? "Unknown Collection")
                }
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

}

#Preview {
    HomePageViewController()
}
