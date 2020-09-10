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
    
    init(currentDateProvider: @escaping CurrentDateProvider) {
        self.currentDateProvider = currentDateProvider
    }
    
    func greet(name: String) -> String {
        let capitalizedName = name.capitalized
        let trimmedInputName = capitalizedName.trimmingCharacters(in: .whitespacesAndNewlines)
        return "\(greetingMessagePrefix()) \(trimmedInputName)"
    }
    
    private func greetingMessagePrefix() -> String {
        "Good Morning"
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
    
    func test_greet_outputMorningGreetingMessage() {
        let sut = makeSUT(currentDateProvider: { Date.anyMorning() })
        
        let receivedGreetingMessage = sut.greet(name: "José")
        
        XCTAssertEqual(receivedGreetingMessage, "Good Morning José")
    }
    
    // MARK: - Helpers
    
    private func makeSUT(currentDateProvider: @escaping Greeter.CurrentDateProvider = Date.anyMorning) -> Greeter {
        Greeter(currentDateProvider: currentDateProvider)
    }
    
}

fileprivate extension Date {
    
    static func anyMorning() -> Date {
        Date(timeIntervalSince1970: 1599728400) // 09/10/2020 @ 9:00am (UTC)
    }
    
}
