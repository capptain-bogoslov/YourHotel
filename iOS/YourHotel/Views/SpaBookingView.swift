//
//  SpaBookingView.swift
//  YourHotel
//
//  Created by Batsioulas, Theologos on 12/8/26.
//

import SwiftUI

struct SpaBookingView: View {
    @StateObject private var viewModel: ServicesViewModel
    
    // Grid configuration for time slots
    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    init(roomNumber: String) {
        _viewModel = StateObject(wrappedValue: ServicesViewModel(roomNumber: roomNumber))
    }

    var body: some View {
        NavigationView {
            ZStack {
                Color(.systemGroupedBackground)
                    .ignoresSafeArea()

                if viewModel.isLoading {
                    ProgressView("Loading Spa Availability...")
                } else {
                    ScrollView {
                        VStack(spacing: 20) {
                            
                            // MARK: - Room Info Header
                            HStack {
                                Label("Room \(viewModel.roomNumber)", systemImage: "bed.double.fill")
                                    .font(.subheadline.bold())
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(Color.blue.opacity(0.1))
                                    .foregroundColor(.blue)
                                    .clipShape(Capsule())
                                Spacer()
                            }
                            .padding(.horizontal)

                            // MARK: - Treatment Selector (Picker / Dropdown)
                            VStack(alignment: .leading, spacing: 8) {
                                Text("SELECT TREATMENT")
                                    .font(.caption)
                                    .fontWeight(.bold)
                                    .foregroundColor(.secondary)
                                
                                Menu {
                                    Picker("Treatment", selection: $viewModel.selectedTreatment) {
                                        ForEach(viewModel.treatments) { treatment in
                                            Text("\(treatment.name) (\(String(format: "$%.0f", treatment.price)))")
                                                .tag(Optional(treatment))
                                        }
                                    }
                                } label: {
                                    HStack {
                                        VStack(alignment: .leading) {
                                            Text(viewModel.selectedTreatment?.name ?? "Select a treatment")
                                                .font(.headline)
                                                .foregroundColor(.primary)
                                            if let price = viewModel.selectedTreatment?.price {
                                                Text(String(format: "$%.0f • 60 mins", price))
                                                    .font(.subheadline)
                                                    .foregroundColor(.secondary)
                                            }
                                        }
                                        Spacer()
                                        Image(systemName: "chevron.up.chevron.down")
                                            .foregroundColor(.secondary)
                                    }
                                    .padding()
                                    .background(Color(.secondarySystemGroupedBackground))
                                    .cornerRadius(12)
                                }
                            }
                            .padding(.horizontal)

                            // MARK: - Date Selector
                            VStack(alignment: .leading, spacing: 8) {
                                Text("SELECT DATE")
                                    .font(.caption)
                                    .fontWeight(.bold)
                                    .foregroundColor(.secondary)

                                DatePicker(
                                    "Date",
                                    selection: $viewModel.selectedDate,
                                    in: viewModel.minDate...viewModel.maxDate,
                                    displayedComponents: [.date]
                                )
                                .datePickerStyle(.graphical)
                                .padding()
                                .background(Color(.secondarySystemGroupedBackground))
                                .cornerRadius(16)
                                .onChange(of: viewModel.selectedDate) { newDate, _ in
                                    Task {
                                        await viewModel.fetchAndGenerateSlots(for: newDate)
                                    }
                                }
                            }
                            .padding(.horizontal)

                            // MARK: - Time Slot Grid
                            VStack(alignment: .leading, spacing: 8) {
                                Text("AVAILABLE SESSIONS")
                                    .font(.caption)
                                    .fontWeight(.bold)
                                    .foregroundColor(.secondary)

                                LazyVGrid(columns: columns, spacing: 12) {
                                    ForEach(viewModel.availableSlots) { slot in
                                        TimeSlotCell(
                                            slot: slot,
                                            isSelected: viewModel.selectedSlot == slot
                                        ) {
                                            if !slot.isBooked {
                                                viewModel.selectedSlot = slot
                                            }
                                        }
                                    }
                                }
                            }
                            .padding(.horizontal)

                            // MARK: - Confirm Button
                            Button(action: {
                                Task {
                                    await viewModel.bookTreatment()
                                }
                            }) {
                                HStack {
                                    if viewModel.isBooking {
                                        ProgressView().tint(.white)
                                    } else {
                                        Text("Confirm Booking")
                                            .bold()
                                    }
                                }
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(viewModel.selectedSlot == nil ? Color.gray.opacity(0.5) : Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(14)
                            }
                            .disabled(viewModel.selectedSlot == nil || viewModel.isBooking)
                            .padding(.horizontal)
                            .padding(.bottom, 24)
                            
                            Spacer()
                        }
                    }
                }
            }
            .navigationTitle("Book Spa Session")
            .navigationBarTitleDisplayMode(.inline)
            .task {
                await viewModel.loadInitialData()
            }
            .alert("Notice", isPresented: Binding(
                get: { viewModel.alertMessage != nil },
                set: { _ in viewModel.alertMessage = nil }
            )) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(viewModel.alertMessage ?? "")
            }
            .alert("Booking Confirmed! 🎉", isPresented: $viewModel.bookingSuccess) {
                Button("Done", role: .cancel) {}
            } message: {
                Text("Your treatment is reserved for Room \(viewModel.roomNumber) on \(viewModel.selectedDate.formatted(date: .abbreviated, time: .omitted)) at \(viewModel.selectedSlot?.startTime ?? "").")
            }
        }
    }
}

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
