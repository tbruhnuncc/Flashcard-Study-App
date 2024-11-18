//
//  AddFlashcardViewController.swift
//  Flashcard Study App
//
//  Created by Thomas Bruhn on 11/2/24.
//

import SwiftUI
import UIKit

struct AddFlashcardViewController: View {
    @Environment(\.managedObjectContext) var moc
    @Environment(\.dismiss) var dismiss
    
    var collection: Collection
    
    @State private var frontText = ""
    @State private var backText = ""
    @State private var showToast = false
    @State private var toastMessage = ""
    @State private var imageData: Data? // To store the selected image data
    @State private var isImagePickerPresented = false // To control the image picker
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Text on the front of the flashcard", text: $frontText)
                    TextField("Text on the back of the flashcard", text: $backText)
                } header: {
                    Text("Fill out the front and back of the flashcard")
                }
                
                Section {
                    // Button to choose an image
                    Button("Select Image") {
                        isImagePickerPresented.toggle()
                    }
                    .padding()
                    
                    if let imageData, let uiImage = UIImage(data: imageData) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 200, height: 200)
                            .cornerRadius(10)
                            .padding()
                    } else {
                        Text("No image selected")
                            .foregroundColor(.gray)
                    }
                } header: {
                    Text("Add an image (optional)")
                }

                Section {
                    Button ("Save") {
                        if frontText.isEmpty || backText.isEmpty {
                            // Show the toast message if fields are empty
                            toastMessage = "Please fill out both the front and back of the flashcard."
                            showToast = true
                        } else {
                            let newFlashcard = Flashcard(context: moc)
                            newFlashcard.id = UUID()
                            newFlashcard.frontText = frontText
                            newFlashcard.backText = backText
                            newFlashcard.collection = collection
                            
                            // If an image is selected, save it
                            if let imageData = imageData {
                                newFlashcard.image = imageData
                            }
                            
                            do {
                                try moc.save()
                                dismiss()
                            } catch {
                                print("Error saving flashcard: \(error.localizedDescription)")
                            }
                        }
                    }
                }
            }
        }
        .overlay(
            ToastView(message: toastMessage, isVisible: $showToast)
        )
        .sheet(isPresented: $isImagePickerPresented) {
            ImagePicker(imageData: $imageData)
        }
    }
}

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var imageData: Data?
    
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        @Binding var imageData: Data?
        
        init(imageData: Binding<Data?>) {
            _imageData = imageData
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let selectedImage = info[.originalImage] as? UIImage {
                imageData = selectedImage.jpegData(compressionQuality: 1.0)
            }
            picker.dismiss(animated: true)
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true)
        }
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(imageData: $imageData)
    }
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = .photoLibrary
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
}
