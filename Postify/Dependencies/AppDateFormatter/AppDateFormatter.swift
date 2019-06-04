//
//  AppDateFormatter.swift
//  Postify
//
//  Created by Piotr Mielcarzewicz on 29/10/2018.
//  Copyright © 2018 Piotr Mielcarzewicz. All rights reserved.
//

import Foundation

/// sourcery: AutoDependency
protocol AppDateFormatter {
    func timestamp(from date: Date) -> Int64
    func date(from timestamp: Int64, template: DateTemplate) -> String
}

class AppDateFormatterImp: AppDateFormatter {
    func timestamp(from date: Date) -> Int64 {
        let timeInterval = date.timeIntervalSince1970
        return Int64(timeInterval)
    }
    
    func date(from timestamp: Int64, template: DateTemplate) -> String {
        let date = Date(timeIntervalSince1970: Double(timestamp))
        let dateFormatter = createDateFormatter(with: template)
        return dateFormatter.string(from: date)
    }
}

private extension AppDateFormatter {
    func createDateFormatter(with template: DateTemplate) -> DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = template.rawValue
        return dateFormatter
    }
}
