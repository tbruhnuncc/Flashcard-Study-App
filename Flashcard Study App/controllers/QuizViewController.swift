import SwiftUI

struct QuizViewController: View {
    @Environment(\.managedObjectContext) var moc
    @FetchRequest var flashcards: FetchedResults<Flashcard>
    @Environment(\.dismiss) var dismiss
    
    @State private var currentIndex = 0
    @State private var userAnswer = ""
    @State private var score = 0
    @State private var showingResult = false
    @State private var completed = false
    @State private var showingCorrectAnswer = false // Track if the correct answer is being shown
    @State private var useFrontTextAsQuestion = true // Track whether to use front or back text as the question
    @State private var quizStarted = false // Track if the quiz has started
    @State private var showingSettings = false // Track if the settings modal is shown
    
    var collection: Collection
    
    init(collection: Collection) {
        self.collection = collection
        _flashcards = FetchRequest(
            sortDescriptors: [],
            predicate: NSPredicate(format: "collection == %@", collection)
        )
    }
    
    var body: some View {
            NavigationView {
                VStack {
                    if completed {
                        Text("Quiz Completed!")
                            .font(.largeTitle)
                            .padding()
                        Text("Your score: \(score) out of \(flashcards.count)")
                            .font(.title)
                            .padding()
                        Button("Restart Quiz") {
                            restartQuiz()
                        }
                        .padding()
                    } else if !quizStarted {
                        Button("Start Quiz") {
                            showingSettings.toggle()
                        }
                        .padding()
                    } else if flashcards.indices.contains(currentIndex) {
                        VStack {
                            Text("Question \(currentIndex + 1) of \(flashcards.count)")
                                .font(.headline)
                                .padding()
                            Text(useFrontTextAsQuestion ? (flashcards[currentIndex].frontText ?? "Front Text") : (flashcards[currentIndex].backText ?? "Back Text"))
                                .font(.title)
                                .padding()
                            
                            if showingCorrectAnswer {
                                Text("Correct Answer: \(useFrontTextAsQuestion ? (flashcards[currentIndex].backText ?? "Back Text") : (flashcards[currentIndex].frontText ?? "Front Text"))")
                                    .font(.subheadline)
                                    .foregroundColor(.red)
                                    .padding()
                                Button("Next") {
                                    goToNextQuestion()
                                }
                                .padding()
                            } else {
                                TextField("Your answer", text: $userAnswer)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .padding()
                                Button("Submit") {
                                    checkAnswer(for: flashcards[currentIndex])
                                }
                                .padding()
                            }
                        }
                    } else {
                        Text("No flashcards available.")
                            .font(.headline)
                            .padding()
                    }
                }
                .navigationTitle("Quiz")
                .toolbar {
                    ToolbarItem(placement: .primaryAction) {
                        Button("End Quiz") {
                            dismiss()
                        }
                    }
                }
                .alert(isPresented: $showingSettings) {
                    Alert(
                        title: Text("Choose Quiz Settings"),
                        message: Text("Would you like to use the front text or the back text as the question?"),
                        primaryButton: .default(Text("Front Text")) {
                            useFrontTextAsQuestion = true
                            quizStarted = true
                        },
                        secondaryButton: .default(Text("Back Text")) {
                            useFrontTextAsQuestion = false
                            quizStarted = true
                        }
                    )
                }
            }
        }
    
    private func checkAnswer(for flashcard: Flashcard) {
        let correctAnswer = useFrontTextAsQuestion ? flashcard.backText : flashcard.frontText
        if userAnswer.lowercased() == correctAnswer?.lowercased() {
            score += 1
            goToNextQuestion()
        } else {
            showingCorrectAnswer = true
        }
    }
    
    private func goToNextQuestion() {
        userAnswer = ""
        currentIndex += 1
        showingCorrectAnswer = false
        if currentIndex >= flashcards.count {
            completed = true
        }
    }
    
    private func restartQuiz() {
        score = 0
        currentIndex = 0
        completed = false
        userAnswer = ""
        showingCorrectAnswer = false
    }
}
