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
    
        private let animation = DotLottieAnimation(
            fileName: "sonia_animation", 
            config: AnimationConfig(autoplay: true, loop: false)
        )
    
    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()
            
            DotLottieView(dotLottie: animation)
                .frame(width: 400, height: 400)

        }
    }
}

#Preview {
    SplashScreen()
}
