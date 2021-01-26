//
//  Date+DateFormatter.swift
//  NewsApp
//
//  Created by Satsishur on 18.01.2021.
//

import Foundation

extension Date {
    ///Date formatter with short date and medium time
    static var ptBRFormatter: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .medium
        dateFormatter.locale = Locale(identifier: "en_US")
        return dateFormatter
    }
    
}
