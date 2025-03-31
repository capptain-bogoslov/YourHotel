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
    //    @State private var selectedTab = 1
    @State private var isBeating = false
    @State private var showScanner: Bool = false
    @State private var scannedRoom: String?
    @State private var selectedAuthenticationMethod: Int = 1

    
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
                
                if let code = scannedRoom {
//                    Text(code)
//                        .font(.system(.largeTitle))
//                    
//                    Button(action: {
//                        auth.sendVerificationCode(phoneNumber: "+306952221307")
//                    }) {
//                        Text("Send Code")
//                            .foregroundColor(.whiteBlack)
//                            .applyFont(font: Font.applyStyle(
//                                .headinleLarge))
//                            .frame(maxWidth: 150)
//                            .frame(height: 50)
//                            .background(Color.blackWhite)
//                            .cornerRadius(8)
//                    }
//                    .padding(20)
//                    .padding(.top, 40)

                                        
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
                    
                    AuthenticationView(roomNumber: code)

                } else {
                    RoomCheckInView(showScanner: $showScanner)
                }
                
                
            }
            .background {
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.whiteBlack)
            }
            //            .background(.red)
            .frame(height: (UIScreen.main.bounds.height * 2 / 3) + 20)
            .offset(x: 0, y: -20)
        }
        .frame(maxWidth: .infinity)
        .sheet(isPresented: $showScanner) {
            QRCodeScannerView(scannedCode: $scannedRoom)
        }
        .preferredColorScheme(isDarkMode ? .dark : .light)
        .ignoresSafeArea()
    }
}

struct AuthenticationView: View {
    @State var roomNumber: String
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 0) {
            
            CountryPickerView()
                .padding(.top, 20)
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        
    }
}

struct OTPInputView: View {
    @State private var otp: [String] = Array(repeating: "", count: 6)
    @FocusState private var focusedField: Int?
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Enter OTP Code")
                .font(.title)
                .bold()
            
            HStack(spacing: 10) {
                ForEach(0..<6, id: \.self) { index in
                    TextField("", text: $otp[index])
                        .frame(width: 50, height: 50)
                        .multilineTextAlignment(.center)
                        .keyboardType(.numberPad)
                        .font(.title)
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(10)
                        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.blue, lineWidth: otp[index].isEmpty ? 1 : 2))
                        .focused($focusedField, equals: index)
                        .onChange(of: otp[index]) { newValue in
                            handleInputChange(newValue, at: index)
                        }
                }
            }
            
            Button(action: verifyOTP) {
                Text("Verify")
                    .bold()
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(12)
            }
            .padding(.top, 20)
        }
        .padding()
        .onAppear {
            focusedField = 0
        }
    }
    
    private func handleInputChange(_ value: String, at index: Int) {
        // Allow only a single character and move focus to the next field
        if value.count > 1 {
            otp[index] = String(value.prefix(1))
        }
        if !value.isEmpty && index < 5 {
            focusedField = index + 1
        }
    }
    
    private func verifyOTP() {
        let enteredOTP = otp.joined()
        print("Entered OTP: \(enteredOTP)")
    }
}

struct OTPInputView_Previews: PreviewProvider {
    static var previews: some View {
        OTPInputView()
    }
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}

