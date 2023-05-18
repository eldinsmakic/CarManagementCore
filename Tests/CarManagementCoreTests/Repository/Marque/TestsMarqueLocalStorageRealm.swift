//
//  TestsMarqueLocalStorageRealm.swift
//  
//
//  Created by eldin smakic on 18/05/2023.
//

import XCTest
import CarManagementCore

final class TestsMarqueLocalStorageRealm: XCTestCase {
    var localStorage: BrandStorageProtocol!

    func createLocalStorage() async -> BrandStorageProtocol { try! await MarqueLocalStorageRealm() }

    func createValue() -> BrandDTO { FakeData.Marque.firstValue }
    func createSecondValue() -> BrandDTO { FakeData.Marque.secondValue }

    public override func setUp() async throws {
        try await super.setUp()
        localStorage = await createLocalStorage()
        _ = try await self.localStorage.erase()
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

        _ = try await localStorage.add(value)
        let values = try await localStorage.fetch()

        XCTAssertEqual(values.count, 1)
    }

    func test_add_two_expect_two() async throws {
        let value = createValue()
        let secondValue = createSecondValue()
        let _ = try await localStorage.add(value)
        _ = try await localStorage.add(secondValue)

        let values = try await localStorage.fetch()

        XCTAssertEqual(values.count, 2)
    }

    func test_add_When_add_three_with_same_value_expect_One() async throws {
        let value = createValue()

        _ = try await localStorage.add(value)
        _ = try await localStorage.add(value)
        _ = try await localStorage.add(value)

        let values = try await localStorage.fetch()

        XCTAssertEqual(values.count, 1)
    }

    func test_add_three_expect_three() async throws {
        let value = createValue()
        let secondValue = createSecondValue()
        let thirdValue = FakeData.Marque.create()

        _ = try await localStorage.add(value)
        _ = try await localStorage.add(secondValue)
        _ = try await localStorage.add(thirdValue)

        let values = try await localStorage.fetch()

        XCTAssertEqual(values.count, 3)
    }

    // MARK: - Remove

    func test_add_one_remove_one_expect_zero() async throws {
        let value = try await localStorage.add(createValue())

        var values = try await localStorage.fetch()

        XCTAssertEqual(values.count, 1)

        _ = try await localStorage.remove(value)

        values = try await localStorage.fetch()

        XCTAssertEqual(values.count, 0)
    }

    func test_remove_when_add_two_remove_one_expect_one() async throws {
        let value = try await localStorage.add(createValue())
        let secondValue =  try await localStorage.add(createSecondValue())
        _ = try await localStorage.remove(value)

        let values = try await localStorage.fetch()

        XCTAssertEqual(values, [secondValue])
    }

    // MARK: - RemoveById

    func test_add_one_removeById_one_expect_zero() async throws {
        let value = try await localStorage.add(createValue())

        var values = try await localStorage.fetch()

        XCTAssertEqual(values.count, 1)

        _ = try await localStorage.remove(byID: value.id)

        values = try await localStorage.fetch()

        XCTAssertEqual(values.count, 0)
    }

    func test_remove_when_add_two_removeById_one_expect_one() async throws {
        let value = try await localStorage.add(createValue())
        let secondValue =  try await localStorage.add(createSecondValue())
        _ = try await localStorage.remove(byID: value.id)

        let values = try await localStorage.fetch()

        XCTAssertEqual(values, [secondValue])
    }

    // MARK: - Erase

    func test_erase_when_add_two_erase_expect_zero() async throws {
        let value = createValue()

        _ = try await localStorage.add(value)
        _ = try await localStorage.add(value)

        _ = try await localStorage.erase()

        let values = try await localStorage.fetch()

        XCTAssertEqual(values.count, 0)
    }

    // MARK: - Fetch

    func test_fetch_When_no_data_expect_zero() async throws {
        let result = try await localStorage.fetch()

        XCTAssertEqual(result.count, 0)
    }


    // MARK: - Create

    func test_create_When_create_expect_one() async throws {
        let _ = try await localStorage.create()

        let result = try await localStorage.fetch()

        XCTAssertEqual(result.count, 1)
    }

    func test_create_When_create_Then_update_expecte_updated() async throws {
        let firstValue = createValue()
        var value = try await localStorage.create()
        XCTAssertNotEqual(value.name, firstValue.name)
        XCTAssertNotEqual(value.model, firstValue.model)
        XCTAssertNotEqual(value.motorisation, firstValue.motorisation)

        value.model = firstValue.model
        value.motorisation = firstValue.motorisation
        value.name = firstValue.name
        
        let result = try await localStorage.update(value)

        let fetch = try await localStorage.fetch()

        XCTAssertEqual(fetch.count, 1)
        XCTAssertEqual(result.name, firstValue.name)
        XCTAssertEqual(result.model, firstValue.model)
        XCTAssertEqual(result.motorisation, firstValue.motorisation)
    }
}
