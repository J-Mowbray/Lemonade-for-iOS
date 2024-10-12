//
//  ContentView.swift
//  Lemonade
//
//  Created by Jamie Mowbray on 12/10/2024.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack {
            Image("Wallpaper")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
                .frame(maxWidth: 2622, maxHeight: 1206)
                .opacity(1.0)
            
            VStack {
                Text("Lemonade")
                    .foregroundColor(.black)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Text("Coming soon from Android!")
                    .foregroundColor(.black)
                    .font(.headline)
                    .fontWeight(.bold)
                    
            }
            
        }
    }
}

#Preview {
    ContentView()
}
