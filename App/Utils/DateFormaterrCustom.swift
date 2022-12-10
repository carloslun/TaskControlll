//
//  DateFormaterrCustom.swift
//  TaskControl
//
//  Created by Carlos Luna Salazar on 01-12-22.
//

import Foundation
class DateFormaterrCustom {
    static func formattedDateFromString(dateString: String, withFormat format: String) -> String? {
        
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "dd/MM/yyyy"
        
        if let date = inputFormatter.date(from: dateString) {
            
            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = format
            
            return outputFormatter.string(from: date)
        }
        
        return nil
    }
}
