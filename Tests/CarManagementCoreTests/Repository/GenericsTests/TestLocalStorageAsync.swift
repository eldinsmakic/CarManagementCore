//
//  TestLocalStorageAsync.swift
//  
//
//  Created by eldin smakic on 10/10/2022.
//

import XCTest

import XCTest
import Combine
@testable import CarManagementCore

public class TestLocalStorageAsync<L: LocalStorageProtocolAsync>: XCTestCase {
    var localStorage: L!

    func createLocalStorage() -> L { fatalError() }
    func createValue() -> L.Value { fatalError() }
    func createSecondValue() -> L.Value { fatalError() }

    public override func setUp() {
        super.setUp()
        localStorage = createLocalStorage()
        self.localStorage.erase()
    }

    func test_listPub_get_expect_zero() async throws {

        let values = try await localStorage.fetch()
        // Asserting that our Combine pipeline yielded the
        // correct output:
        XCTAssertEqual(values.count, 0)
    }

    func test_listPub_get_expect_two() async throws {
        let value = createValue()
        let secondValue = createSecondValue()

        try await localStorage.add(value)
        try await localStorage.add(secondValue)

        let values = try await localStorage.fetch()

        XCTAssertEqual(values.count, 2)
        XCTAssertEqual(values, [value, secondValue])
    }

    func test_listPub_expect_one() async throws {
        let value = createValue()

        try await localStorage.add(value)
        let values = try await localStorage.fetch()

        XCTAssertEqual(values.count, 1)
    }

    func test_listPub_expect_two() async throws {
        let value = createValue()

        try await localStorage.add(value)
        try await localStorage.add(value)
        
        let values = try await localStorage.fetch()

        XCTAssertEqual(values.count, 2)
    }

    func test_listPub_expect_three() async throws {
        let value = createValue()

        try await localStorage.add(value)
        try await localStorage.add(value)
        try await localStorage.add(value)
        
        let values = try await localStorage.fetch()

        XCTAssertEqual(values.count, 3)
    }

    
    func test_listPub_remove_expect_zero() async throws {
        let value = createValue()

        try await localStorage.add(value)

        try await localStorage.remove(value)
        
        let values = try await localStorage.fetch()

        XCTAssertEqual(values.count, 0)
    }

    func test_listPub_remove_when_add_two_expect_one() async throws {
        let value = createValue()
        let secondValue = createSecondValue()

        try await localStorage.add(value)
        try await localStorage.add(secondValue)
        try await localStorage.remove(value)

        let values = try await localStorage.fetch()

        XCTAssertEqual(values, [secondValue])
    }

    func test_listPub_erase_expect_zero() async throws {
        let value = createValue()

        try await localStorage.add(value)
        try await localStorage.add(value)

        try await localStorage.erase()

        let values = try await localStorage.fetch()

        XCTAssertEqual(values.count, 0)
    }
    
    func test_update_expect_different_value() async throws {
        var value = createValue()

        try await localStorage.add(value)
    
        let values = try await localStorage.fetch()

        XCTAssertEqual(values.count, 0)
    }

//    func test_remove_atOffset() async throws {
//        let value = createValue()
//        let secondValue = createSecondValue()
//
//        try await localStorage.add(value)
//
//        try await localStorage.add(secondValue)
//
//        try await localStorage.delete(at: 0)
//
//        let values = try await localStorage.fetch()
//
//        XCTAssertEqual(values, [secondValue])
//    }
}

