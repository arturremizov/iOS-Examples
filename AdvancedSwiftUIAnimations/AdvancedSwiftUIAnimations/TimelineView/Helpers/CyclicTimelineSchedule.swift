//
//  CyclicTimelineSchedule.swift
//  AdvancedSwiftUIAnimations
//
//  Created by Artur Remizov on 23.06.25.
//
import SwiftUI

struct CyclicTimelineSchedule: TimelineSchedule {
    
    struct Entries: Sequence, IteratorProtocol {
        
        private(set) var last: Date
        let offsets: [TimeInterval]
        private(set) var index: Int = -1
        
        mutating func next() -> Date? {
            index = (index + 1) % offsets.count
            last = last.addingTimeInterval(offsets[index])
            return last
        }
    }
    
    let timeOffsets: [TimeInterval]
    
    func entries(from startDate: Date, mode: TimelineScheduleMode) -> Entries {
        Entries(last: startDate, offsets: timeOffsets)
    }
}

extension TimelineSchedule where Self == CyclicTimelineSchedule {
    static func cyclic(timeOffsets: [TimeInterval]) -> CyclicTimelineSchedule {
        return .init(timeOffsets: timeOffsets)
    }
}
