//
//  ViewExtension.swift
//  YourHotel
//
//  Created by Batsioulas, Theologos on 31/3/25.
//
import SwiftUI

extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
