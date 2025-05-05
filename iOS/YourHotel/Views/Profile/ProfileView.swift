//
//  ProfileView.swift
//  YourHotel
//
//  Created by Batsioulas, Theologos on 12/1/25.
//

import SwiftUI

struct ProfileView: View {
    @AppStorage("isDarkMode") private var isDarkMode = false
    @EnvironmentObject private var auth: UserAuthModel
    @State private var isBeating = false
    @State private var showScanner: Bool = false
    @State private var scannedRoom: String?
    @State private var selectedAuthenticationMethod: Int = 1
    @State private var userLogged: Bool = false
    
    func getRoomNumberAttributed(roomNumber: String) -> AttributedString {
        var attributedString = AttributedString(String(format: NSLocalizedString("profile_welcome_room", comment: ""), roomNumber))
        
        // Regular expression to find numbers
        let pattern = "\\b\\d+\\b"
        if let range = attributedString.range(of: pattern, options: .regularExpression) {
            attributedString[range].foregroundColor = Color.primaryColor
            attributedString[range].font = .boldSystemFont(ofSize: 22)
        }
        
        return attributedString
    }
    
    var body: some View {
        
        VStack(spacing: 0) {
            
            Image("hotel1")
                .resizable()
                .frame(height: (UIScreen.main.bounds.height / 3))
                .scaledToFit()
            
            VStack(spacing: 10) {
                
                if !auth.userLoggedIn {
                    
                    if let code = scannedRoom {
                        
                        Text(getRoomNumberAttributed(roomNumber: code))
                            .applyFont(font: Font.applyStyle(.headingLarge))
                            .padding(.top, 10)
                        
                        Text("profile_choose_authentication")
                            .applyFont(font: Font.applyStyle(.bodyMedium))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 16)
                        
                        SegmentedPicker(
                            selectedIndex: $selectedAuthenticationMethod,
                            options: ["profile_phone", "profile_email"],
                            selectedColor: UIColor(hex: "1CA6DF") ?? .systemTeal,
                            backgroundColor: UIColor(hex: "F0F0F0") ?? .lightGray,
                            textColor: .black
                        )
                        .padding(.horizontal, 10)
                        
                        if selectedAuthenticationMethod == 0 {
                            AuthenticationView(roomNumber: code)
                        } else {
                            Spacer()
                        }
                        
                    } else {
                        RoomCheckInView(showScanner: $showScanner)
                    }
                    
                } else {
                    
                    VStack {
                        Text("Logged in")
                            .font(.headline)
                        
                        Button {
                            auth.logOut()
                        } label: {
                            Text("Log out")
                                .frame(height: 50)
                                .background(Color.blackWhite)
                                .cornerRadius(8)
                                .padding()
                        }
                        
                    }
                    
                }
                
            }
            .background {
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.whiteBlack)
            }
            .frame(height: (UIScreen.main.bounds.height * 2 / 3) + 20)
            .offset(x: 0, y: -20)
        }
        .frame(maxWidth: .infinity)
        .onChange(of: auth.userLoggedIn) { value in
            self.userLogged = value
        }
        .sheet(isPresented: $showScanner) {
            QRCodeScannerView(scannedCode: $scannedRoom)
        }
        .preferredColorScheme(isDarkMode ? .dark : .light)
        .ignoresSafeArea()
    }
}

struct AuthenticationView: View {
    @State var roomNumber: String
    @State var codeSent: Bool = false
    @State var phone: String = ""
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 0) {
            
            if codeSent {
                OTPInputView(roomNumber: roomNumber, phoneNumber: phone)
                
            } else {
                CountryPickerView(codeSent: $codeSent, phoneComplete: $phone)
                    .padding(.top, 20)
            }
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        
    }
}

struct OTPInputView: View {
    @EnvironmentObject private var auth: UserAuthModel
    @FocusState private var isFocused: Bool
    @State private var otpCode: String = ""
    var kerningSpace : CGFloat {
        (UIScreen.main.bounds.width - 40 - 180) / 4.5
    }
    // screenWidth - padding - (charactes * fontSize) / characters - 1.5
    @State private var buttonStatus: AnimatedButtonState = .normal
    @State private var disableButton: Bool = true
    var roomNumber: String
    var phoneNumber: String
    
    
    var body: some View {
        VStack(spacing: 20) {
            
            ZStack(alignment: .leading) {
                // Show placeholder only when text is empty
                if otpCode.isEmpty {
                    Text("Enter OTP Code")
                        .foregroundColor(.gray)
                        .font(.body)
                        .padding(.horizontal, 20)
                }
                
                
                TextField("", text: $otpCode)
                    .keyboardType(.phonePad)
                    .padding(.vertical, 20)
                    .padding(.horizontal, 20)
                    .frame(maxWidth: .infinity)
                    .textContentType(.oneTimeCode)
                    .focused($isFocused)
                    .onChange(of: otpCode) { newValue in
                        // Keep only digits
                        let filtered = newValue.filter { $0.isNumber }
                        // Limit to 6 characters
                        if filtered.count > 6 {
                            otpCode = String(filtered.prefix(6))
                        } else {
                            otpCode = filtered
                        }
                    }
                    .font(.system(size: 30, weight: .bold))
                    .kerning(kerningSpace)
                    .background(otpCode.isEmpty ? Color.gray.opacity(0.2) :Color.gray.opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .overlay(
                        TextFieldOutline(
                            bottomCornerRadius: otpCode.isEmpty ? 8 : 15,
                            sideInset: otpCode.isEmpty ? 8 : 65
                        )
                        .stroke(isFocused ? Color.secondaryColor : Color.clear, lineWidth: 2)
                        .padding(1) // Adjust to move the stroke *inside*
                            .animation(.easeOut(duration: 1.0), value: otpCode)
                    )
                
            }
            
            CustomAnimatedButton(buttonStatus: $buttonStatus, buttonType: .verifyCode, buttonAction: verifyOTP)
                .padding(20)
                .opacity(disableButton ? 0.4 : 1.0)
                .disabled(disableButton)
            
        }
        .padding()
        .onChange(of: otpCode) { newValue in
            disableButton = newValue.count < 5
        }
        .onTapGesture {
            isFocused = false
            hideKeyboard()
        }
    }
    
    
    private func verifyOTP() {
        Task {
            await auth.verifyOTP(otpCode: self.otpCode, room: roomNumber, phone: phoneNumber)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.buttonStatus = .receiveResult
        }
        print("Entered OTP: \(otpCode)")
    }
}

//struct OTPInputView_Previews: PreviewProvider {
//    static var previews: some View {
//        OTPInputView()
//    }
//}

