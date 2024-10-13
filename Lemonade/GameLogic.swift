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

    /// Restarts the game.
    func restartGame() {
        currentStep = .pickLemon // Restart the game
        squeezeCount = 0 // Reset squeeze count
    }
}
