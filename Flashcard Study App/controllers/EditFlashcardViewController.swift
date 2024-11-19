import SwiftUI

struct EditFlashcardViewController: View {
    @Environment(\.managedObjectContext) var moc
    @Environment(\.dismiss) var dismiss
    
    @ObservedObject var flashcard: Flashcard
    @State private var frontText: String
    @State private var backText: String
    @State private var image: UIImage?
    @State private var imageData: Data?
    @State private var isImagePickerPresented = false
    
    var onSave: () -> Void
    
    init(flashcard: Flashcard, onSave: @escaping () -> Void) {
        self.flashcard = flashcard
        _frontText = State(initialValue: flashcard.frontText ?? "")
        _backText = State(initialValue: flashcard.backText ?? "")
        if let imageData = flashcard.image, let uiImage = UIImage(data: imageData) {
            _image = State(initialValue: uiImage)
        }
        self.onSave = onSave
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Front Text")) {
                    TextField("Enter front text", text: $frontText)
                }
                Section(header: Text("Back Text")) {
                    TextField("Enter back text", text: $backText)
                }
                Section(header: Text("Image")) {
                    if let image = image {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(maxHeight: 200)
                            .cornerRadius(10)
                    } else {
                        Text("No image selected")
                    }
                    Button("Select Image") {
                        isImagePickerPresented.toggle()
                    }
                }
            }
            .navigationTitle("Edit Flashcard")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveFlashcard()
                        dismiss()
                    }
                }
            }
            .sheet(isPresented: $isImagePickerPresented) {
                EditImagePicker(image: $image)
            }
        }
    }
    
    private func saveFlashcard() {
        flashcard.frontText = frontText
        flashcard.backText = backText
        if let image = image {
            flashcard.image = image.pngData()
        }
        
        do {
            try moc.save()
            onSave() // Call the onSave closure to trigger fetch request
        } catch {
            print("Failed to save flashcard: \(error.localizedDescription)")
        }
    }
}
struct EditImagePicker: UIViewControllerRepresentable {
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: EditImagePicker

        init(parent: EditImagePicker) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let uiImage = info[.originalImage] as? UIImage {
                parent.image = uiImage
            }

            parent.presentationMode.wrappedValue.dismiss()
        }
    }

    @Environment(\.presentationMode) var presentationMode
    @Binding var image: UIImage?

    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
}
