//
//  ProfileView.swift
//  YourHotel
//
//  Created by Batsioulas, Theologos on 12/1/25.
//

import SwiftUI

struct ProfileView: View {
    @State private var selectedTab = 0

    var body: some View {
        VStack {
     
            HStack {
                Button {
                    self.selectedTab = 0
                } label: {
                    Text("Sign in")
                        .applyFont(font: Font.applyStyle(selectedTab == 0 ? .headinleLarge : .titleMedium))
                        .foregroundStyle(selectedTab == 0 ? Color.primaryColor : .gray)
                }
                
                Spacer()
                
                Button {
                    self.selectedTab = 1
                } label: {
                    Text("Sign up")
                        .applyFont(font: Font.applyStyle(selectedTab == 1 ? .headinleLarge : .titleMedium))
                        .foregroundStyle(selectedTab == 1 ? Color.primaryColor : .gray)
                }

            }
            .padding(.horizontal, 40)
            
            Spacer()
            
        }
        .padding()
    }
}

#Preview {
    ProfileView()
}
