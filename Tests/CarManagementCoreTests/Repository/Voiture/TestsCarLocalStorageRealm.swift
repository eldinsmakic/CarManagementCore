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
        _ = await self.localStorage.erase()
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
        
        input = try await localStorage.create(
            brandName: input.brandName,
            brandModel: input.brandModel,
            motor: input.motor,
            mileage: input.mileage,
            fuelType: input.fuelType,
            year: input.year,
            purchaseDate: input.purchaseDate
        ).get()

        secondInput = try await localStorage.create(
            brandName: secondInput.brandName,
            brandModel: secondInput.brandModel,
            motor: secondInput.motor,
            mileage: secondInput.mileage,
            fuelType: secondInput.fuelType,
            year: secondInput.year,
            purchaseDate: secondInput.purchaseDate
        ).get()
        
        let values = try await localStorage.fetch().get()
        
        XCTAssertEqual(values.count, 2)
        XCTAssertEqual(values, [input, secondInput])
    }
    
    func test_add_one_expect_one() async throws {
        let value = createValue()
        
        _ = try await localStorage.create(
            brandName: value.brandName,
            brandModel: value.brandModel,
            motor: value.motor,
            mileage: value.mileage,
            fuelType: value.fuelType,
            year: value.year,
            purchaseDate: value.purchaseDate
        ).get()

        let values = try await localStorage.fetch().get()
        
        XCTAssertEqual(values.count, 1)
    }
    
    func test_add_two_expect_two() async throws {
        let value = createValue()
        let secondValue = createSecondValue()
        let _ = try await localStorage.create(
            brandName: value.brandName,
            brandModel: value.brandModel,
            motor: value.motor,
            mileage: value.mileage,
            fuelType: value.fuelType,
            year: value.year,
            purchaseDate: value.purchaseDate
        ).get()
        _ = try await localStorage.create(
            brandName: secondValue.brandName,
            brandModel: secondValue.brandModel,
            motor: secondValue.motor,
            mileage: secondValue.mileage,
            fuelType: secondValue.fuelType,
            year: secondValue.year,
            purchaseDate: secondValue.purchaseDate
        ).get()
        
        let values = try await localStorage.fetch().get()
        
        XCTAssertEqual(values.count, 2)
    }
    
    func test_add_three_expect_three() async throws {
        let value = createValue()
        let secondValue = createSecondValue()
        let thirdValue = FakeData.Voiture.secondValue
        
        _ = try await localStorage.create(
            brandName: value.brandName,
            brandModel: value.brandModel,
            motor: value.motor,
            mileage: value.mileage,
            fuelType: value.fuelType,
            year: value.year,
            purchaseDate: value.purchaseDate
        ).get()
        _ = try await localStorage.create(
            brandName: secondValue.brandName,
            brandModel: secondValue.brandModel,
            motor: secondValue.motor,
            mileage: secondValue.mileage,
            fuelType: secondValue.fuelType,
            year: secondValue.year,
            purchaseDate: secondValue.purchaseDate
        ).get()
        _ = try await localStorage.create(
            brandName: thirdValue.brandName,
            brandModel: thirdValue.brandModel,
            motor: thirdValue.motor,
            mileage: thirdValue.mileage,
            fuelType: thirdValue.fuelType,
            year: thirdValue.year,
            purchaseDate: thirdValue.purchaseDate
        ).get()
        
        let values = try await localStorage.fetch().get()
        
        XCTAssertEqual(values.count, 3)
    }
    
    // MARK: - Remove
    
    func test_add_one_remove_one_expect_zero() async throws {
        let value = createValue()
        let createdValue = try await localStorage.create(
            brandName: value.brandName,
            brandModel: value.brandModel,
            motor: value.motor,
            mileage: value.mileage,
            fuelType: value.fuelType,
            year: value.year,
            purchaseDate: value.purchaseDate
        ).get()
        
        var values = try await localStorage.fetch().get()
        
        XCTAssertEqual(values.count, 1)
        
        _ = try await localStorage.remove(createdValue).get()
        
        values = try await localStorage.fetch().get()
        
        XCTAssertEqual(values.count, 0)
    }
    
    func test_remove_when_add_two_remove_one_expect_one() async throws {
        let value = createValue()
        let secondValue = createSecondValue()

        let valueCreated = try await localStorage.create(
            brandName: value.brandName,
            brandModel: value.brandModel,
            motor: value.motor,
            mileage: value.mileage,
            fuelType: value.fuelType,
            year: value.year,
            purchaseDate: value.purchaseDate
        ).get()

        let secondValueCreated = try await localStorage.create(
            brandName: secondValue.brandName,
            brandModel: secondValue.brandModel,
            motor: secondValue.motor,
            mileage: secondValue.mileage,
            fuelType: secondValue.fuelType,
            year: secondValue.year,
            purchaseDate: secondValue.purchaseDate
        ).get()

        _ = try await localStorage.remove(valueCreated).get()
        
        let values = try await localStorage.fetch().get()
        
        XCTAssertEqual(values, [secondValueCreated])
    }
    
    // MARK: - RemoveById
    
    func test_add_one_removeById_one_expect_zero() async throws {
        let value = createValue()
        let secondValue = createSecondValue()

        let valueCreated = try await localStorage.create(
            brandName: value.brandName,
            brandModel: value.brandModel,
            motor: value.motor,
            mileage: value.mileage,
            fuelType: value.fuelType,
            year: value.year,
            purchaseDate: value.purchaseDate
        ).get()
        
        var values = try await localStorage.fetch().get()
        
        XCTAssertEqual(values.count, 1)
        
        _ = try await localStorage.remove(byID: valueCreated.id).get()
        
        values = try await localStorage.fetch().get()
        
        XCTAssertEqual(values.count, 0)
    }
    
    func test_remove_when_add_two_removeById_one_expect_one() async throws {
        let value = createValue()
        let secondValue = createSecondValue()

        let valueCreated = try await localStorage.create(
            brandName: value.brandName,
            brandModel: value.brandModel,
            motor: value.motor,
            mileage: value.mileage,
            fuelType: value.fuelType,
            year: value.year,
            purchaseDate: value.purchaseDate
        ).get()

        let secondValueCreated = try await localStorage.create(
            brandName: secondValue.brandName,
            brandModel: secondValue.brandModel,
            motor: secondValue.motor,
            mileage: secondValue.mileage,
            fuelType: secondValue.fuelType,
            year: secondValue.year,
            purchaseDate: secondValue.purchaseDate
        ).get()

        _ = try await localStorage.remove(byID: valueCreated.id).get()
        
        let values = try await localStorage.fetch().get()
        
        XCTAssertEqual(values, [secondValueCreated])
    }
    
    // MARK: - Erase
    
    func test_erase_when_add_two_erase_expect_zero() async throws {
        let value = createValue()
        let secondValue = createSecondValue()

        _ = try await localStorage.create(
            brandName: value.brandName,
            brandModel: value.brandModel,
            motor: value.motor,
            mileage: value.mileage,
            fuelType: value.fuelType,
            year: value.year,
            purchaseDate: value.purchaseDate
        ).get()

        _ = try await localStorage.create(
            brandName: value.brandName,
            brandModel: value.brandModel,
            motor: value.motor,
            mileage: value.mileage,
            fuelType: value.fuelType,
            year: value.year,
            purchaseDate: value.purchaseDate
        ).get()
        
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
