//
//  ServicesView.swift
//  YourHotel
//
//  Created by Batsioulas, Theologos on 20/6/26.
//
import SwiftUI

struct ServicesView: View {
    @EnvironmentObject var auth: UserAuthModel
    @Binding var tabSelected: Int
    @Binding var bookRoomExpanded: Bool
    
    var body: some View {
        ScrollView {
            
            DisclosureGroup(isExpanded: $bookRoomExpanded) {
                DetailedHotelBookingView()
                    .frame(height: 450)
//                    .background(LinearGradient(colors:  [Color.primaryColor, Color.surfaceVariant], startPoint: .top, endPoint: .bottom))

                
            } label: {
                HStack {
                    Image(systemName: "calendar.and.person")
                        .font(.largeTitle)
                    
                    Spacer()

                    Text("Book a Room")
                        .font(.title)
                        .fontWeight(.black)
                    Spacer()

                }
                .foregroundStyle(.white)
                .padding(.horizontal, 20)
                .padding(.vertical, 20)
            }
            .padding(4)
            .background(LinearGradient(colors:  [Color.primaryColor, Color.surfaceVariant], startPoint: .top, endPoint: .bottom))
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .padding(.horizontal, 16)
            .padding(.top, 10)
            
            
            
            Spacer()
            if !auth.userLoggedIn {

                SignInVerticalView(tabSelected: $tabSelected)
                    .padding(.top, 30)
            }
            Spacer()
        }
    }
}



struct DetailedHotelBookingView: View {
    // --- STATE MANAGEMENT ---
    @State private var checkInDate = Date()
    @State private var checkOutDate = Calendar.current.date(byAdding: .day, value: 1, to: Date()) ?? Date()
    
    // Guest & Room Controls
    @State private var numberOfRooms = 1  // Bounds: 1 to 5
    @State private var numberOfAdults = 1 // Bounds: 1 to 5
    @State private var numberOfChildren = 0 // Bounds: 0 to 4
    @State private var showGuestPicker = false

    
    var body: some View {
        NavigationStack {
            Form {
                // --- SECTION 1: CALENDAR SELECTION ---
                Section("Select Your Dates") {
                    DatePicker(selection: $checkInDate, in: Date()..., displayedComponents: .date) {
                        Label("Check-In Date", systemImage: "calendar.badge.plus")
                            .fontWeight(.medium)
                    }
                    .datePickerStyle(.compact)
                    
                    DatePicker(selection: $checkOutDate, in: checkInDate..., displayedComponents: .date) {
                        Label("Check-Out Date", systemImage: "calendar.badge.minus")
                            .fontWeight(.medium)
                    }
                    .datePickerStyle(.compact)
                }
                
                // --- SECTION 2: ROOM & GUEST SELECTION ---
                Section("Guests") {
                    Button {
                        showGuestPicker = true
                    } label: {
                        HStack {
                            Label("Rooms & Guests", systemImage: "person.2.fill")
                                .foregroundColor(.primary)
                                .font(.subheadline)
                            
                            Spacer()
                            
                            Text("\(numberOfRooms) Rοοm, \(numberOfAdults + numberOfChildren) Guest\(numberOfAdults + numberOfChildren > 1 ? "s" : "")")
                                .font(.callout)
                                .fontWeight(.medium)
                                .foregroundColor(.blue)
                            
                            Image(systemName: "chevron.right")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                }
                
                // --- SECTION 3: BOOKING BUTTON ---
                Section {
                    Button {
                        executeSearch()
                    } label: {
                        HStack {
                            Spacer()
                            Text("Find Available Rooms")
                                .font(.headline)
                                .foregroundColor(.white)
                            Spacer()
                        }
                    }
                    .listRowBackground(Color.blue)
                }
            }
            .navigationTitle("Reservation Setup")
        }
        .sheet(isPresented: $showGuestPicker) {
            GuestSelectionSheet(
                rooms: $numberOfRooms,
                adults: $numberOfAdults,
                children: $numberOfChildren
            )
            .presentationDetents([.medium]) // Locks sheet size to exactly half-screen height
            .presentationDragIndicator(.visible)
        }
    }
    
    private func executeSearch() {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        
        print("""
        --- Requesting Reservation ---
        Stay: \(formatter.string(from: checkInDate)) -> \(formatter.string(from: checkOutDate))
        Rooms: \(numberOfRooms)
        Party Configuration: \(numberOfAdults) Adults, \(numberOfChildren) Children
        """)
    }
}




// --- SEPARATE COMPACT BOTTOM SHEET WRAPPER ---
struct GuestSelectionSheet: View {
    @Binding var rooms: Int
    @Binding var adults: Int
    @Binding var children: Int
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack(spacing: 24) {
            HStack {
                Text("Select Accommodations")
                    .font(.headline)
                Spacer()
                Button("Done") { dismiss() }
                    .font(.body.bold())
            }
            .padding(.horizontal)
            .padding(.top, 24)
            
            List {
                Stepper("Rooms (\(rooms))", value: $rooms, in: 1...5)
                Stepper("Adults (\(adults))", value: $adults, in: 1...5)
                Stepper("Children (\(children))", value: $children, in: 0...4)
            }
            .listStyle(.plain)
        }
    }
}
