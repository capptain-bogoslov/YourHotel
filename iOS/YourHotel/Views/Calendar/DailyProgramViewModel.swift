//
//  DailyProgramViewModel.swift
//  YourHotel
//
//  Created by Batsioulas, Theologos on 22/6/26.
//

import Foundation
import FirebaseStorage

@MainActor
class DailyPhotosViewModel: ObservableObject {
    @Published var imageUrlStrings: [String] = []
    @Published var isLoading: Bool = false
    
    // Day calculation strings
    let todayName: String
    let tomorrowName: String
    
    init() {
        let calendar = Calendar.current
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE" // Yields full day name like "Monday"
        formatter.locale = Locale(identifier: "en_US")
        
        let todayDate = Date()
        let tomorrowDate = calendar.date(byAdding: .day, value: 1, to: todayDate) ?? todayDate
        
        self.todayName = formatter.string(from: todayDate)
        self.tomorrowName = formatter.string(from: tomorrowDate)
    }
    
    /// Scans the target folder and fetches image download paths from Firebase Storage
    func fetchPhotos(for dayName: String) {
        let folderName = dayName.lowercased()
        self.isLoading = true
        self.imageUrlStrings = [] // Clear previous photos
        
        Task {
            let storageRef = Storage.storage().reference().child(folderName)
            
            do {
                // 1. Fetch all items inside the target day directory reference
                let result = try await storageRef.listAll()
                
                // 2. Map items to their downloadable web URLs concurrently
                var urls: [String] = []
                for item in result.items {
                    if let url = try? await item.downloadURL() {
                        urls.append(url.absoluteString)
                    }
                }
                
                guard !Task.isCancelled else { return }
                self.imageUrlStrings = urls
                self.isLoading = false
            } catch {
                print("Error scanning Firebase Storage items: \(error.localizedDescription)")
                self.isLoading = false
            }
        }
    }
}
