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
    private let timeZone: TimeZone
    
    init(currentDateProvider: @escaping CurrentDateProvider, timezone: TimeZone) {
        self.currentDateProvider = currentDateProvider
        self.timeZone = timezone
    }
    
    func greet(name: String) -> String {
        let capitalizedName = name.capitalized
        let trimmedInputName = capitalizedName.trimmingCharacters(in: .whitespacesAndNewlines)
        return "\(greetingMessagePrefix()) \(trimmedInputName)"
    }
    
    private func greetingMessagePrefix() -> String {
        let currentDate = currentDateProvider()
        var calendar = Calendar.init(identifier: .gregorian)
        calendar.timeZone = timeZone
        let hour = calendar.component(.hour, from: currentDate)
        switch hour {
        case 6..<12:
            return "Good Morning"
        case 12..<18:
            return "Good Afternoon"
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
        let morningInterval = 12..<18
        morningInterval.forEach({ hour in
            let fixedAfternoonDate = Date().bySettingHour(hour, timeZone: UTCTimeZone())
            let sut = makeSUT(currentDateProvider: { fixedAfternoonDate })

            let receivedGreetingMessage = sut.greet(name: "José")

            XCTAssertEqual(receivedGreetingMessage, "Good Afternoon José")
        })
    }
    
    // MARK: - Helpers
    
    private func makeSUT(currentDateProvider: @escaping Greeter.CurrentDateProvider = Date.anyMorning) -> Greeter {
        return Greeter(currentDateProvider: currentDateProvider, timezone: UTCTimeZone())
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
