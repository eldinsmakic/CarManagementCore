//
//  TestsDefaultStorageProtocol.swift
//  
//
//  Created by eldin smakic on 20/05/2023.
//

import XCTest
import CarManagementCore

class TestsDefaultStorageProtocol<L: DefaultStorageProtocol>: XCTestCase {
    var localStorage: L!
    
    func createLocalStorage() async throws -> L { fatalError("need to implement local Storage") }
    
    func createValue() -> L.ValueDTO { fatalError("need to implement local Storage value ") }
    func createSecondValue() -> L.ValueDTO { fatalError("need to implement local Storage value ") }
    func createThirdValue() -> L.ValueDTO { fatalError("need to implement local Storage value ") }

    public override func setUp() async throws {
        try await super.setUp()
        localStorage = try await createLocalStorage()
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
        let thirdValue = createThirdValue()
        
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

    func test_fetch_When_add_3_data_expect_3() async throws {
        _ = try await localStorage.add(createValue())
        _ = try await localStorage.add(createSecondValue())
        _ = try await localStorage.add(createThirdValue())

        let result = try await localStorage.fetch()
        
        XCTAssertEqual(result.count, 3)
    }

    // MARK: - GetById
    
    func test_GetById_When_No_Id_in_DB_expect_throw() async throws {
        let value = createValue()
    
        let result = try? await localStorage.get(byId: value.id)

        XCTAssertEqual(result, nil)
    }

    func test_GetById_When_Id_in_DB_expect_find_value() async throws {
        let value = createValue()
        
        _ = try await localStorage.add(value)
    
        let result = try? await localStorage.get(byId: value.id)

        XCTAssertEqual(result, value)
    }
}
