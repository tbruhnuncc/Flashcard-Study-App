//
//  AddGroupViewController.swift
//  Flashcard Study App
//
//  Created by Thomas Bruhn on 11/11/24.
//

import SwiftUI

struct AddGroupViewController: View {
    @Environment(\.managedObjectContext) var moc
    @Environment(\.dismiss) var dismiss

    @State private var nameText = ""
    @State private var showToast = false
    @State private var toastMessage = ""

    var body: some View {
        NavigationView {
            Form {
                Section {
                    
                    TextField("Group Name", text: $nameText)
                } header: {
                    Text("Enter a name for the Group")
                }
                Section {
                    Button ("Save") {
                        if nameText.isEmpty {
                            // Show the toast message if fields are empty
                            toastMessage = "Please Enter a name for the group"
                            showToast = true
                        } else {
                            let newGroup = Group(context: moc)
                            newGroup.id = UUID()
                            newGroup.name = nameText // Updated to use front
                            
                            try? moc.save()
                            dismiss()
                        }
                    }
                }
            }
        }
        .navigationTitle("Create a Group")
        .overlay(
                        ToastView(message: toastMessage, isVisible: $showToast)
        )
    }
}
