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
        return "Hello \(name)"
    }
    
}

class GreeterTests: XCTestCase {

    func test_greet_outputGreetingMessageWithName() {
        let sut = Greeter()

        let receivedGreetingMessage = sut.greet(name: "José")
        
        XCTAssertEqual(receivedGreetingMessage, "Hello José")
    }

}
