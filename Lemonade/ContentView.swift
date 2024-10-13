//
//  ContentView.swift
//  Lemonade
//
//  Created by Jamie Mowbray on 12/10/2024.
//

import SwiftUI
import AVFoundation

/// Enum defining the various game states.
enum GameStep {
    case pickLemon
    case squeezeLemon
    case drinkLemonade
    case restart
}

/// Main view for the lemonade game.
struct ContentView: View {
    @State private var currentStep = GameStep.pickLemon // Current game step
    @State private var squeezeCount = 0 // Number of squeezes left
    @State private var squashedLemons = 0 // Count of squashed lemons
    private var audioManager = AudioManager() // Instance for audio management
    
    var body: some View {
        ZStack {
            // Background image for the game
            Image("Wallpaper")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
                .opacity(1.0)
            
            VStack {
                // Display the number of squashed lemons
                Text("Lemons squashed: \(squashedLemons)")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.black) // Text color
                    .padding(10)
                    .background(Color.white.opacity(0.7)) // Background for visibility
                    .cornerRadius(8)
                    .padding(.top, 5) // Padding to position it higher
                
                Spacer()
                
                // Display the appropriate view based on the current game state
                switch currentStep {
                case .pickLemon:
                    LemonadeView(textLabel: "Tap the lemon tree \n   to pick a lemon! 🍋",
                                 imageName: "lemon_tree",
                                 contentDescription: "Lemon tree content description",
                                 action: {
                        squeezeCount = Int.random(in: 2...9) // Randomize squeeze count
                        currentStep = .squeezeLemon // Transition to squeeze step
                    })
                case .squeezeLemon:
                    LemonadeView(textLabel: "Tap the lemon to squeeze it!\nWe're making tasty lemonade!",
                                 imageName: "lemon_squeeze",
                                 contentDescription: "Lemon content description",
                                 action: {
                        if squeezeCount > 0 {
                            squeezeCount -= 1 // Decrease squeeze count
                            if squeezeCount == 0 {
                                squashedLemons += 1 // Increment squashed lemons
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
        .onAppear {
            audioManager.playBackgroundMusic(fileName: "background_music") // Play background music
            // Observe app state changes to manage audio playback
            NotificationCenter.default.addObserver(forName: UIApplication.willResignActiveNotification, object: nil, queue: .main) { _ in
                audioManager.stopBackgroundMusic() // Stop music when app goes inactive
            }
            NotificationCenter.default.addObserver(forName: UIApplication.didBecomeActiveNotification, object: nil, queue: .main) { _ in
                audioManager.playBackgroundMusic(fileName: "background_music") // Resume music when app becomes active
            }
        }
        .onDisappear {
            audioManager.stopBackgroundMusic() // Stop music when the view disappears
            // Remove observers to prevent memory leaks
            NotificationCenter.default.removeObserver(self, name: UIApplication.willResignActiveNotification, object: nil)
            NotificationCenter.default.removeObserver(self, name: UIApplication.didBecomeActiveNotification, object: nil)
        }
    }
}

/// View representing a step in the lemonade-making process.
struct LemonadeView: View {
    let textLabel: String // Text to display
    let imageName: String // Image name to display
    let contentDescription: String // Accessibility description
    let action: () -> Void // Action to perform on tap
    
    var body: some View {
        VStack {
            // Display the text label
            Text(textLabel)
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.black) // Text color
                .padding(10)
                .background(Color.white.opacity(0.7)) // Semi-transparent background
                .cornerRadius(8)
                .multilineTextAlignment(.center) // Center text
            
            // Display the corresponding image
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

/// View modifier to provide visual feedback on taps.
struct TapFeedbackModifier: ViewModifier {
    @State private var isTapped = false // State to track tap status
    let action: () -> Void // Action to perform on tap
    
    func body(content: Content) -> some View {
        content
            .scaleEffect(isTapped ? 0.95 : 1.0) // Scale effect on tap
            .animation(.easeInOut(duration: 0.1), value: isTapped) // Animation for the effect
            .onTapGesture {
                isTapped = true // Set tapped state
                action() // Execute the action on tap
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    isTapped = false // Reset tapped state after delay
                }
            }
    }
}

// Extension to add tap feedback functionality to any View
extension View {
    func tapFeedback(action: @escaping () -> Void) -> some View {
        self.modifier(TapFeedbackModifier(action: action)) // Apply the tap feedback modifier
    }
}

// Preview for SwiftUI
#Preview {
    ContentView() // Preview the main content view
}

