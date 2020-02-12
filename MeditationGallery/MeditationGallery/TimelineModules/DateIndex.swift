//
//  DateIndex.swift
//  MeditationGallery
//
//  Created by JSKeum on 2020/01/07.
//  Copyright © 2020 JSKeum. All rights reserved.
//

// API from Swift Standard Library

import Foundation

struct DateIndex: Comparable {

    let date: Date
    
    init(_ date: Date) {
        self.date = calendar.startOfDay(for: date)
    }
    
    var debugDecription: String {
        return dateFormatter.string(from: date)
    }
    
    static func == (lhs: DateIndex, rhs: DateIndex) -> Bool {
        return lhs.date == rhs.date
    }
    
    static func < (lhs: DateIndex, rhs: DateIndex) -> Bool {
        return lhs.date.compare(rhs.date) == .orderedAscending
    }
}

let today = Date()

let tomorrow = calendar.date(byAdding: DateComponents(day: 1), to: today)!

let dayAfterTomorrow = calendar.date(byAdding: DateComponents(day: 2), to: today)!

let yesterday = calendar.date(byAdding: DateComponents(day: -1), to : today)!

let calendar = Calendar.current

let dateFormatter: DateFormatter = {
    let f = DateFormatter()
    f.dateFormat = "MMMM d"
    return f
}()
