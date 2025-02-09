//
//  Untitled.swift
//  YourHotel
//
//  Created by Batsioulas, Theologos on 9/2/25.
//
import SwiftUI

enum Field {
    case secure, plain
}

struct CustomTextField: View {
    
    @Binding var value: String
    var isPassword: Bool = false
    @FocusState private var inFocus: Field?
    @State private var showPassword = false
    var placeholder: String = ""
    
    var body: some View {
        
        VStack {
            ZStack {
                HStack {
                    if showPassword || !isPassword {
                        TextField(LocalizedStringKey(placeholder), text: $value)
                            .autocorrectionDisabled(true)
                            .textInputAutocapitalization(.none)
                            .focused($inFocus, equals: .plain)
                    } else {
                        SecureField(LocalizedStringKey(placeholder), text: $value)
                            .padding(.horizontal, 10)
                            .focused($inFocus, equals: .secure)
                    }
                    
                    Spacer()
                    if isPassword {
                        Button(action: {
                            self.showPassword.toggle()
                            inFocus = showPassword ? .plain : .secure
                        }) {
                            Image(systemName: showPassword ? "eye.slash.fill" : "eye.fill" )
                            
                                .frame(height: 25)
                                .foregroundColor(.black)
                                .padding(.trailing, 5)
                        }
                    }
                    
                    
                }
                .padding(EdgeInsets(top: 5, leading: 16, bottom: 5, trailing: 16))
                .background {
                    RoundedRectangle(cornerRadius: 5)
                        .fill(Color.tertiaryColor)
                        .opacity(0.2)
                        .frame(height: 45)
                }
                .shadow(radius: 1)
//                .overlay(
//                    RoundedRectangle(cornerRadius: 5, style: .circular)
//                        .stroke(Color.black, lineWidth: 1)
//                        .frame(height: 50))
            }
        }
    }
}
