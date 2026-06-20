//
//  CalendarView.swift
//  YourHotel
//
//  Created by Batsioulas, Theologos on 20/6/26.
//
import SwiftUI

struct CalendarView: View {
    @EnvironmentObject var auth: UserAuthModel
    @Binding var tabSelected: Int

    
    var body: some View {
        
        VStack {
            
            if !auth.userLoggedIn {
                Spacer()
                SignInVerticalView(tabSelected: $tabSelected)
            }
            
            Spacer()
        }
    }
}


struct SignInVerticalView: View {
    @Binding var tabSelected: Int
    
    var body: some View {
        VStack {
            Text("Sign in to get access to exclusive services, offers and hotel information")
                .font(.subheadline)
                .fontWeight(.semibold)
            
            Button {
                tabSelected = 4
            } label: {
                Label("Sign In", systemImage: "door.left.hand.open")
                    .font(.body)
                    .fontWeight(.black)
                    .padding()
            }
            .frame(height: 60)
            .foregroundColor(.white)
            .background(LinearGradient(colors:  [Color.primaryColor, Color.surfaceVariant], startPoint: .top, endPoint: .bottom))
            .clipShape(RoundedRectangle(cornerRadius: 8))
        }
    }
}
