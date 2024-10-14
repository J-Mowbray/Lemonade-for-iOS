//
//  GameLogic.swift
//  Lemonade
//
//  Created by Jamie Mowbray on 13/10/2024.
//

import Foundation

/// Enum defining the various game states.
enum GameStep {
    case pickLemon
    case squeezeLemon
    case drinkLemonade
    case restart
}

/// Class managing the game logic.
class GameLogic: ObservableObject {
    @Published var currentStep: GameStep = .pickLemon // Current game step
    @Published var squeezeCount = 0 // Number of squeezes left
    @Published var squashedLemons = 0 // Count of squashed lemons

    /// Picks a lemon and sets the squeeze count.
    func pickLemon() {
        squeezeCount = Int.random(in: 2...9) // Randomize squeeze count
        currentStep = .squeezeLemon // Transition to squeeze step
    }

    /// Squeezes a lemon and updates the game state.
    func squeezeLemon() {
        if squeezeCount > 0 {
            squeezeCount -= 1 // Decrease squeeze count
            if squeezeCount == 0 {
                squashedLemons += 1 // Increment squashed lemons
                currentStep = .drinkLemonade // Move to drink step
            }
        }
    }

    /// Moves to the restart step after drinking lemonade.
    func drinkLemonade() {
        currentStep = .restart // Move to restart step
    }

    /// Restarts the game.
    func restartGame() {
        currentStep = .pickLemon // Restart the game
        squeezeCount = 0 // Reset squeeze count
 
    }

    // Provides the view configuration based on the current game step
    func currentView() -> (textLabel: String, imageName: String, contentDescription: String, action: () -> Void) {
        switch currentStep {
        case .pickLemon:
            return (
                "Tap the lemon tree \n   to pick a lemon! 🍋",
                "lemon_tree",
                "Lemon tree content description.",
                { self.pickLemon() }
            )
        case .squeezeLemon:
            return (
                "Tap the lemon to squeeze it!\nWe're making tasty lemonade!",
                "lemon_squeeze",
                "Lemon being squeezed content description.",
                { self.squeezeLemon() }
            )
        case .drinkLemonade:
            return (
                """
                Mmm, tasty lemonade!
                    Tap the glass to drink it! 😎
                """,
                "lemon_drink",
                "Glass of lemonade content description.",
                { self.drinkLemonade() }
            )
        case .restart:
            return (
                "Oh no! You drank it all! 😢\nTap the empty glass to start again!",
                "lemon_restart",
                "Empty glass content description.",
                { self.restartGame() }
            )
        }
    }
}
