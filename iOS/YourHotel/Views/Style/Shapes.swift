//
//  Shapes.swift
//  YourHotel
//
//  Created by Batsioulas, Theologos on 4/4/25.
//
import SwiftUI

//right drawer for Home
struct TextFieldOutline2: Shape {
    func path(in rect: CGRect) -> Path {
        Path { path in
            
            path.move(to: CGPoint(x: rect.minX, y: rect.maxY - 30))
            path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY - 10))
            path.addQuadCurve(to: CGPoint(x: rect.minX + 10, y: rect.maxY), control: CGPoint(x: rect.minX, y: rect.maxY))
            path.addLine(to: CGPoint(x: rect.maxX - 10, y: rect.maxY))
            path.addQuadCurve(to: CGPoint(x: rect.maxX, y: rect.maxY - 10), control: CGPoint(x: rect.maxX, y: rect.maxY))
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY - 30))
            
        }
    }
}

struct TextFieldOutline: Shape {
    // Animatable properties
    var bottomCornerRadius: CGFloat
    var sideInset: CGFloat
    
    // For animation to work, we need to implement the animatableData property
    var animatableData: AnimatablePair<CGFloat, CGFloat> {
        get { AnimatablePair(bottomCornerRadius, sideInset) }
        set {
            bottomCornerRadius = newValue.first
            sideInset = newValue.second
        }
    }
    
    func path(in rect: CGRect) -> Path {
        //style #1
//        Path { path in
//            path.move(to: CGPoint(x: rect.minX, y: rect.maxY - sideInset))
//            path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY - bottomCornerRadius))
//            path.addQuadCurve(
//                to: CGPoint(x: rect.minX + bottomCornerRadius, y: rect.maxY),
//                control: CGPoint(x: rect.minX, y: rect.maxY)
//            )
//            path.addLine(to: CGPoint(x: rect.maxX - bottomCornerRadius, y: rect.maxY))
//            path.addQuadCurve(
//                to: CGPoint(x: rect.maxX, y: rect.maxY - bottomCornerRadius),
//                control: CGPoint(x: rect.maxX, y: rect.maxY)
//            )
//            path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY - sideInset))
//        }
        
        //style #2
        Path { path in
            path.move(to: CGPoint(x: rect.minX, y: rect.maxY - bottomCornerRadius))
            path.addQuadCurve(
                to: CGPoint(x: rect.minX + bottomCornerRadius, y: rect.maxY),
                control: CGPoint(x: rect.minX, y: rect.maxY)
            )
            path.addLine(to: CGPoint(x: rect.maxX - bottomCornerRadius, y: rect.maxY))
            path.addQuadCurve(
                to: CGPoint(x: rect.maxX, y: rect.maxY - bottomCornerRadius),
                control: CGPoint(x: rect.maxX, y: rect.maxY)
            )
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY - sideInset))
        }
    }
    
    // Initialize with default values
    init(bottomCornerRadius: CGFloat = 10, sideInset: CGFloat = 30) {
        self.bottomCornerRadius = bottomCornerRadius
        self.sideInset = sideInset
    }
}
