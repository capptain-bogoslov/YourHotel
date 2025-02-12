//
//  SegmentedPicker.swift
//  YourHotel
//
//  Created by Batsioulas, Theologos on 12/2/25.
//

import SwiftUI

struct SegmentedPicker: UIViewRepresentable {
    @Binding var selectedIndex: Int
    var options: [String]
    var selectedColor: UIColor
    var backgroundColor: UIColor
    var textColor: UIColor

    func makeUIView(context: Context) -> UISegmentedControl {
        let segmentedControl = UISegmentedControl(items: options.map { NSLocalizedString($0, comment: "") })
        segmentedControl.selectedSegmentIndex = selectedIndex

        // Customize appearance
        segmentedControl.selectedSegmentTintColor = selectedColor
        segmentedControl.backgroundColor = backgroundColor
        segmentedControl.setTitleTextAttributes([.foregroundColor: textColor], for: .normal)
        segmentedControl.setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)

        // Add target to handle selection changes
        segmentedControl.addTarget(
            context.coordinator,
            action: #selector(Coordinator.valueChanged(_:)),
            for: .valueChanged
        )

        return segmentedControl
    }

    func updateUIView(_ uiView: UISegmentedControl, context: Context) {
        uiView.selectedSegmentIndex = selectedIndex
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(selectedIndex: $selectedIndex)
    }

    class Coordinator: NSObject {
        @Binding var selectedIndex: Int

        init(selectedIndex: Binding<Int>) {
            self._selectedIndex = selectedIndex
        }

        @objc func valueChanged(_ sender: UISegmentedControl) {
            selectedIndex = sender.selectedSegmentIndex
        }
    }
}

