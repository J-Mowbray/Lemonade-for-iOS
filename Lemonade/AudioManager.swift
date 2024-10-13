//
//  AudioPlayer.swift
//  Lemonade
//  Background Music for the game
//  Created by Jamie Mowbray on 13/10/2024.
//

import AVFoundation
import UIKit // Import UIKit to use NSDataAsset

/// Manages audio playback for the application.
class AudioManager {
    var audioPlayer: AVAudioPlayer?
    private var isPlaying = false // Tracks whether music is currently playing

    /// Plays background music from the asset catalog.
    /// - Parameter fileName: The name of the audio file in the asset catalog.
    func playBackgroundMusic(fileName: String) {
        guard !isPlaying else { return } // Prevents multiple instances of music from playing
        
        // Retrieve audio data from the asset catalog
        guard let audioData = NSDataAsset(name: fileName)?.data else {
            print("Failed to find audio file.")
            return
        }

        do {
            audioPlayer = try AVAudioPlayer(data: audioData)
            audioPlayer?.numberOfLoops = -1 // Set to loop indefinitely
            audioPlayer?.play()
            isPlaying = true // Update the playing state
            print("Playing background music.")
        } catch {
            print("Error initializing audio player: \(error)")
        }
    }

    /// Stops the background music and releases the audio player.
    func stopBackgroundMusic() {
        audioPlayer?.stop()
        audioPlayer = nil // Release the audio player
        isPlaying = false // Update the playing state
        print("Stopped background music.")
    }
}
