//
//  GameView.swift
//  Lemonade
//
//  Created by Jamie Mowbray on 13/10/2024.
//

import SwiftUI

/// A view representing the game's UI.
struct GameUI: View {
    @ObservedObject var gameLogic: GameLogic // Reference to the game logic
    private var audioManager: AudioManager // Audio manager instance

    init(gameLogic: GameLogic, audioManager: AudioManager) {
        self.gameLogic = gameLogic
        self.audioManager = audioManager
    }

    var body: some View {
        ZStack {
            Image("Wallpaper")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
                .opacity(1.0)

            VStack {
                Text("Lemons squashed: \(gameLogic.squashedLemons)")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.black)
                    .padding(10)
                    .background(Color.white.opacity(0.7))
                    .cornerRadius(8)
                    .padding(.top, 5)

                Spacer()

                // Integrate LemonadeView directly into GameUI
                switch gameLogic.currentStep {
                case .pickLemon:
                    lemonadeView(
                        textLabel: "Tap the lemon tree \n   to pick a lemon! 🍋",
                        imageName: "lemon_tree",
                        contentDescription: "Lemon tree content description",
                        action: {
                            gameLogic.pickLemon()
                        }
                    )
                case .squeezeLemon:
                    lemonadeView(
                        textLabel: "Tap the lemon to squeeze it!\nWe're making tasty lemonade!",
                        imageName: "lemon_squeeze",
                        contentDescription: "Lemon content description",
                        action: {
                            gameLogic.squeezeLemon()
                        }
                    )
                case .drinkLemonade:
                    lemonadeView(
                        textLabel: """
                            Mmm, tasty lemonade!
                                Tap the glass to drink it! 😎
                            """,
                        imageName: "lemon_drink",
                        contentDescription: "Glass full content description",
                        action: { gameLogic.restartGame() }
                    )
                case .restart:
                    lemonadeView(
                        textLabel: "Oh no! You drank it all! 😢\nTap the empty glass to start again!",
                        imageName: "lemon_restart",
                        contentDescription: "Empty glass content description",
                        action: {
                            gameLogic.restartGame()
                        }
                    )
                }

                Spacer()
            }
        }
        .onAppear {
            audioManager.playBackgroundMusic(fileName: "background_music")
            NotificationCenter.default.addObserver(forName: UIApplication.willResignActiveNotification, object: nil, queue: .main) { _ in
                audioManager.stopBackgroundMusic()
            }
            NotificationCenter.default.addObserver(forName: UIApplication.didBecomeActiveNotification, object: nil, queue: .main) { _ in
                audioManager.playBackgroundMusic(fileName: "background_music")
            }
        }
        .onDisappear {
            audioManager.stopBackgroundMusic()
            NotificationCenter.default.removeObserver(self, name: UIApplication.willResignActiveNotification, object: nil)
            NotificationCenter.default.removeObserver(self, name: UIApplication.didBecomeActiveNotification, object: nil)
        }
    }
    
    /// Lemonade view integrated into GameUI.
    private func lemonadeView(textLabel: String, imageName: String, contentDescription: String, action: @escaping () -> Void) -> some View {
        VStack {
            Text(textLabel)
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.black)
                .padding(10)
                .background(Color.white.opacity(0.7))
                .cornerRadius(8)
                .multilineTextAlignment(.center)

            Image(imageName)
                .resizable()
                .scaledToFit()
                .frame(height: 150)
                .accessibilityLabel(contentDescription)
                .padding(16)
                .tapFeedback(action: action)
        }
        .padding(.bottom, 40)
        .frame(maxWidth: .infinity, alignment: .center)
    }
}

/// View modifier to provide visual feedback on taps.
struct TapFeedbackModifier: ViewModifier {
    @State private var isTapped = false
    let action: () -> Void
    
    func body(content: Content) -> some View {
        content
            .scaleEffect(isTapped ? 0.95 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: isTapped)
            .onTapGesture {
                isTapped = true
                action()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    isTapped = false
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
