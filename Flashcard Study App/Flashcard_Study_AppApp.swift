//
//  Flashcard_Study_AppApp.swift
//  Flashcard Study App
//
//  Created by Thomas Bruhn on 10/7/24.
//

import SwiftUI

@main
struct Flashcard_Study_AppApp: App {
    @State private var flashCardController = FlashcardController()
    var body: some Scene {
        WindowGroup {
            HomePageViewController()
                .environment(\.managedObjectContext, flashCardController.container.viewContext)
        }
    }
}

