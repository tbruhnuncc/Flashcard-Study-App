import SwiftUI

struct ContentView: View {
    @Binding var flashCardGroup: FlashCardGroup

    var body: some View {
        VStack {
            Text(flashCardGroup.name)
                .font(.largeTitle)
                .padding()

            ScrollView {
                ForEach(flashCardGroup.flashcards) { flashcard in
                    FlashCardView(flashcard: flashcard)
                        .padding(.bottom, 10)
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    @State static var sampleFlashCardGroup = FlashCardGroup(
        name: "Sample Group",
        flashcards: [
            FlashCard(frontText: "Sample Front", backText: "Sample Back")
        ]
    )

    static var previews: some View {
        ContentView(flashCardGroup: $sampleFlashCardGroup)
    }
}


struct FlashCardView: View {
    var flashcard: FlashCard

    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .leading, spacing: 10) {
                Text(flashcard.frontText)
                    .font(.headline)
                    .foregroundColor(Color.black)
                Text(flashcard.backText)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            .padding()
            .frame(width: geometry.size.width - 32)
            .background(Color.white)
            .cornerRadius(10)
            .shadow(radius: 5)
            .padding(.horizontal, 16)
        }
        .frame(height: 150)
    }
}
