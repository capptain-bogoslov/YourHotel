//
//  ProfileView.swift
//  YourHotel
//
//  Created by Batsioulas, Theologos on 12/1/25.
//

import SwiftUI

struct ProfileView: View {
    @AppStorage("isDarkMode") private var isDarkMode = false
    @State private var selectedTab = 1

    var body: some View {
        
        VStack(spacing: 0) {
            
            Image("hotel1")
                .resizable()
                .frame(height: (UIScreen.main.bounds.height / 3))
                .scaledToFit()
            
            VStack(spacing: 10) {
                Text("profile_sign_up_label")
                    .applyFont(font: Font.applyStyle(.bodyMedium))
                    .padding(.top, 10)
                //                        .background(.red)
                
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
                .clipShape(RoundedRectangle(cornerRadius: 10))
                
                Rectangle()
                    .fill(Color.secondaryColor)
                    .frame(width: UIScreen.main.bounds.width / 2, height:
                            3)
                    .offset(x: selectedTab == 0 ? -UIScreen.main.bounds.width / 4 : UIScreen.main.bounds.width / 4)
                    .animation(.easeInOut(duration: 0.5), value: selectedTab)
                //            Spacer()
                
                if selectedTab == 0 {
                    
                } else {
                    VStack(spacing: 10) {
                        
                        HStack {
                            Text("profile_room_registration")
                                .applyFont(font: Font.applyStyle(.displayLarge))
                            //                            .background(.green)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            Spacer()
                            
                            Image(systemName: "key.card.fill")
                                .font(.system(size: 30))
                                .symbolRenderingMode(.palette)
                                .foregroundStyle(.white, Color.tertiaryColor)
                                .padding(.trailing, 10)
                        }
                        
                        Text("profile_scan_description_label")
                            .applyFont(font: Font.applyStyle(.bodyLarge))
                            .multilineTextAlignment(.center)
                        //                        .background(.red)
                            .padding(.top, 10)
                        
                        Image(systemName: "qrcode.viewfinder")
                            .font(.system(size: 200))
                            .symbolRenderingMode(.palette)
                            .foregroundStyle(Color.blackWhite, Color.primaryColor)
                            .padding(.trailing, 10)
                        
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.top, 20)
                    .padding(.horizontal, 10)
                    //                .background(.yellow)
                    
                }
                
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
            .background {
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.whiteBlack)
            }
            .frame(height: (UIScreen.main.bounds.height * 2 / 3) + 20)
            .offset(x: 0, y: -20)
        }
        .preferredColorScheme(isDarkMode ? .dark : .light)
        .ignoresSafeArea()
    }
}

#Preview {
    ProfileView()
}
