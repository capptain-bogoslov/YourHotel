//
//  RoomCheckInView.swift
//  YourHotel
//
//  Created by Batsioulas, Theologos on 29/1/25.
//

import SwiftUI

struct RoomCheckInView: View {
    @State private var isBeating = false
    
    var body: some View {
        VStack(spacing: 10) {
            
            Text("profile_sign_up_label")
                .applyFont(font: Font.applyStyle(.bodyMedium))
            
            HStack {
                Text("profile_room_registration")
                    .applyFont(font: Font.applyStyle(.displayLarge))
                    .frame( alignment: .leading)
                
                Image(systemName: "key.card.fill")
                    .font(.system(size: 30))
                    .symbolRenderingMode(.palette)
                    .foregroundStyle(.white, Color.tertiaryColor)
                    .padding(.horizontal, 10)
                Spacer()
                
            }
            .padding(.top, 10)
            
            
            Text("profile_scan_description_label")
                .applyFont(font: Font.applyStyle(.bodyLarge))
                .multilineTextAlignment(.center)
                .padding(.top, 10)
            
            ZStack {
                
                Image(systemName: "qrcode.viewfinder")
                    .font(.system(size: 200))
                    .symbolRenderingMode(.palette)
                    .foregroundStyle(Color.blackWhite, Color.primaryColor)
                    .padding(.trailing, 10)
                    .scaleEffect(isBeating ? 1.1 : 1.0)
                    .animation(
                        .spring(duration: 2)
                        .repeatForever(autoreverses: true),
                        value: isBeating
                    )
                    .onAppear {
                        isBeating = true // Start animation automatically
                    }
                
                Image(systemName: "qrcode")
                    .font(.system(size: 120))
                    .symbolRenderingMode(.palette)
                    .foregroundStyle(Color.blackWhite)
                    .padding(.trailing, 10)
                    .background(Color.whiteBlack)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 20)
        .padding(.horizontal, 10)
    
        Spacer()
        
        Button(action: {
            print("Button tapped!")
        }) {
            Text("profile_scan")
                .foregroundColor(.whiteBlack)
                .applyFont(font: Font.applyStyle(
                    .headinleLarge))
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .background(Color.blackWhite)
                .cornerRadius(8)
        }
        .padding(20)
    }
}

#Preview {
    RoomCheckInView()
}
