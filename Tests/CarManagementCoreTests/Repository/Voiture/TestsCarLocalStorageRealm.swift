//
//  TestsCarLocalStorageRealm.swift
//
//
//  Created by eldin smakic on 14/05/2023.
//

import XCTest
import CarManagementCore

final class TestsCarLocalStorageRealm: XCTestCase {
    var localStorage: CarStorageProtocol!
    
    func createLocalStorage() async -> CarStorageProtocol { try! await CarLocalStorageRealm() }
    
    func createValue() -> CarDTO { FakeData.Voiture.fistValue }
    func createSecondValue() -> CarDTO { FakeData.Voiture.secondValue }
    
    public override func setUp() async throws {
        try await super.setUp()
        localStorage = await createLocalStorage()
        _ = try await self.localStorage.erase()
    }
    
    // MARK: - Get
    func test_get_expect_zero() async throws {
        let values = try await localStorage.fetch().get()
        // Asserting that our Combine pipeline yielded the
        // correct output:
        XCTAssertEqual(values.count, 0)
    }
    
    // MARK: - ADD
    func test_add_two_expect_two_same_value() async throws {
        var input = createValue()
        var secondInput = createSecondValue()
        
        input = try await localStorage.add(input).get()
        secondInput = try await localStorage.add(secondInput).get()
        
        let values = try await localStorage.fetch().get()
        
        XCTAssertEqual(values.count, 2)
        XCTAssertEqual(values, [input, secondInput])
    }
    
    func test_add_one_expect_one() async throws {
        let value = createValue()
        
        _ = try await localStorage.add(value).get()
        let values = try await localStorage.fetch().get()
        
        XCTAssertEqual(values.count, 1)
    }
    
    func test_add_two_expect_two() async throws {
        let value = createValue()
        let secondValue = createSecondValue()
        let _ = try await localStorage.add(value).get()
        _ = try await localStorage.add(secondValue).get()
        
        let values = try await localStorage.fetch().get()
        
        XCTAssertEqual(values.count, 2)
    }
    
    func test_add_When_add_three_with_same_value_expect_One() async throws {
        let value = createValue()
        
        _ = try await localStorage.add(value).get()
        _ = try await localStorage.add(value).get()
        _ = try await localStorage.add(value).get()
        
        let values = try await localStorage.fetch().get()
        
        XCTAssertEqual(values.count, 1)
    }
    
    func test_add_three_expect_three() async throws {
        let value = createValue()
        let secondValue = createSecondValue()
        let thirdValue = FakeData.Voiture.secondValue
        
        _ = try await localStorage.add(value).get()
        _ = try await localStorage.add(secondValue).get()
        _ = try await localStorage.add(thirdValue).get()
        
        let values = try await localStorage.fetch().get()
        
        XCTAssertEqual(values.count, 3)
    }
    
    // MARK: - Remove
    
    func test_add_one_remove_one_expect_zero() async throws {
        let value = try await localStorage.add(createValue()).get()
        
        var values = try await localStorage.fetch().get()
        
        XCTAssertEqual(values.count, 1)
        
        _ = try await localStorage.remove(value).get()
        
        values = try await localStorage.fetch().get()
        
        XCTAssertEqual(values.count, 0)
    }
    
    func test_remove_when_add_two_remove_one_expect_one() async throws {
        let value = try await localStorage.add(createValue()).get()
        let secondValue =  try await localStorage.add(createSecondValue()).get()
        _ = try await localStorage.remove(value).get()
        
        let values = try await localStorage.fetch().get()
        
        XCTAssertEqual(values, [secondValue])
    }
    
    // MARK: - RemoveById
    
    func test_add_one_removeById_one_expect_zero() async throws {
        let value = try await localStorage.add(createValue()).get()
        
        var values = try await localStorage.fetch().get()
        
        XCTAssertEqual(values.count, 1)
        
        _ = try await localStorage.remove(byID: value.id).get()
        
        values = try await localStorage.fetch().get()
        
        XCTAssertEqual(values.count, 0)
    }
    
    func test_remove_when_add_two_removeById_one_expect_one() async throws {
        let value = try await localStorage.add(createValue()).get()
        let secondValue =  try await localStorage.add(createSecondValue()).get()
        _ = try await localStorage.remove(byID: value.id).get()
        
        let values = try await localStorage.fetch().get()
        
        XCTAssertEqual(values, [secondValue])
    }
    
    // MARK: - Erase
    
    func test_erase_when_add_two_erase_expect_zero() async throws {
        let value = createValue()
        
        _ = try await localStorage.add(value).get()
        _ = try await localStorage.add(value).get()
        
        _ = try await localStorage.erase().get()
        
        let values = try await localStorage.fetch().get()
        
        XCTAssertEqual(values.count, 0)
    }
    
    // MARK: - Fetch
    
    func test_fetch_When_no_data_expect_zero() async throws {
        let result = try await localStorage.fetch().get()
        
        XCTAssertEqual(result.count, 0)
    }
}
