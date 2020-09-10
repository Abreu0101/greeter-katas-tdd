//
//  GreeterTests.swift
//  Greeter-Katas-TDDTests
//
//  Created by Roberto Abreu on 9/10/20.
//  Copyright © 2020 Roberto Abreu. All rights reserved.
//

import XCTest

struct Greeter {
    
    func greet(name: String) -> String {
        return "Hello \(name.trimmingCharacters(in: .whitespacesAndNewlines))"
    }
    
}

class GreeterTests: XCTestCase {

    func test_greet_outputGreetingMessageWithName() {
        let receivedGreetingMessage = makeSUT().greet(name: "José")
        XCTAssertEqual(receivedGreetingMessage, "Hello José")
    }
    
    func test_greet_outputGreetingMessageTrimmingInputName() {
        let receivedGreetingMessage = makeSUT().greet(name: " José ")
        XCTAssertEqual(receivedGreetingMessage, "Hello José")
    }
    
    // MARK: - Helpers
    
    func makeSUT() -> Greeter {
        Greeter()
    }

}
