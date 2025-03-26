//
//  CustomButton.swift
//  YourHotel
//
//  Created by Batsioulas, Theologos on 15/2/25.
//

import SwiftUI

struct CustomButton: View {
    
    var text: String
    var colors: [Color]
    var height: CGFloat
    var font: Font
    
    var body: some View {
        
        Button(action: {
            print("Button tapped!")
            
        }) {
            
            ZStack {
                LinearGradient(colors: colors, startPoint: .top, endPoint: .bottom)
                    .frame(maxWidth: .infinity)
                    .frame(height: height)
                    .cornerRadius(8)
                    .shadow(color: .black.opacity(0.3), radius: 3, x: 0, y: 2)
                
                Text(LocalizedStringKey(text))
                    .foregroundColor(.whiteBlack)
                    .applyFont(font: font)
            }
            .frame(maxWidth: .infinity)
            .frame(height: height)
        }
    }
}

#Preview {
    CustomButton(text: "Create Account", colors: [Color.tertiaryColor, Color.tertiary, Color.surface], height: 40, font: Font.applyStyle(.headingLarge))
}
