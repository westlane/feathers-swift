//
//  FeathersSpec.swift
//  Feathers
//
//  Created by Brendan Conron on 5/20/17.
//  Copyright © 2017 FeathersJS. All rights reserved.
//

import XCTest
import ReactiveSwift
import Feathers

class FeathersSpec: XCTestCase {
    
    var app: Feathers!
    
    override func setUp() {
        super.setUp()
        app = Feathers(provider: StubProvider(data: ["name": "Bob"]))
    }
    
    override func tearDown() {
        app = nil
        super.tearDown()
    }
    
    func testShouldAuthenticateSuccessfully() {
        let expectation = XCTestExpectation(description: "Authentication should complete")
        
        var didDispose = false
        var didReceiveValue = false
        var didComplete = false
        var didInterrupt = false
        
        app.authenticate([:]).on(completed: {
            didComplete = true
            expectation.fulfill()
        }, interrupted: {
            didInterrupt = true
        }, disposed: {
            didDispose = true
        }, value: { value in
            didReceiveValue = true
        })
        .start()
        
        wait(for: [expectation], timeout: 5.0)
        
        XCTAssertTrue(didDispose, "Should have disposed")
        XCTAssertFalse(didInterrupt, "Should not have been interrupted")
        XCTAssertTrue(didReceiveValue, "Should have received value")
        XCTAssertTrue(didComplete, "Should have completed")
    }
    
    func testShouldLogoutSuccessfully() {
        let expectation = XCTestExpectation(description: "Logout should complete")
        
        var didDispose = false
        var didReceiveValue = false
        var didComplete = false
        var didInterrupt = false
        
        app.logout().on(completed: {
            didComplete = true
            expectation.fulfill()
        }, interrupted: {
            didInterrupt = true
        }, disposed: {
            didDispose = true
        }, value: { value in
            didReceiveValue = true
        })
        .start()
        
        wait(for: [expectation], timeout: 5.0)
        
        XCTAssertTrue(didDispose, "Should have disposed")
        XCTAssertFalse(didInterrupt, "Should not have been interrupted")
        XCTAssertTrue(didReceiveValue, "Should have received value")
        XCTAssertTrue(didComplete, "Should have completed")
    }
}