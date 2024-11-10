//
//  FlashcardController.swift
//  Flashcard Study App
//
//  Created by Thomas Bruhn on 11/2/24.
//

import Foundation
import CoreData

class FlashcardController: ObservableObject {
    let container = NSPersistentContainer(name: "FlashcardModels")
    
    init() {
        container.loadPersistentStores { description, error in
            if let error = error {
                print("CoreData failed to load: \(error.localizedDescription)")
            }
            
        }
    }
}
