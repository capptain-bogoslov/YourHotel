//
//  ContentView.swift
//  YourHotel
//
//  Created by Batsioulas, Theologos on 15/12/24.
//

import SwiftUI

struct SplashScreen: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Amen!")
        }
        .padding()
    }
}

#Preview {
    SplashScreen()
}
