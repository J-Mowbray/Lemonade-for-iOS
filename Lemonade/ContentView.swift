//
//  ContentView.swift
//  Lemonade
//
//  Created by Jamie Mowbray on 12/10/2024.
//

import SwiftUI

// Enum to define the different steps in the game
enum GameStep {
    case pickLemon
    case squeezeLemon
    case drinkLemonade
    case restart
}

// Main ContentView struct for the game
struct ContentView: View {
    // State variables to track the current game step, squeeze count, and squashed lemons count
    @State private var currentStep = GameStep.pickLemon
    @State private var squeezeCount = 0
    @State private var squashedLemons = 0

    var body: some View {
        ZStack {
            // Background image for the app
            Image("Wallpaper")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
                .opacity(1.0)

            VStack {
                // Display the count of squashed lemons at the top
                Text("Lemons squashed: \(squashedLemons)")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.black) // Text color
                    .padding(10)
                    .background(Color.white.opacity(0.7)) // Semi-transparent background for visibility
                    .cornerRadius(8)
                    .padding(.top, 5) // Adjusted padding to position it higher

                Spacer()

                // Switch statement to determine what to display based on the current game step
                switch currentStep {
                case .pickLemon:
                    LemonadeView(textLabel: "Tap the lemon tree \n   to pick a lemon! 🍋",
                                 imageName: "lemon_tree",
                                 contentDescription: "Lemon tree content description",
                                 action: {
                                     // Generate a random squeeze count when a lemon is picked
                                     squeezeCount = Int.random(in: 2...9)
                                     currentStep = .squeezeLemon // Move to the squeeze step
                                 })
                case .squeezeLemon:
                    LemonadeView(textLabel: "Tap the lemon to squeeze it!\nWe're making tasty lemonade!",
                                 imageName: "lemon_squeeze",
                                 contentDescription: "Lemon content description",
                                 action: {
                                     // Decrease squeeze count and update game state
                                     if squeezeCount > 0 {
                                         squeezeCount -= 1
                                         if squeezeCount == 0 {
                                             squashedLemons += 1 // Increment squashed lemons count
                                             currentStep = .drinkLemonade // Move to drink step
                                         }
                                     }
                                 })
                case .drinkLemonade:
                    LemonadeView(textLabel: """
                        Mmm, tasty lemonade!
                            Tap the glass to drink it! 😎
                        """,
                                 imageName: "lemon_drink",
                                 contentDescription: "Glass full content description",
                                 action: { currentStep = .restart }) // Move to restart step
                case .restart:
                    LemonadeView(textLabel: "Oh no! You drank it all! 😢\nTap the empty glass to start again!",
                                 imageName: "lemon_restart",
                                 contentDescription: "Empty glass content description",
                                 action: {
                                     currentStep = .pickLemon // Restart the game
                                 })
                }
                
                Spacer() // Add space at the bottom
            }
        }
    }
}

// LemonadeView struct to display the current step information
struct LemonadeView: View {
    let textLabel: String // Text to display
    let imageName: String // Image name to display
    let contentDescription: String // Accessibility description
    let action: () -> Void // Action to perform on tap

    var body: some View {
        VStack {
            // Display the text label with styling
            Text(textLabel)
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.black) // Text color
                .padding(10)
                .background(Color.white.opacity(0.7)) // Semi-transparent background
                .cornerRadius(8)
                .multilineTextAlignment(.center) // Center text

            // Display the image
            Image(imageName)
                .resizable()
                .scaledToFit()
                .frame(height: 150) // Fixed height for images
                .accessibilityLabel(contentDescription) // Set accessibility label
                .padding(16)
                .tapFeedback(action: action) // Add tap feedback functionality
        }
        .padding(.bottom, 40) // Padding to separate from the next element
        .frame(maxWidth: .infinity, alignment: .center) // Center the entire VStack
    }
}

// Tap feedback modifier to provide visual feedback on taps
struct TapFeedbackModifier: ViewModifier {
    @State private var isTapped = false // State to track tap status
    let action: () -> Void // Action to perform on tap

    func body(content: Content) -> some View {
        content
            .scaleEffect(isTapped ? 0.95 : 1.0) // Scale effect on tap
            .animation(.easeInOut(duration: 0.1), value: isTapped) // Animation effect
            .onTapGesture {
                isTapped = true // Set tapped state
                action() // Call the action on tap
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    isTapped = false // Reset tapped state after delay
                }
            }
    }
}

// Extension to add tap feedback functionality to any View
extension View {
    func tapFeedback(action: @escaping () -> Void) -> some View {
        self.modifier(TapFeedbackModifier(action: action))
    }
}

// Preview for SwiftUI
#Preview {
    ContentView()
}
