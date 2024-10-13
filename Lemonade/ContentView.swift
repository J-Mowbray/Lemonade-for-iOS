//
//  ContentView.swift
//  Lemonade
//
//  Created by Jamie Mowbray on 12/10/2024.
//

import SwiftUI
import AVFoundation

/// Main view for the lemonade game.
struct ContentView: View {
    @StateObject private var gameLogic = GameLogic() // Retain the same instance of GameLogic
    private var audioManager = AudioManager() // Instance for audio management
    
    var body: some View {
        GameUI(gameLogic: gameLogic, audioManager: audioManager) // Use the new GameUI
    }
}
#Preview {
    ContentView()
}

