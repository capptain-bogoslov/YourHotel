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
    @State private var isBeating = false
    
    var body: some View {
        
        VStack(spacing: 0) {
            
            Image("hotel1")
                .resizable()
                .frame(height: (UIScreen.main.bounds.height / 3))
                .scaledToFit()
            
            VStack(spacing: 10) {
                
                //                HStack {
                //                    Button {
                //                        self.selectedTab = 0
                //
                //                    } label: {
                //                        Text("Sign in")
                //                            .applyFont(font: Font.applyStyle(selectedTab == 0 ? .headinleLarge : .titleMedium))
                //                            .foregroundStyle(selectedTab == 0 ? Color.primaryColor : .gray)
                //                    }
                //
                //                    Spacer()
                //
                //                    Button {
                //                        self.selectedTab = 1
                //                    } label: {
                //                        Text("Sign up")
                //                            .applyFont(font: Font.applyStyle(selectedTab == 1 ? .headinleLarge : .titleMedium))
                //                            .foregroundStyle(selectedTab == 1 ? Color.primaryColor : .gray)
                //                    }
                //
                //
                //                }
                //                .padding(.horizontal, 40)
                //                .clipShape(RoundedRectangle(cornerRadius: 10))
                //
                //                Rectangle()
                //                    .fill(Color.secondaryColor)
                //                    .frame(width: UIScreen.main.bounds.width / 2, height:
                //                            3)
                //                    .offset(x: selectedTab == 0 ? -UIScreen.main.bounds.width / 4 : UIScreen.main.bounds.width / 4)
                //                    .animation(.easeInOut(duration: 0.5), value: selectedTab)
                //            Spacer()
                
                if selectedTab == 0 {
                    
                    VStack(spacing: 10) {
                        HStack {
                            Text("profile_sign_in")
                                .applyFont(font: Font.applyStyle(.displayLarge))
                            //                            .background(.green)
                                .frame( alignment: .leading)
                            
                            //                            Spacer()
                            
                            Image(systemName: "lock.open.fill")
                                .font(.system(size: 25))
                                .symbolRenderingMode(.palette)
                                .foregroundStyle(Color.tertiaryColor)
                                .padding(.horizontal, 10)
                            
                            Spacer()
                            
                        }
                        
                    }
                    .padding(.horizontal, 10)
                    .padding(.top, 20)
                    
                    
                    
                } else {
                    
                    //                                        RoomCheckInView()
                    
                    CompleteRegistrationView()
                    
                    
                }
                
                
                
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


enum AuthenticationFields {
    case email, password, repeatPassword
}

struct CompleteRegistrationView: View {
    
    @State var text: String = ""
    @State var showEmailPassword: Bool = true
    @State var showSocialLogin: Bool = true
    
    
    var body: some View {
        VStack(spacing: 10) {
            HStack {
                Text(String(format: NSLocalizedString("profile_welcome_room", comment: ""), "304"))
                    .applyFont(font: Font.applyStyle(.headingMedium))
                    .padding(.top, 10)
            }
            
            VStack(spacing: 10) {
                HStack {
                    Text("profile_complete_registration")
                        .applyFont(font: Font.applyStyle(.displayMedium))
                        .frame( alignment: .leading)
                    
                    //                            Spacer()
                    
                    Image(systemName: "rectangle.portrait.and.arrow.right.fill")
                        .font(.system(size: 25))
                        .symbolRenderingMode(.palette)
                        .foregroundStyle(Color.blackWhite, Color.tertiaryColor)
                        .padding(.horizontal, 10)
                    
                    Spacer()
                    
                }
                
                HStack {
                    
                    Text("With Email")
                        .applyFont(font: Font.applyStyle(.titleMedium))
                        .foregroundStyle(Color.tertiaryColor)
                        .italic()
                    
                    
                    Rectangle()
                        .frame(height: 1)
                        .foregroundColor(Color.tertiaryColor)
                        .padding(.leading, 10)
                    
                    Image(systemName: "chevron.up")
                        .foregroundStyle(Color.tertiaryColor)
                        .rotationEffect(.degrees(showEmailPassword ? 180 : 0))
                        .onTapGesture {
                            withAnimation(.bouncy(duration: 0.3)) {
                                showEmailPassword.toggle()
                            }
                        }
                    
                }
                .padding(.horizontal, 10)
                //                .padding(.top, 20)
                .opacity(0.7)
                
                if showEmailPassword {
                    EmailPasswordView()
                        .transition(.opacity)
                }
                HStack {
                    
                    Rectangle()
                        .frame(height: 1)
                        .foregroundColor(Color.tertiaryColor)
                        .padding(.leading, 10)
                    
                    Text("OR")
                        .applyFont(font: Font.applyStyle(.titleMedium))
                        .foregroundStyle(Color.secondaryColor)
                    
                    
                    Rectangle()
                        .frame(height: 1)
                        .foregroundColor(Color.tertiaryColor)
                        .padding(.leading, 10)
                    
                }
                .padding(.horizontal, 10)
                //                .padding(.top, 10)
                
                
                HStack {
                    
                    Text("Social Login")
                        .applyFont(font: Font.applyStyle(.titleMedium))
                        .foregroundStyle(Color.tertiaryColor)
                        .italic()
                    
                    
                    Rectangle()
                        .frame(height: 1)
                        .foregroundColor(Color.tertiaryColor)
                        .padding(.leading, 10)
                    
                    Image(systemName: "chevron.down")
                        .foregroundStyle(Color.tertiaryColor)
                        .foregroundStyle(Color.tertiaryColor)
                        .rotationEffect(.degrees(showSocialLogin ? 180 : 0))
                        .onTapGesture {
                            withAnimation(.bouncy(duration: 0.3)) {
                                showSocialLogin.toggle()
                            }
                        }
                    
                }
                .padding(.horizontal, 10)
                .padding(.top, 10)
                .opacity(0.7)
                
                
                if showSocialLogin {
                    SocialLoginView()
                    
                }
                
                Rectangle()
                    .frame(height: 1)
                    .foregroundColor(Color.tertiaryColor)
                    .padding(.leading, 10)
                    .padding(.top, showSocialLogin ? 10 : 20)
                
            }
            .padding(.horizontal, 10)
            .padding(.top, 20)
            
            Spacer()
        }
    }
}

struct EmailPasswordView: View {
    
    @FocusState private var focusedField: AuthenticationFields?
    @State var email: String = ""
    @State var password: String = ""
    @State var repeatPassword: String = ""
    
    
    var body: some View {
        VStack {

            
            CustomTextField(value: $email, isPassword: false, placeholder: "Email")
                .padding(EdgeInsets(top: 10, leading: 15, bottom: 10, trailing: 15))
                .focused($focusedField, equals: .email)
                .submitLabel(.next)
                .scaleEffect(focusedField == .email ? 1.05 : 1.0)
                .animation(.spring(response: 0.3, dampingFraction: 0.5), value: focusedField)
                .onSubmit {
                    focusedField = .password
                }
            
            CustomTextField(value: $password, isPassword: true, placeholder: "Password")
                .padding(EdgeInsets(top: 10, leading: 15, bottom: 10, trailing: 15))
                .focused($focusedField, equals: .password)
                .submitLabel(.next)
                .scaleEffect(focusedField == .password ? 1.05 : 1.0)
                .animation(.spring(response: 0.3, dampingFraction: 0.5), value: focusedField)
                .onSubmit {
                    focusedField = .repeatPassword
                }
            
            CustomTextField(value: $repeatPassword, isPassword: true, placeholder: "Confirm Password")
                .padding(EdgeInsets(top: 10, leading: 15, bottom: 10, trailing: 15))
                .focused($focusedField, equals: .repeatPassword)
                .submitLabel(.go)
                .scaleEffect(focusedField == .repeatPassword ? 1.05 : 1.0)
                .animation(.spring(response: 0.3, dampingFraction: 0.5), value: focusedField)
                .onSubmit {
                    focusedField = nil
                }
            
            Button(action: {
                print("Button tapped!")
            }) {
                Text("Create Account")
                    .foregroundColor(.whiteBlack)
                    .applyFont(font: Font.applyStyle(
                        .headinleLarge))
                    .frame(maxWidth: .infinity)
                    .frame(height: 40)
                    .background(Color.blackWhite)
                    .cornerRadius(8)
            }
            .padding(20)
        }
    }
}


struct SocialLoginView: View {
    var body: some View {
        VStack {
            
            
            Button(action: {
                print("Button tapped!")
            }) {
                Text("Google")
                    .foregroundColor(.whiteBlack)
                    .applyFont(font: Font.applyStyle(
                        .headinleLarge))
                    .frame(maxWidth: .infinity)
                    .frame(height: 40)
                    .background(Color.blackWhite)
                    .cornerRadius(8)
            }
            .padding(10)
            
            Button(action: {
                print("Button tapped!")
            }) {
                Text("Apple")
                    .foregroundColor(.whiteBlack)
                    .applyFont(font: Font.applyStyle(
                        .headinleLarge))
                    .frame(maxWidth: .infinity)
                    .frame(height: 40)
                    .background(Color.blackWhite)
                    .cornerRadius(8)
            }
            .padding(.horizontal, 10)
        }
    }
}

