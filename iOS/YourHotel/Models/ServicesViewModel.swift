//
//  ServicesViewModel.swift
//  YourHotel
//
//  Created by Batsioulas, Theologos on 12/8/26.
//


import SwiftUI
import FirebaseFirestore

// MARK: - Models
struct SpaTreatment: Identifiable, Hashable {
    let id: String
    let name: String
    let durationMinutes: Int
    let price: Double
}

struct TimeSlot: Identifiable, Hashable {
    let id = UUID()
    let startTime: String // e.g. "10:00"
    let endTime: String   // e.g. "11:00"
    let isBooked: Bool
    
    var displayString: String {
        "\(startTime) - \(endTime)"
    }
}

// MARK: - View Model
@MainActor
final class ServicesViewModel: ObservableObject {
    @Published var treatments: [SpaTreatment] = []
    @Published var selectedTreatment: SpaTreatment?
    @Published var selectedDate: Date = Calendar.current.date(byAdding: .day, value: 1, to: Date()) ?? Date()
    @Published var selectedSlot: TimeSlot?
    @Published var availableSlots: [TimeSlot] = []
    
    @Published var minDate: Date = Date()
    @Published var maxDate: Date = Date()
    
    @Published var isLoading = false
    @Published var isBooking = false
    @Published var alertMessage: String?
    @Published var bookingSuccess = false

    private let db = Firestore.firestore()
    private var openingHour: Int = 10  // Default fallback
    private var closingHour: Int = 18  // Default fallback
    
    // Pass the room number from your user session
    let roomNumber: String

    init(roomNumber: String) {
        self.roomNumber = roomNumber
    }

    // MARK: - Initial Setup
    func loadInitialData() async {
        isLoading = true
        await fetchBookingRules()
        await fetchTreatments()
        await fetchAndGenerateSlots(for: selectedDate)
        isLoading = false
    }

    // MARK: - 1. Fetch Rules (Opening Hours & Booking Window)
    private func fetchBookingRules() async {
        do {
            let snapshot = try await db.collection("spa_settings").document("config").getDocument()
            if let data = snapshot.data() {
                self.openingHour = data["openingHour"] as? Int ?? 10
                self.closingHour = data["closingHour"] as? Int ?? 18
                
                let minDaysAhead = data["minDaysAhead"] as? Int ?? 1
                let maxDaysAhead = data["maxDaysAhead"] as? Int ?? 14
                
                let calendar = Calendar.current
                self.minDate = calendar.date(byAdding: .day, value: minDaysAhead, to: Date()) ?? Date()
                self.maxDate = calendar.date(byAdding: .day, value: maxDaysAhead, to: Date()) ?? Date()
                
                // Ensure selectedDate falls within valid range
                if self.selectedDate < self.minDate {
                    self.selectedDate = self.minDate
                }
            }
        } catch {
            print("Error fetching rules, using defaults: \(error.localizedDescription)")
            let calendar = Calendar.current
            self.minDate = calendar.date(byAdding: .day, value: 1, to: Date())!
            self.maxDate = calendar.date(byAdding: .day, value: 14, to: Date())!
        }
    }

    // MARK: - 2. Fetch Treatments Dropdown
    private func fetchTreatments() async {
        do {
            let snapshot = try await db.collection("spa_treatments").getDocuments()
            self.treatments = snapshot.documents.compactMap { doc in
                let data = doc.data()
                guard let name = data["name"] as? String else { return nil }
                let duration = data["durationMinutes"] as? Int ?? 60
                let price = data["price"] as? Double ?? 0.0
                return SpaTreatment(id: doc.documentID, name: name, durationMinutes: duration, price: price)
            }
            if let first = self.treatments.first {
                self.selectedTreatment = first
            }
        } catch {
            self.alertMessage = "Failed to load treatments: \(error.localizedDescription)"
        }
    }

    // MARK: - 3. Fetch Bookings & Build Slots for Selected Date
    func fetchAndGenerateSlots(for date: Date) async {
        self.selectedSlot = nil
        let dateString = formatDateForFirestore(date)
        
        do {
            // Fetch existing bookings for this date
            let snapshot = try await db.collection("spa_bookings")
                .whereField("date", isEqualTo: dateString)
                .getDocuments()
            
            let bookedHours = snapshot.documents.compactMap { doc -> String? in
                return doc.data()["startTime"] as? String
            }
            
            // Generate 1-hour slots from openingHour to closingHour
            var slots: [TimeSlot] = []
            for hour in openingHour..<closingHour {
                let startStr = String(format: "%02d:00", hour)
                let endStr = String(format: "%02d:00", hour + 1)
                
                let isBooked = bookedHours.contains(startStr)
                slots.append(TimeSlot(startTime: startStr, endTime: endStr, isBooked: isBooked))
            }
            
            self.availableSlots = slots
        } catch {
            self.alertMessage = "Failed to load availability: \(error.localizedDescription)"
        }
    }

    // MARK: - 4. Commit Booking to Firestore
    func bookTreatment() async {
        guard let treatment = selectedTreatment else {
            alertMessage = "Please select a treatment."
            return
        }
        guard let slot = selectedSlot else {
            alertMessage = "Please select a time slot."
            return
        }
        
        isBooking = true
        let dateString = formatDateForFirestore(selectedDate)
        
        let bookingData: [String: Any] = [
            "roomNumber": roomNumber,
            "treatmentId": treatment.id,
            "treatmentName": treatment.name,
            "date": dateString,
            "startTime": slot.startTime,
            "endTime": slot.endTime,
            "createdAt": FieldValue.serverTimestamp()
        ]
        
        do {
            // Save to Firestore
            try await db.collection("spa_bookings").addDocument(data: bookingData)
            
            // Refresh slots to mark as booked locally
            await fetchAndGenerateSlots(for: selectedDate)
            
            self.bookingSuccess = true
        } catch {
            self.alertMessage = "Failed to complete booking: \(error.localizedDescription)"
        }
        
        isBooking = false
    }

    private func formatDateForFirestore(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }
}
