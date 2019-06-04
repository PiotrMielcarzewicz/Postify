//
//  DateTemplate.swift
//  Postify
//
//  Created by Piotr Mielcarzewicz on 29/10/2018.
//  Copyright © 2018 Piotr Mielcarzewicz. All rights reserved.
//

import Foundation

internal enum DateTemplate: String {
    case weekdayDayMonthHourMinute = "EEE, d MMM, HH:mm"
    case hourMinuteWeekdayDayMonthYear = "HH:mm - EEE, dd MMM yyyy"
    case hourMinute = "HH:mm"
    case weekdayDayMonthYear = "EEE, d MMM yyyy"
    case weekdayDayMonth = "EEE, d MMM"
    case weekdayHourMinute = "EEE, HH:mm"
    case weekday = "EEE"
    case dayMonth = "dd MMM"
    case dayMonthYear = "dd MMM yyyy"
    case hourMinutePeriod = "h:mm a"
}
