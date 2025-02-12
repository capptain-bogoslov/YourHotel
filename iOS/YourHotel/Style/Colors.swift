//
//  Colors.swift
//  YourHotel
//
//  Created by Batsioulas, Theologos on 19/12/24.
//

import Foundation
import SwiftUI
import UIKit

extension Color {
    static let primaryColor = Color("PrimaryColor")
    static let secondaryColor = Color("SecondaryColor")
    static let tertiaryColor = Color("TertiaryColor")
    static let accentPrimaryColor = Color("Surface")
    static let accentSecondaryColor = Color("SurfaceVariant")
    static let emphasisColor = Color("SurfaceBright")
    static let blackWhite = Color("BlackWhiteVariation")
    static let whiteBlack = Color("WhiteBlackVariation")
}

extension UIColor {
    convenience init?(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

        var rgb: UInt64 = 0

        guard Scanner(string: hexSanitized).scanHexInt64(&rgb) else {
            return nil // Invalid hex string
        }

        let red = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgb & 0x0000FF) / 255.0

        self.init(red: red, green: green, blue: blue, alpha: 1.0)
    }
}
