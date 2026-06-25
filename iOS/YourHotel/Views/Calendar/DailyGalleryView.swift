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
        UIScreen.main.bounds.width - 96
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
                                    // Give each layout item a dynamic ID target matching its index pointer
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

