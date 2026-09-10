//
//  PromotionsView.swift
//  YourHotel
//
//  Created by Batsioulas, Theologos on 9/9/26.
//

import SwiftUI
import FirebaseStorage

// MARK: - Model
struct PromotionImage: Identifiable {
    let id = UUID()
    let url: URL
    let name: String
}

// MARK: - Manager
@Observable
final class PromotionsManager {
    @MainActor var promotionImages: [PromotionImage] = []
    @MainActor var isLoading = false
    @MainActor var errorMessage: String?
    
    private let storage = Storage.storage()
    
    @MainActor
    func fetchPromotionImages() async {
        isLoading = true
        
        do {
            let reference = storage.reference().child("promotions")
            let result = try await reference.listAll()
            
            var images: [PromotionImage] = []
            
            for item in result.items {
                let url = try await item.downloadURL()
                images.append(PromotionImage(url: url, name: item.name))
            }
            
            self.promotionImages = images
            isLoading = false
            
        } catch {
            errorMessage = error.localizedDescription
            isLoading = false
            debugPrint("Error fetching promotions: \(error)")
        }
    }
}

// MARK: - View
struct PromotionsView: View {
    @State private var promotionsManager = PromotionsManager()
    @State private var selectedImage: PromotionImage?
    
    var body: some View {
        VStack(spacing: 20) {
            if promotionsManager.isLoading {
                ProgressView()
            } else if promotionsManager.promotionImages.isEmpty {
                Text("No promotions available")
                    .foregroundStyle(.secondary)
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 16) {
                        ForEach(promotionsManager.promotionImages) { image in
                            PromotionImageCard(image: image)
                                .onTapGesture {
                                    selectedImage = image
                                }
                        }
                    }
                    .padding(.horizontal)
                }
            }
            
            if let error = promotionsManager.errorMessage {
                Text(error)
                    .foregroundStyle(.red)
                    .font(.caption)
            }
            
            Spacer()
        }
        .padding()
        .sheet(item: $selectedImage) { image in
            FullSizeImageView(image: image)
        }
        .task {
            await promotionsManager.fetchPromotionImages()
        }
    }
}

// MARK: - Promotion Card
struct PromotionImageCard: View {
    let image: PromotionImage
    
    var body: some View {
        AsyncImage(url: image.url) { phase in
            switch phase {
            case .empty:
                ProgressView()
            case .success(let image):
                image
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150, height: 150)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            case .failure:
                Image(systemName: "photo")
                    .foregroundStyle(.gray)
            @unknown default:
                EmptyView()
            }
        }
        .frame(width: 150, height: 150)
        .shadow(radius: 4)
    }
}

// MARK: - Full Size View
struct FullSizeImageView: View {
    @Environment(\.dismiss) var dismiss
    let image: PromotionImage
    
    var body: some View {
        ZStack {
            // Black background
            Color.clear.ignoresSafeArea()
            
            VStack {
                // Close button
                HStack {
                    Spacer()
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 24))
                            .foregroundStyle(.black)
                    }
                    .padding()
                }
                
                Spacer()
                
                AsyncImage(url: image.url) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFit()
//                            .frame(width: 150, height: 150)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    case .failure:
                        Image(systemName: "photo")
                            .foregroundStyle(.gray)
                    @unknown default:
                        EmptyView()
                    }
                }
                
                Spacer()
            }
        }
    }
}
