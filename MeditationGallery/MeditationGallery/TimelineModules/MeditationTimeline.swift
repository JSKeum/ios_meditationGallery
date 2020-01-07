//
//  MeditationTimeline.swift
//  MeditationGallery
//
//  Created by JSKeum on 2020/01/07.
//  Copyright © 2020 JSKeum. All rights reserved.
//

// API from Swift Standard Library

import Foundation

struct Timeline<Element>: RandomAccessCollection {
    
    var storage : [Date:Element] = [:]
    
    var startIndex = DateIndex(Date.distantPast)
    var endIndex = DateIndex(Date.distantPast)
    
    subscript(i: DateIndex) -> Element? {
        get {
            return storage[i.date]
        }
        set {
            if isEmpty {
                startIndex = i
                endIndex = index(after: i)
            }
            else if i < startIndex {
                startIndex = i
            } else if i >= endIndex {
                endIndex = index(after: i)
            }
            storage[i.date] = newValue
        }
    }
    
    subscript(date: Date) -> Element? {
        get {
            return self[DateIndex(date)]
        }
        set {
            self[DateIndex(date)] = newValue
        }
    }
    
    func index(before i: DateIndex) -> DateIndex {
        let previousDay = calendar.date(byAdding: DateComponents(day: -1), to: i.date)!
        return DateIndex(previousDay)
    }
    
    func index(after i: DateIndex) -> DateIndex {
        let nextDay = calendar.date(byAdding: DateComponents(day: 1), to: i.date)!
        return DateIndex(nextDay)
    }
    
    func index(_ i: DateIndex, offsetBy n: Int) -> DateIndex {
        let offsetDate = calendar.date(byAdding: DateComponents(day: n), to: i.date)!
        return DateIndex(offsetDate)
    }
    func distance(from start: DateIndex, to end: DateIndex) -> Int {
      return calendar.dateComponents([.day], from: start.date, to: end.date).day!
    }
}

