//
//  GreeterTests.swift
//  Greeter-Katas-TDDTests
//
//  Created by Roberto Abreu on 9/10/20.
//  Copyright © 2020 Roberto Abreu. All rights reserved.
//

import XCTest
import Greeter_Katas_TDD

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
        expect("Good Morning José", withName: "José", duringHourInterval: morningInterval)
    }
    
    func test_greet_outputAfternoonGreetingMessageDuringAfternoonInterval() {
        let afternoonInterval = 12..<18
        expect("Good Afternoon José", withName: "José", duringHourInterval: afternoonInterval)
    }
    
    func test_greet_outputEveningGreetingMessageDuringEveningInterval() {
        let eveningInterval = 18..<22
        expect("Good Evening José", withName: "José", duringHourInterval: eveningInterval)
    }
    
    func test_greet_outputNightGreetingMessageDuringNightInterval() {
        let nightInterval = [(0..<6), (22..<24)].flatMap({ $0 })
        expect("Good Night José", withName: "José", duringHourInterval: nightInterval)
    }
    
    func test_greet_logsGreetingMessage() {
        var sut = makeSUT()
        
        let exp = expectation(description: "Wait for logger call")
        var receivedLogMessage: String?
        sut.logger = { logMessage in
            receivedLogMessage = logMessage
            exp.fulfill()
        }
        
        _ = sut.greet(name: "Robert")
        wait(for: [exp], timeout: 1.0)
        
        XCTAssertEqual(receivedLogMessage, "Good Morning Robert")
    }
    
    // MARK: - Helpers
    
    private func makeSUT(currentDateProvider: @escaping Greeter.CurrentDateProvider = Date.anyMorning) -> Greeter {
        return Greeter(currentDateProvider: currentDateProvider, timeZone: UTCTimeZone())
    }
    
    private func UTCTimeZone() -> TimeZone {
        TimeZone(identifier: "UTC")!
    }
    
    private func expect<T>(_ expectedValue: String, withName name: String, duringHourInterval hourInterval: T, file: StaticString = #file, line: UInt = #line) where T: RandomAccessCollection, T.Element == Int {
        hourInterval.forEach({ hour in
            let fixedDate = Date().bySettingHour(hour, timeZone: UTCTimeZone())
            let sut = makeSUT(currentDateProvider: { fixedDate })

            let receivedGreetingMessage = sut.greet(name: name)

            XCTAssertEqual(receivedGreetingMessage, expectedValue, file: file, line: line)
        })
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
