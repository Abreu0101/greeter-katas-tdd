//
//  GreeterTests.swift
//  Greeter-Katas-TDDTests
//
//  Created by Roberto Abreu on 9/10/20.
//  Copyright © 2020 Roberto Abreu. All rights reserved.
//

import XCTest

struct Greeter {
    typealias CurrentDateProvider = () -> Date
    private let currentDateProvider: CurrentDateProvider
    private let calendar: Calendar
    
    init(currentDateProvider: @escaping CurrentDateProvider, timeZone: TimeZone) {
        self.currentDateProvider = currentDateProvider
        
        var calendar = Calendar.init(identifier: .gregorian)
        calendar.timeZone = timeZone
        self.calendar = calendar
    }
    
    func greet(name: String) -> String {
        let capitalizedName = name.capitalized
        let trimmedInputName = capitalizedName.trimmingCharacters(in: .whitespacesAndNewlines)
        return "\(greetingMessagePrefix()) \(trimmedInputName)"
    }
    
    private func greetingMessagePrefix() -> String {
        let currentDate = currentDateProvider()
        let hour = calendar.component(.hour, from: currentDate)
        switch hour {
        case 6..<12:
            return "Good Morning"
        case 12..<18:
            return "Good Afternoon"
        case 18..<22:
            return "Good Evening"
        case 0..<6, 22..<24:
            return "Good Night"
        default:
            preconditionFailure("Hours should be between 00:00:00 - 24:00:00, got \(hour) instead")
        }
    }
}

class GreeterTests: XCTestCase {
    
    func test_greet_outputGreetingMessageTrimmingInputName() {
        let receivedGreetingMessage = makeSUT().greet(name: " José ")
        XCTAssertEqual(receivedGreetingMessage, "Good Morning José")
    }
    
    func test_greet_outputGreetingMessageWithCapitalizeFirstLetter() {
        let receivedGreetingMessage = makeSUT().greet(name: "josé")
        XCTAssertEqual(receivedGreetingMessage, "Good Morning José")
    }
    
    func test_greet_outputMorningGreetingMessageDuringMorningInterval() {
        let morningInterval = 6..<12
        morningInterval.forEach({ hour in
            let fixedMorningDate = Date().bySettingHour(hour, timeZone: UTCTimeZone())
            let sut = makeSUT(currentDateProvider: { fixedMorningDate })
            
            let receivedGreetingMessage = sut.greet(name: "José")
            
            XCTAssertEqual(receivedGreetingMessage, "Good Morning José", "Failed for morning time \(hour)")
        })
    }
    
    func test_greet_outputAfternoonGreetingMessageDuringAfternoonInterval() {
        let afternoonInterval = 12..<18
        afternoonInterval.forEach({ hour in
            let fixedAfternoonDate = Date().bySettingHour(hour, timeZone: UTCTimeZone())
            let sut = makeSUT(currentDateProvider: { fixedAfternoonDate })

            let receivedGreetingMessage = sut.greet(name: "José")

            XCTAssertEqual(receivedGreetingMessage, "Good Afternoon José")
        })
    }
    
    func test_greet_outputEveningGreetingMessageDuringEveningInterval() {
        let eveningInterval = 18..<22
        eveningInterval.forEach({ hour in
            let fixedEveningDate = Date().bySettingHour(hour, timeZone: UTCTimeZone())
            let sut = makeSUT(currentDateProvider: { fixedEveningDate })

            let receivedGreetingMessage = sut.greet(name: "José")

            XCTAssertEqual(receivedGreetingMessage, "Good Evening José")
        })
    }
    
    func test_greet_outputNightGreetingMessageDuringNightInterval() {
        let eveningInterval = [(0..<6), (22..<24)].flatMap({ $0 })
        eveningInterval.forEach({ hour in
            let fixedNightDate = Date().bySettingHour(hour, timeZone: UTCTimeZone())
            let sut = makeSUT(currentDateProvider: { fixedNightDate })

            let receivedGreetingMessage = sut.greet(name: "José")

            XCTAssertEqual(receivedGreetingMessage, "Good Night José")
        })
    }
    
    // MARK: - Helpers
    
    private func makeSUT(currentDateProvider: @escaping Greeter.CurrentDateProvider = Date.anyMorning) -> Greeter {
        return Greeter(currentDateProvider: currentDateProvider, timeZone: UTCTimeZone())
    }
    
    private func UTCTimeZone() -> TimeZone {
        TimeZone(identifier: "UTC")!
    }
    
}

fileprivate extension Date {
    
    static func anyMorning() -> Date {
        Date(timeIntervalSince1970: 1599728400) // 09/10/2020 @ 9:00am (UTC)
    }
    
    func bySettingHour(_ hour: Int, timeZone: TimeZone) -> Date {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = timeZone
        return calendar.date(bySettingHour: hour, minute: 0, second: 0, of: self)!
    }
    
}
