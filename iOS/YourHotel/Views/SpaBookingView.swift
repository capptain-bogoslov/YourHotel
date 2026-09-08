//
//  SpaBookingView.swift
//  YourHotel
//
//  Created by Batsioulas, Theologos on 12/8/26.
//

import SwiftUI
import Foundation
import FirebaseFirestore

// MARK: - Time Slot Grid Button Subview
struct TimeSlotCell: View {
    let slot: TimeSlot
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: slot.isBooked ? "xmark.circle.fill" : (isSelected ? "checkmark.circle.fill" : "clock"))
                Text(slot.displayString)
                    .font(.subheadline)
                    .bold()
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .background(backgroundColor)
            .foregroundColor(foregroundColor)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(borderColor, lineWidth: isSelected ? 2 : 0)
            )
        }
        .disabled(slot.isBooked)
    }

    private var backgroundColor: Color {
        if slot.isBooked {
            return Color(.systemGray5)
        } else if isSelected {
            return Color.blue
        } else {
            return Color(.secondarySystemGroupedBackground)
        }
    }

    private var foregroundColor: Color {
        if slot.isBooked {
            return Color.gray
        } else if isSelected {
            return Color.white
        } else {
            return Color.primary
        }
    }

    private var borderColor: Color {
        isSelected ? Color.blue : Color.clear
    }
}


struct Treatment: Identifiable, Hashable, Codable {
    @DocumentID var id: String?
    let name: String
    let durationMinutes: Int
    let price: Int
}

struct SpaBooking: Identifiable, Codable {
    @DocumentID var id: String?
    let createdAt: Date
    let date: String // Format: "YYYY-MM-DD"
    let startTime: String // Format: "10:00"
    let endTime: String // Format: "11:00"
    let roomNumber: String
    let treatmentId: String
    let treatmentName: String
    let status: String // "confirmed" or "unconfirmed"
}

struct TimeSlotNew: Identifiable {
    var id: String { "\(startTime)-\(endTime)" }
    let startTime: String
    let endTime: String
    
    var label: String {
        "\(startTime)-\(endTime)"
    }
}

struct SpaBookingView: View {
    @StateObject var viewModel: ServicesViewModel
    var roomNumber: String
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    
                    // 1. Calendar Day Selector (Today + Next 6 Days)
                    VStack(alignment: .leading) {
                        Text("Select Date")
                            .font(.headline)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 12) {
                                ForEach(viewModel.weekDays, id: \.self) { date in
                                    let isSelected = Calendar.current.isDate(date, inSameDayAs: viewModel.selectedDate)
                                    
                                    Button(action: {
                                        viewModel.selectedDate = date
                                    }) {
                                        VStack(spacing: 4) {
                                            Text(date.formatted(.dateTime.weekday(.abbreviated)))
                                                .font(.caption)
                                                .bold()
                                            Text(date.formatted(.dateTime.day()))
                                                .font(.title3)
                                                .bold()
                                            
                                            if Calendar.current.isDateInToday(date) {
                                                Text("TODAY")
                                                    .font(.system(size: 8, weight: .bold))
                                                    .foregroundColor(.blue)
                                            }
                                        }
                                        .frame(width: 60, height: 75)
                                        .background(isSelected ? Color.blue.opacity(0.15) : Color(.systemGray6))
                                        .cornerRadius(10)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 10)
                                                .stroke(isSelected ? Color.blue : Color.clear, lineWidth: 2)
                                        )
                                    }
                                    .padding(5)
                                    .buttonStyle(.plain)
                                }
                            }
                        }
                    }
                    .padding(.horizontal)
                    
                    // 2. Treatment Picker
                    VStack(alignment: .leading) {
                        Text("Select Treatment")
                            .font(.headline)
                        
                        Picker("Treatment", selection: $viewModel.selectedTreatment) {
                            ForEach(viewModel.treatments) { treatment in
                                Text("\(treatment.name) (\(treatment.durationMinutes)m - $\(treatment.price))")
                                    .tag(Optional(treatment))
                            }
                        }
                        .pickerStyle(.menu)
                        .padding(8)
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                    }
                    .padding(.horizontal)
                    
                    // 3. Time Slots Grid
                    VStack(alignment: .leading) {
                        Text("Available Sessions")
                            .font(.headline)
                        
                        LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))], spacing: 10) {
                            ForEach(viewModel.availableTimeSlots) { slot in
                                let isConfirmed = viewModel.isSlotConfirmed(slot)
                                let isSelected = viewModel.selectedTimeSlot?.id == slot.id
                                
                                Button(action: {
                                    if !isConfirmed {
                                        viewModel.selectedTimeSlot = slot
                                    }
                                }) {
                                    VStack(spacing: 4) {
                                        Text(slot.label)
                                            .font(.caption)
                                            .bold()
                                        
                                        Text(isConfirmed ? "Unavailable" : "Available")
                                            .font(.system(size: 9))
                                            .foregroundColor(isConfirmed ? .red : .green)
                                    }
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 10)
                                    .background(
                                        isConfirmed ? Color.red.opacity(0.1) :
                                            (isSelected ? Color.blue.opacity(0.15) : Color(.systemGray6))
                                    )
                                    .cornerRadius(8)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(
                                                isConfirmed ? Color.red.opacity(0.3) :
                                                    (isSelected ? Color.blue : Color.clear),
                                                lineWidth: 2
                                            )
                                    )
                                }
                                .disabled(isConfirmed)
                            }
                        }
                    }
                    .padding(.horizontal)
                    
                    // 4. Room Number Input & Submit
                    VStack(alignment: .leading, spacing: 12) {

                        HStack {
                            Label("Room \(roomNumber)", systemImage: "bed.double.fill")
                                .font(.subheadline.bold())
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(Color.blue.opacity(0.1))
                                .foregroundColor(.blue)
                                .clipShape(Capsule())
                            Spacer()
                        }
                        .padding(.horizontal)
                        
                        Button(action: {
                            Task {
                                await viewModel.createBooking(roomNumber: roomNumber)
                            }
                        }) {
                            HStack {
                                Spacer()
                                if viewModel.isLoading {
                                    ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                } else {
                                    Text("Book Spa Session")
                                        .bold()
                                }
                                Spacer()
                            }
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                        }
                        .disabled(viewModel.isLoading)
                    }
                    .padding(.horizontal)
                }
                .padding(.vertical)
            }
            .navigationTitle("Book Spa")
            .alert(item: Binding<AlertItem?>(
                get: { viewModel.alertMessage != nil ? AlertItem(message: viewModel.alertMessage!) : nil },
                set: { _ in viewModel.alertMessage = nil }
            )) { item in
                Alert(title: Text("Booking Status"), message: Text(item.message), dismissButton: .default(Text("OK")))
            }
        }
    }
}

struct AlertItem: Identifiable {
    let id = UUID()
    let message: String
}
