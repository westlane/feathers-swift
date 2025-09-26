//
//  ServiceSpec.swift
//  Feathers
//
//  Created by Brendan Conron on 5/18/17.
//  Copyright © 2017 FeathersJS. All rights reserved.
//

import XCTest
import Feathers

class ServiceSpec: XCTestCase {

    // MARK: - Service Tests

    var app: Feathers!
    var service: ServiceType!

    override func setUp() {
        super.setUp()
        app = Feathers(provider: StubProvider(data: ["name": "Bob"]))
        service = app.service(path: "users")
    }

    override func tearDown() {
        app = nil
        service = nil
        super.tearDown()
    }

    func testShouldStubTheRequest() {
        print(service as Any)
        var error: Error?
        var response: Response?
        var data: [String: String]?
        
        let expectation = XCTestExpectation(description: "Request should complete")
        
        service.request(.find(query: nil))
            .on(failed: {
                error = $0
                expectation.fulfill()
            }, value: {
                response = $0
                data = $0.data.value as? [String: String]
                print($0)
                expectation.fulfill()
            })
            .start()
        
        wait(for: [expectation], timeout: 1.0)
        
        XCTAssertNil(error)
        XCTAssertNotNil(response)
        XCTAssertNotNil(data)
        XCTAssertEqual(data, ["name": "Bob"])
    }

    func testServicePath() {
        XCTAssertEqual(service.path, "users")
    }

    func testServiceSupportsRealtimeEvents() {
        XCTAssertFalse(service.supportsRealtimeEvents)
    }

    func testServiceSetup() {
        let newApp = Feathers(provider: StubProvider(data: [:]))
        let newService = newApp.service(path: "test")
        
        XCTAssertEqual(newService.path, "test")
    }

    func testServiceRequestMethods() {
        let expectation = XCTestExpectation(description: "Request should complete")
        
        service.request(.get(id: "123", query: nil))
            .on(failed: { _ in
                expectation.fulfill()
            }, value: { _ in
                expectation.fulfill()
            })
            .start()
        
        wait(for: [expectation], timeout: 1.0)
    }

    func testServiceCreateRequest() {
        let expectation = XCTestExpectation(description: "Create request should complete")
        
        service.request(.create(data: ["name": "Test"], query: nil))
            .on(failed: { _ in
                expectation.fulfill()
            }, value: { _ in
                expectation.fulfill()
            })
            .start()
        
        wait(for: [expectation], timeout: 1.0)
    }

    func testServiceUpdateRequest() {
        let expectation = XCTestExpectation(description: "Update request should complete")
        
        service.request(.update(id: "123", data: ["name": "Updated"], query: nil))
            .on(failed: { _ in
                expectation.fulfill()
            }, value: { _ in
                expectation.fulfill()
            })
            .start()
        
        wait(for: [expectation], timeout: 1.0)
    }

    func testServicePatchRequest() {
        let expectation = XCTestExpectation(description: "Patch request should complete")
        
        service.request(.patch(id: "123", data: ["name": "Patched"], query: nil))
            .on(failed: { _ in
                expectation.fulfill()
            }, value: { _ in
                expectation.fulfill()
            })
            .start()
        
        wait(for: [expectation], timeout: 1.0)
    }

    func testServiceRemoveRequest() {
        let expectation = XCTestExpectation(description: "Remove request should complete")
        
        service.request(.remove(id: "123", query: nil))
            .on(failed: { _ in
                expectation.fulfill()
            }, value: { _ in
                expectation.fulfill()
            })
            .start()
        
        wait(for: [expectation], timeout: 1.0)
    }

}