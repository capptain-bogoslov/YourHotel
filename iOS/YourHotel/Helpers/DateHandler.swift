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
}

