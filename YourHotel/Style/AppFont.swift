//
//  AppFont.swift
//  YourHotel
//
//  Created by Batsioulas, Theologos on 15/12/24.
//

import SwiftUI


extension Font {
    
    enum AppFont {
        case displayLarge
        case displayMedium
        case displaySmall
        case headinleLarge
        case headingMedium
        case headingSmall
        case titleLarge
        case titleMedium
        case titleSmall
        case bodyLarge
        case bodyMedium
        case bodySmall
        case labelLarge
        case labelMedium
        case labelSmall
    }
    
    //return Font for each case for .system font REPLACE with custom selected font
    static func font(style: AppFont) -> Font {
        switch style {
            
        case .displayLarge:
            return Font.system(size: 34, weight: .heavy)
        case .displayMedium:
            return Font.system(size: 28, weight: .bold)
        case .displaySmall:
            return Font.system(size: 22, weight: .bold)
        case .headinleLarge:
            return Font.system(size: 20, weight: .bold)
        case .headingMedium:
            return Font.system(size: 17, weight: .bold)
        case .headingSmall:
            return Font.system(size: 15, weight: .bold)
        case .titleLarge:
            return Font.system(size: 20, weight: .medium)
        case .titleMedium:
            return Font.system(size: 17, weight: .medium)
        case .titleSmall:
            return Font.system(size: 15, weight: .medium)
        case .bodyLarge:
            return Font.system(size: 17, weight: .regular)
        case .bodyMedium:
            return Font.system(size: 16, weight: .regular)
        case .bodySmall:
            return Font.system(size: 13, weight: .regular)
        case .labelLarge:
            return Font.system(size: 17, weight: .thin)
        case .labelMedium:
            return Font.system(size: 16, weight: .thin)
        case .labelSmall:
            return Font.system(size: 12, weight: .thin)
        }
        
    }
    
    
}
