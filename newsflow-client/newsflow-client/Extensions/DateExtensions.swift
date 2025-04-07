//
//  DateExtensions.swift
//  newsflow-client
//
//  Created by Yazan Ghunaim on 4/7/25.
//

import Foundation

extension Date {
    func formattedDateString() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: self)
    }
}
