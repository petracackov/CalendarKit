//
//  DateComponents+Date.swift
//  BloodyBrilliant
//
//  Created by Petra Cackov on 10. 10. 24.
//

import Foundation

extension DateComponents {
    
    var date: Date {
        let calendar = Calendar.current
        return calendar.date(from: self) ?? Date()
    }
    
}
