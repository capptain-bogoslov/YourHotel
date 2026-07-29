//
//  DateHandler.swift
//  YourHotel
//
//  Created by Batsioulas, Theologos on 5/5/25.
//
import Foundation

class DateHandler {
        
    static let shared = DateHandler()
    fileprivate let formatter: DateFormatter
    
    private init() {
        formatter = DateFormatter()
    }
    
    //get Date & format as parameter and returns a String with the date in the desired format
    func getDateFromDate(date: Date?, format: String) -> String {
        guard let date = date else { return "" }
        let formatter = self.formatter
        formatter.dateFormat = format
        
        return formatter.string(from: date)
    }
    
    func getFormattedDateString(format: String, from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.calendar = Calendar(identifier: .gregorian)
        
        return formatter.string(from: date)
    }
    
    func getNumberOfDays(fromDate: Date, toDate: Date) -> Int {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: fromDate, to: toDate)
        let daysApart = components.day ?? 0
        return daysApart
    }
    
    func getCurrentDayName() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        
        // 🌟 Crucial: Forces the output to be in English, ignoring user device settings
        formatter.locale = Locale(identifier: "en_US_POSIX")
        
        // Returns the current day name capitalized
        return formatter.string(from: Date())
    }
}

