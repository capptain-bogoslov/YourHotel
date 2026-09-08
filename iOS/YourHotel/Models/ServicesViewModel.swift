//
//  ServicesViewModel.swift
//  YourHotel
//
//  Created by Batsioulas, Theologos on 12/8/26.
//


import SwiftUI
import FirebaseFirestore
import Foundation
import Combine

// MARK: - Models

struct TimeSlot: Identifiable, Hashable {
    let id = UUID()
    let startTime: String // e.g. "10:00"
    let endTime: String   // e.g. "11:00"
    let isBooked: Bool
    
    var displayString: String {
        "\(startTime) - \(endTime)"
    }
}

@MainActor
class ServicesViewModel: ObservableObject {
    @Published var selectedDate: Date = Date() {
        didSet {
            listenToBookings()
        }
    }
    @Published var treatments: [Treatment] = []
    @Published var selectedTreatment: Treatment?
    @Published var selectedTimeSlot: TimeSlotNew?
    @Published var confirmedBookings: [SpaBooking] = []
    @Published var isLoading: Bool = false
    @Published var alertMessage: String?
    
    private let db = Firestore.firestore()
    private var listener: ListenerRegistration?
    
    // Rolling 7-day options (Today + next 6 days)
    var weekDays: [Date] {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        return (0..<7).compactMap { calendar.date(byAdding: .day, value: $0, to: today) }
    }
    
    // Available hourly time slots (10:00 to 20:00)
    var availableTimeSlots: [TimeSlotNew] {
        var slots: [TimeSlotNew] = []
        for hour in 10..<20 {
            let start = String(format: "%02d:00", hour)
            let end = String(format: "%02d:00", hour + 1)
            slots.append(TimeSlotNew(startTime: start, endTime: end))
        }
        return slots;
    }
    
    var selectedDateFormattedString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: selectedDate)
    }
    
    init() {
        fetchTreatments()
        listenToBookings()
    }
    
    deinit {
        listener?.remove()
    }
    
    // Check if a time slot is booked with "confirmed" status
    func isSlotConfirmed(_ slot: TimeSlotNew) -> Bool {
        confirmedBookings.contains { booking in
            booking.startTime == slot.startTime && booking.status.lowercased() == "confirmed"
        }
    }
    
    // Fetch Treatments dropdown items from `spa_treatments`
    func fetchTreatments() {
        db.collection("spa_treatments").getDocuments { [weak self] snapshot, error in
            guard let documents = snapshot?.documents, error == nil else { return }
            DispatchQueue.main.async {
                self?.treatments = documents.compactMap { try? $0.data(as: Treatment.self) }
                if self?.selectedTreatment == nil {
                    self?.selectedTreatment = self?.treatments.first
                }
            }
        }
    }
    
    // Real-time listener for bookings on selected date
    func listenToBookings() {
        listener?.remove()
        
        let dateStr = selectedDateFormattedString
        listener = db.collection("spa_bookings")
            .whereField("date", isEqualTo: dateStr)
            .addSnapshotListener { [weak self] snapshot, error in
                guard let documents = snapshot?.documents, error == nil else { return }
                DispatchQueue.main.async {
                    let allBookings = documents.compactMap { try? $0.data(as: SpaBooking.self) }
                    // Filter to strictly confirmed bookings for availability status
                    self?.confirmedBookings = allBookings.filter { $0.status.lowercased() == "confirmed" }
                }
            }
    }
    
    // Create new booking with status "unconfirmed"
    func createBooking(roomNumber: String) async {
        guard let treatment = selectedTreatment,
              let slot = selectedTimeSlot,
              !roomNumber.trimmingCharacters(in: .whitespaces).isEmpty else {
            alertMessage = "Please select treatment, time slot, and enter room number."
            return
        }
        
        isLoading = true
        defer { isLoading = false }
        
        let newBookingData: [String: Any] = [
            "createdAt": FieldValue.serverTimestamp(),
            "date": selectedDateFormattedString,
            "startTime": slot.startTime,
            "endTime": slot.endTime,
            "roomNumber": roomNumber,
            "treatmentId": treatment.id ?? "",
            "treatmentName": treatment.name,
            "status": "unconfirmed"
        ]
        
        do {
            try await db.collection("spa_bookings").addDocument(data: newBookingData)
            alertMessage = "Booking requested! Status: Unconfirmed"
            selectedTimeSlot = nil
        } catch {
            alertMessage = "Error saving booking: \(error.localizedDescription)"
        }
    }
}
