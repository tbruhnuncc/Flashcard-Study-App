//
//  AddCollectionViewController.swift
//  Flashcard Study App
//
//  Created by Thomas Bruhn on 11/11/24.
//

import SwiftUI

struct AddCollectionViewController: View {
    @Environment(\.managedObjectContext) var moc
    @Environment(\.dismiss) var dismiss
    
    var group: Group

    @State private var nameText = ""
    @State private var showToast = false
    @State private var toastMessage = ""

    var body: some View {
        NavigationView {
            Form {
                Section {
                    
                    TextField("Collection Name", text: $nameText)
                } header: {
                    Text("Enter a name for the collection")
                }
                Section {
                    Button ("Save") {
                        if nameText.isEmpty {
                            // Show the toast message if fields are empty
                            toastMessage = "Please Enter a name for the collection"
                            showToast = true
                        } else {
                            let newCollection = Collection(context: moc)
                            newCollection.id = UUID()
                            newCollection.name = nameText // Updated to use front
                            newCollection.group = group
                            
                            try? moc.save()
                            dismiss()
                        }
                    }
                }
            }
        }
        .navigationTitle("Create a Collection")
        .overlay(
                        ToastView(message: toastMessage, isVisible: $showToast)
        )
    }
}
