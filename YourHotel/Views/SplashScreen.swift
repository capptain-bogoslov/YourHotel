//
//  ContentView.swift
//  YourHotel
//
//  Created by Batsioulas, Theologos on 15/12/24.
//

import SwiftUI

struct SplashScreen: View {
    @AppStorage("isDarkMode") private var isDarkMode = false
    @State private var isActive = false
    
    var body: some View {
        
        if self.isActive {
            HomeView()
        } else {
        ZStack {
            Color.red.ignoresSafeArea()
        
            Text("Hello!")
                .font(.system(size: 40))
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 8.5) {
                    self.isActive.toggle()
                }
            }
            .preferredColorScheme(isDarkMode ? .dark : .light)
        }
    }
}

#Preview {
    SplashScreen()
}
