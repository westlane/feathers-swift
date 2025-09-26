//
//  QuerySpec.swift
//  Feathers
//
//  Created by Brendan Conron on 5/25/17.
//  Copyright © 2017 Swoopy Studios. All rights reserved.
//

import XCTest
import Foundation
import Feathers

class QuerySpec: XCTestCase {

    // MARK: - Query Tests

    func testShouldSerializeLimitQuery() {
        let query = Query().limit(5)
        let serialized = query.serialize()
        XCTAssertTrue(NSDictionary(dictionary: serialized).isEqual(to: ["$limit": 5]))
    }

    func testShouldSerializeSkipQuery() {
        let query = Query().skip(5)
        let serialized = query.serialize()
        XCTAssertTrue(NSDictionary(dictionary: serialized).isEqual(to: ["$skip": 5]))
    }

    func testShouldSerializeSingleSort() {
        let query = Query().sort(property: "name", ordering: .orderedAscending)
        let serialized = query.serialize()
        XCTAssertTrue(NSDictionary(dictionary: serialized).isEqual(to: [
            "$sort": [
                "name": 1
            ]
        ]))
    }

    func testShouldSerializeMultipleSorts() {
        let query = Query().sort(property: "name", ordering: .orderedAscending).sort(property: "age", ordering: .orderedDescending)
        let serialized = query.serialize()
        XCTAssertTrue(NSDictionary(dictionary: serialized).isEqual(to: [
            "$sort": [
                "name": 1,
                "age": -1
            ]
        ]))
    }

    func testShouldSerializeGtQuery() {
        let query = Query().gt(property: "age", value: 5)
        let serialized = query.serialize()
        XCTAssertTrue(NSDictionary(dictionary: serialized).isEqual(to: ["age": ["$gt": 5]]))
    }

    func testShouldSerializeGteQuery() {
        let query = Query().gte(property: "age", value: 5)
        let serialized = query.serialize()
        XCTAssertTrue(NSDictionary(dictionary: serialized).isEqual(to: ["age": ["$gte": 5]]))
    }

    func testShouldSerializeLtQuery() {
        let query = Query().lt(property: "age", value: 5)
        let serialized = query.serialize()
        XCTAssertTrue(NSDictionary(dictionary: serialized).isEqual(to: ["age": ["$lt": 5]]))
    }

    func testShouldSerializeLteQuery() {
        let query = Query().lte(property: "age", value: 5)
        let serialized = query.serialize()
        XCTAssertTrue(NSDictionary(dictionary: serialized).isEqual(to: ["age": ["$lte": 5]]))
    }

    func testShouldSerializeInQuery() {
        let query = Query().in(property: "age", values: [5, 10, 15])
        let serialized = query.serialize()
        XCTAssertTrue(NSDictionary(dictionary: serialized).isEqual(to: ["age": ["$in": [5, 10, 15]]]))
    }

    func testShouldSerializeNinQuery() {
        let query = Query().nin(property: "age", values: [5, 10, 15])
        let serialized = query.serialize()
        XCTAssertTrue(NSDictionary(dictionary: serialized).isEqual(to: ["age": ["$nin": [5, 10, 15]]]))
    }

    func testShouldSerializeNeQuery() {
        let query = Query().ne(property: "age", value: 10)
        let serialized = query.serialize()
        XCTAssertTrue(NSDictionary(dictionary: serialized).isEqual(to: ["age": ["$ne": 10]]))
    }

    func testShouldSerializeEqQuery() {
        let query = Query().eq(property: "age", value: 10)
        let serialized = query.serialize()
        XCTAssertTrue(NSDictionary(dictionary: serialized).isEqual(to: ["age": 10]))
    }

    func testShouldSerializeSelectQuery() {
        let query = Query().select(property: "name")
        let serialized = query.serialize()
        XCTAssertTrue(NSDictionary(dictionary: serialized).isEqual(to: ["$select": ["name"]]))
    }

    func testShouldSerializeSelectQueryWithMultipleFields() {
        let query = Query().select(properties: ["name", "age"])
        let serialized = query.serialize()
        XCTAssertTrue(NSDictionary(dictionary: serialized).isEqual(to: ["$select": ["name", "age"]]))
    }

    func testShouldSerializeOrQuery() {
        let query = Query().or(subqueries: [
            "name":.ne("bob"),
            "age":.gt(18)
        ])
        let serialized = query.serialize()
        XCTAssertTrue(NSDictionary(dictionary: serialized).isEqual(to: ["$or": [["name": ["$ne": "bob"]], ["age": ["$gt": 18]]]]))
    }

    func testShouldSerializeMultipleQueries() {
        let query = Query().limit(5).gt(property: "name", value: "bob").lt(property: "age", value: 5)
        let serialized = query.serialize()
        XCTAssertTrue(NSDictionary(dictionary: serialized).isEqual(to: ["$limit": 5, "name": ["$gt": "bob"], "age": ["$lt": 5]]))
    }

    func testShouldSerializeMultipleSubqueriesOnSameProperty() {
        let query = Query().gt(property: "age", value: 18).lt(property: "age", value: 100)
        let serialized = query.serialize()
        XCTAssertTrue(NSDictionary(dictionary: serialized).isEqual(to: ["age": ["$gt": 18, "$lt": 100]]))
    }

}