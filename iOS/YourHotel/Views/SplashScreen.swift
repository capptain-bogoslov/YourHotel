//
//  ContentView.swift
//  YourHotel
//
//  Created by Batsioulas, Theologos on 15/12/24.
//

import SwiftUI
import AVKit
import DotLottie

struct SplashScreen: View {
    @AppStorage("isDarkMode") private var isDarkMode = false
    @State private var isActive = false
    
    var body: some View {
        
        if self.isActive {
            HomeView()
                .transition(.opacity)
        } else {
            ZStack {
                Color.white.ignoresSafeArea()
                VideoSplashView(isFinished: $isActive)
            }
            .ignoresSafeArea()
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 7.5) {
                    self.isActive.toggle()
                }
            }
            .preferredColorScheme(isDarkMode ? .dark : .light)
        }
    }
}

struct VideoSplashView: View {
    @Binding var isFinished: Bool
    private let player = AVPlayer(url: Bundle.main.url(forResource: "sonia_animation", withExtension: "mp4")!)
    
    // 1. Initialize the animation using your local .lottie file
        private let animation = DotLottieAnimation(
            fileName: "sonia_animation", // Do not include the ".lottie" extension here
            config: AnimationConfig(autoplay: true, loop: false)
        )
    
    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()
//            VideoPlayer(player: player)
//                .frame(width: 150, height:150)
//                .onAppear {
//                    player.play()
//                    
//                    // Listen for the video finishing
//                    NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: player.currentItem, queue: .main) { _ in
//                        withAnimation {
//                            isFinished = true
//                        }
//                    }
//                }
//                .onDisappear {
//                    player.pause()
//                }
            // 2. Display the player view and customize it using modifiers
//                        DotLottiePlayerView(animation: animation)
//                            .looping()
//                            .animationSpeed(1.5) // Speeds up the animation slightly
//                            .frame(width: 400, height: 400)
            
            DotLottieView(dotLottie: animation)
                .frame(width: 400, height: 400)

        }
    }
}

#Preview {
    SplashScreen()
}
