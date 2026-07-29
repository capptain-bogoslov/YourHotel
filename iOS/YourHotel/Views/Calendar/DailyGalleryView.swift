//
//  DailyGalleryView.swift
//  YourHotel
//
//  Created by Batsioulas, Theologos on 22/6/26.
//

import SwiftUI

struct DailyGalleryView: View {
    @StateObject private var viewModel = DailyPhotosViewModel()
    @State private var selectedTab = 0 // 0 = Today, 1 = Tomorrow
    @State private var currentIndex = 0 // Track active visible image pointer
    var imageHeight: CGFloat {
        imageWidth * 1.7778
    }
    var imageWidth: CGFloat {
        UIScreen.main.bounds.width - 100
    }
    
    var body: some View {
        VStack(spacing: 20) {
            
            // --- TOP TAB BAR CONTROLLER ---
            Picker("Days", selection: $selectedTab) {
                Text("Today").tag(0)
                Text("Tomorrow").tag(1)
            }
            .pickerStyle(.segmented)
            .padding(.horizontal)
            
            Spacer()
            
            // --- CORE PHOTOS CAROUSEL GRID LINK ---
            if viewModel.isLoading {
                ProgressView("Fetching today's files...")
            } else if viewModel.imageUrlStrings.isEmpty {
                ContentUnavailableView("No Photos Found", systemImage: "photo.on.rectangle", description: Text("Upload files to your '\((selectedTab == 0 ? viewModel.todayName : viewModel.tomorrowName).lowercased())' folder in Firebase Storage."))
            } else {
                
                // MAIN COLLECTION WITH NAVIGATIONAL ARROWS
                HStack(spacing: 10) {
                    
                    // Left navigation arrow button
                    Button {
                        if currentIndex > 0 {
                            withAnimation(.spring()) { currentIndex -= 1 }
                        }
                    } label: {
                        Image(systemName: "chevron.left.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30, height: 30)
                            .foregroundColor(currentIndex == 0 ? .secondary.opacity(0.3) : .blue)
                    }
                    .disabled(currentIndex == 0)
                    
                    // Inline Horizontal Slider Framework
                    ScrollViewReader { proxy in
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 16) {
                                ForEach(Array(viewModel.imageUrlStrings.enumerated()), id: \.offset) { index, urlString in
                                    
                                    AsyncImage(url: URL(string: urlString)) { image in
                                        image
                                            .resizable()
                                            .scaledToFill()
                                    } placeholder: {
                                        ProgressView()
                                    }
                                    .frame(width: imageWidth, height: imageHeight)
//                                    .frame(width: 250, height: 350)
                                    .clipShape(RoundedRectangle(cornerRadius: 16))
                                    .shadow(radius: 5)
                                    .padding(.horizontal, 2)
                                    .id(index)
                                }
                            }
                            .padding(.vertical)
                        }
                        // Instantly listen for arrow button taps to slide elements into position frame
                        .onChange(of: currentIndex) { _, newIndex in
                            withAnimation(.easeInOut) {
                                proxy.scrollTo(newIndex, anchor: .center)
                            }
                        }
                    }
//                    .frame(height: 380)
                    .frame(maxHeight: imageHeight + 100)
                    
                    // Right navigation arrow button
                    Button {
                        if currentIndex < viewModel.imageUrlStrings.count - 1 {
                            withAnimation(.spring()) { currentIndex += 1 }
                        }
                    } label: {
                        Image(systemName: "chevron.right.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30, height: 30)
                            .foregroundColor(currentIndex == viewModel.imageUrlStrings.count - 1 ? .secondary.opacity(0.3) : .blue)
                    }
                    .disabled(currentIndex == viewModel.imageUrlStrings.count - 1)
                }
                .padding(.horizontal, 8)
            }
            
            Spacer()
        }
        .padding(.top)
        // Automatically sync and refresh when switching tabs
        .onChange(of: selectedTab, initial: true) { _, newValue in
            currentIndex = 0 // Reset visual carousel indexing counter back to zero
            let targetDay = newValue == 0 ? viewModel.todayName : viewModel.tomorrowName
            viewModel.fetchPhotos(for: targetDay)
        }
    }
}



struct TimelineItemObject: Codable, Identifiable, Hashable {
    let id = UUID()
    let systemImage: String // SF Symbol name
    let startTime: String   // "HH:mm" (e.g., "08:30")
    let endTime: String     // "HH:mm" (e.g., "17:00")
    let label: String
    let location: String    // Used to pick a local symbol or asset
    
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.systemImage = try container.decode(String.self, forKey: .systemImage)
        self.startTime = try container.decode(String.self, forKey: .startTime)
        self.endTime = try container.decode(String.self, forKey: .endTime)
        self.label = try container.decode(String.self, forKey: .label)
        self.location = try container.decode(String.self, forKey: .location)
    }

    
    enum CodingKeys: String, CodingKey {
        case systemImage = "system_image"
        case startTime = "start_time"
        case endTime = "end_time"
        case label
        case location
    }
}


