//
//  Greeter.swift
//  Greeter-Katas-TDD
//
//  Created by Roberto Abreu on 9/10/20.
//  Copyright © 2020 Roberto Abreu. All rights reserved.
//

import Foundation

public struct Greeter {
    public typealias CurrentDateProvider = () -> Date
    public typealias Logger = (String) -> Void
    
    private let currentDateProvider: CurrentDateProvider
    private let calendar: Calendar
    public var logger: Logger?
    
    public init(currentDateProvider: @escaping CurrentDateProvider, timeZone: TimeZone) {
        self.currentDateProvider = currentDateProvider
        
        var calendar = Calendar.init(identifier: .gregorian)
        calendar.timeZone = timeZone
        self.calendar = calendar
    }
    
    public func greet(name: String) -> String {
        let capitalizedName = name.capitalized
        let trimmedInputName = capitalizedName.trimmingCharacters(in: .whitespacesAndNewlines)
        let greetingMessage = "\(greetingMessagePrefix()) \(trimmedInputName)"
        logger?(greetingMessage)
        return greetingMessage
    }
    
    private func greetingMessagePrefix() -> String {
        let hour = hourFromCurrentDate()
        switch hour {
        case 6..<12: return "Good Morning"
        case 12..<18: return "Good Afternoon"
        case 18..<22: return "Good Evening"
        case 0..<6, 22..<24: return "Good Night"
        default: preconditionFailure("Hours should be between 00:00:00 - 24:00:00(exclusive), " +
                                     "got \(hour) instead")
        }
    }
    
    private func hourFromCurrentDate() -> Int {
        let currentDate = currentDateProvider()
        let hour = calendar.component(.hour, from: currentDate)
        return hour
    }
    
}
