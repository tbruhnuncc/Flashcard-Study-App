//
//  ToastView.swift
//  Flashcard Study App
//
//  Created by Thomas Bruhn on 11/2/24.
//

import SwiftUI

struct ToastView: View {
    var message: String
        @Binding var isVisible: Bool
        
        var body: some View {
            if isVisible {
                Text(message)
                    .padding()
                    .background(Color.black.opacity(0.7))
                    .foregroundColor(.white)
                    .cornerRadius(8)
                    .animation(.easeInOut(duration: 0.3))
                    .transition(.opacity)
                    .padding(.bottom, 50) // Positioning above the bottom
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            withAnimation {
                                isVisible = false
                            }
                        }
                    }
            }
        }
}