struct CurrentActivitiesWidgetView: View {
    // Stores grouped active items (each element in the outer array represents a unique time slot)
    private var activeTimeSlots: [[TimelineItemObject]] = []
    
    @State private var currentSlotIndex: Int = 0
    @State private var slideTransition: AnyTransition = .slide

    init(rawItems: [TimelineItemObject]) {
        // 1. Get current time numerical fingerprint (e.g., 1415 for 14:15)
        let nowFingerprint = Self.getCurrentTimeFingerprint()
        
        // 2. Filter out ONLY the items happening right now
        let itemsHappeningNow = rawItems.filter { item in
            let start = Self.timeToMinutes(item.startTime)
            let end = Self.timeToMinutes(item.endTime)
            return nowFingerprint >= start && nowFingerprint <= end
        }
        
        // 3. Sort chronologically by startTime
        let sortedCurrentItems = itemsHappeningNow.sorted { Self.timeToMinutes($0.startTime) < Self.timeToMinutes($1.startTime) }
        
        // 4. Group items that have the EXACT same startTime into rows
        let grouped = Dictionary(grouping: sortedCurrentItems, by: { $0.startTime })
        
        // 5. Save the final structurally sorted array of groups
        self.activeTimeSlots = grouped.keys.sorted().compactMap { grouped[$0] }
    }

    var body: some View {
        HStack(spacing: 5) {
            if activeTimeSlots.isEmpty {
                Text("No activities happening right now")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, minHeight: 60)
            } else {
                // --- LEFT ARROW BUTTON ---
                Button(action: showPreviousSlot) {
                    Image(systemName: "chevron.left.circle.fill")
                        .font(.title)
                        .foregroundColor(.accentColor)
                }
                .disabled(activeTimeSlots.count <= 1)

                // --- CENTRAL ROWS CONTAINER ---
                let currentSlotRows = activeTimeSlots[currentSlotIndex]
                
                VStack(spacing: 12) {
                    ForEach(currentSlotRows) { item in
                        HStack(spacing: 12) {
                            // System Image Layout
                            Image(systemName: item.systemImage)
                                .font(.headline)
                                .foregroundColor(.primary)
                            
                            // Label content
                            Text(item.label)
                                .font(.body.weight(.medium))
                                .frame(maxWidth: .infinity)
                            
                            
                            Image(getLocationIcon(for: item.location))
                                .resizable()
                                .font(.body)

                        }
                    }
                }
                .id(currentSlotIndex) // Forces structural redraw animation on click transitions
                .transition(slideTransition)

                // --- RIGHT ARROW BUTTON ---
                Button(action: showNextSlot) {
                    Image(systemName: "chevron.right.circle.fill")
                        .font(.title)
                        .foregroundColor(.accentColor)
                }
                .disabled(activeTimeSlots.count <= 1)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemBackground))
                .shadow(color: Color.black.opacity(0.3), radius: 10, x: 0, y: 4)
        )
        .frame(maxWidth: .infinity)
    }

    // --- TIME PARSING HELPERS ---

    private static func timeToMinutes(_ timeString: String) -> Int {
        let components = timeString.split(separator: ":").compactMap { Int($0) }
        guard components.count == 2 else { return 0 }
        return (components[0] * 60) + components[1] // Converts "17:30" to 1050 absolute minutes
    }

    private static func getCurrentTimeFingerprint() -> Int {
        let components = Calendar.current.dateComponents([.hour, .minute], from: Date())
        return ((components.hour ?? 0) * 60) + (components.minute ?? 0)
    }
    
    private func getLocationIcon(for location: String) -> String {
        switch location {
        case "Mediterranean Restaurant": return "restaurant_graphic"
        case "Pool Bar", "Pool", "Pool Area": return "pool_graphic"
        case "Playground": return "playground_graphic"
        case "Garden": return "garden_graphic"
        case "Aura Beach Lounge": return "aura_graphic"
        case "Panorama Bar": return "panorama_graphic"
        case "Beach": return "beach_graphic"
        default: return "mappin.and.ellipse"
        }
    }

    // --- CAROUSEL ACTIONS ---

    private func showPreviousSlot() {
        slideTransition = .asymmetric(insertion: .move(edge: .leading), removal: .move(edge: .trailing))
        withAnimation(.easeInOut(duration: 0.25)) {
            currentSlotIndex = (currentSlotIndex - 1 + activeTimeSlots.count) % activeTimeSlots.count
        }
    }

    private func showNextSlot() {
        slideTransition = .asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading))
        withAnimation(.easeInOut(duration: 0.25)) {
            currentSlotIndex = (currentSlotIndex + 1) % activeTimeSlots.count
        }
    }
}
