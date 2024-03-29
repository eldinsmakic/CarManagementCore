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

    public override func setUp() async throws {
        try await super.setUp()
        localStorage = createLocalStorage()
        try await self.localStorage.erase()
    }

    // MARK: - Get
    func test_get_expect_zero() async throws {

        let values = try await localStorage.fetch()
        // Asserting that our Combine pipeline yielded the
        // correct output:
        XCTAssertEqual(values.count, 0)
    }

    // MARK: - ADD
    func test_add_two_expect_two_same_value() async throws {
        var input = createValue()
        var secondInput = createSecondValue()

        input = try await localStorage.add(input)
        secondInput = try await localStorage.add(secondInput)

        let values = try await localStorage.fetch()

        XCTAssertEqual(values.count, 2)
        XCTAssertEqual(values, [input, secondInput])
    }

    func test_add_one_expect_one() async throws {
        let value = createValue()

        try await localStorage.add(value)
        let values = try await localStorage.fetch()

        XCTAssertEqual(values.count, 1)
    }

    func test_add_two_expect_two() async throws {
        let value = createValue()

        let _ = try await localStorage.add(value)
        try await localStorage.add(value)
        
        let values = try await localStorage.fetch()

        XCTAssertEqual(values.count, 2)
    }

    func test_add_three_expect_three() async throws {
        let value = createValue()

        _ = try await localStorage.add(value)
        _ = try await localStorage.add(value)
        _ = try await localStorage.add(value)
        
        let values = try await localStorage.fetch()

        XCTAssertEqual(values.count, 3)
    }

    // MARK: - Remove

    func test_add_one_remove_one_expect_zero() async throws {
        let value = try await localStorage.add(createValue())

        try await localStorage.remove(value)

        let values = try await localStorage.fetch()

        XCTAssertEqual(values.count, 0)
    }

    func test_remove_when_add_two_remove_one_expect_one() async throws {
        let value = try await localStorage.add(createValue())
        let secondValue =  try await localStorage.add(createSecondValue())
        try await localStorage.remove(value)

        let values = try await localStorage.fetch()

        XCTAssertEqual(values, [secondValue])
    }

    // MARK: - Erase

    func test_erase_when_add_two_erase_expect_zero() async throws {
        let value = createValue()

        try await localStorage.add(value)
        try await localStorage.add(value)

        try await localStorage.erase()

        let values = try await localStorage.fetch()

        XCTAssertEqual(values.count, 0)
    }

    // MARK: - GetById

//    func test_getById_when_get_correct_id_expect_value() async throws {
//        let value = try await localStorage.add(createValue())
//        let secondValue = try await localStorage.add(createSecondValue())
//
//        XCTAssertNotEqual(value.id, secondValue.id)
//
//        let expectedValue = try await localStorage.get(byId: value.id)
//
//        XCTAssertEqual(value, expectedValue)
//    }
//
//    func test_getById_when_get_noExistant_id_expect_throw() async throws {
//        let value = try await localStorage.add(createValue())
//        let secondValue = try await localStorage.add(createSecondValue())
//
//        XCTAssertNotEqual(value.id, secondValue.id)
//
//        guard let _ = try? await localStorage.get(byId: value.id) else {
//            XCTFail("No error throwns")
//            return
//        }
//    }
}

