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


enum AnimatedButtonState {
    case normal
    case pendingResult
    case receiveResult
    
}

enum AnimatableButtonType {
    case sendCode
    case verifyCode
    
    var textNormalState: String {
        switch self {
        case .sendCode:
            return "Send code"
        case .verifyCode:
            return "Verify code"
        }
    }
    
    var textPendingState: String {
        switch self {
        case .sendCode:
            return "Sending code"
        case .verifyCode:
            return "Verifying code"
        }
    }
    
    var textFinishedState: String {
        switch self {
        case .sendCode:
            return "Code Sent"
        case .verifyCode:
            return "Code Verified"
        }
    }
    
    var imageNormalState: String {
        switch self {
        case .sendCode:
            return "paperplane.fill"
        case .verifyCode:
            return "lock.fill"
        }
    }
    
    var imageFinishedState: String {
        switch self {
        case .sendCode:
            return "checkmark"
        case .verifyCode:
            return "lock.open.fill"
        }
    }
    
    func getText(type: AnimatedButtonState) -> String {
        switch type {
            case .normal:
            return textNormalState
        case .pendingResult:
            return textPendingState
        case .receiveResult:
            return textFinishedState
        }
    }
    
    
}

struct CustomAnimatedButton: View {
    @State private var timer: Timer? = nil
    @Binding var buttonStatus: AnimatedButtonState
    @State private var dotCount = 0
    var buttonType: AnimatableButtonType
    var buttonAction: () -> Void

    var body: some View {
        Button(action: {
            self.buttonStatus = .pendingResult
            buttonAction()

        }) {
            HStack(spacing: 0) {
                
                switch buttonStatus {
                case .normal:
                    Image(systemName: buttonType.imageNormalState)
                        .foregroundColor(.whiteBlack)
                case .pendingResult:
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                case .receiveResult:
                    Image(systemName: buttonType.imageFinishedState)
                        .foregroundColor(buttonType == .sendCode ? .green : .whiteBlack)
                }
                

                Text(buttonType.getText(type: buttonStatus))
                    .foregroundColor(.whiteBlack)
                    .applyFont(font: Font.applyStyle(
                        .headingLarge))
                    .padding(.leading, 8)
                
                Text(String(repeating: ".", count: dotCount))
                    .foregroundColor(.whiteBlack)
                    .applyFont(font: Font.applyStyle(
                        .headingLarge))
                    .padding(.leading, 3)
                    .frame(width: 20, alignment: .leading)
                    .animation(.easeInOut, value: dotCount)
                
            }
            .padding()
            .cornerRadius(10)
            .frame(maxWidth: .infinity)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 50)
        .background(Color.blackWhite)
        .cornerRadius(8)
        .onChange(of: buttonStatus) { value in
            switch value {
            case .normal, .receiveResult:
               stopDotAnimation()
            case .pendingResult:
                startDotAnimation()
            }
        }
    }
    
    private func startDotAnimation() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            dotCount = (dotCount + 1) % 4
        }
    }

    private func stopDotAnimation() {
        timer?.invalidate()
        timer = nil
        dotCount = 0
    }
}
