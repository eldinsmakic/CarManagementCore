//
//  TestsOperationsLocalStorageRealm.swift
//  
//
//  Created by eldin smakic on 12/05/2023.
//

import XCTest
import CarManagementCore

final class TestsOperationsLocalStorageRealm: XCTestCase {
    var localStorage: OperationStorageProtocol!
    let firstCarId: UUID = .init()
    let secondCarId: UUID = .init()

    func createLocalStorage() async -> OperationStorageProtocol { try! await OperationLocaleStorageRealm() }

    func createValue() -> OperationDTO { .init(carId: firstCarId, id: .init(), title: "title1", mileage: 1, cost: 1, date: .now, type: .maintenance) }
    func createSecondValue() -> OperationDTO { .init(carId: firstCarId, id: .init(), title: "title2", mileage: 2, cost: 2, date: .now, type: .repair) }
    func createValueSecondCar() -> OperationDTO {
        FakeData.Operation.create(carId: secondCarId)
    }

    func createSecondValueSecondCar() -> OperationDTO {
        FakeData.Operation.create(carId: secondCarId)
    }

    public override func setUp() async throws {
        try await super.setUp()
        localStorage = await createLocalStorage()
        _ = await self.localStorage.erase()
    }

    // MARK: - Get
    func test_get_expect_zero() async throws {
        let values = await localStorage.fetchAllMixed()
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

        let values = await localStorage.fetchAllMixed()

        XCTAssertEqual(values.count, 2)
        XCTAssertEqual(values, [input, secondInput])
    }

    func test_add_one_expect_one() async throws {
        let value = createValue()

        _ = await localStorage.add(value)
        let values = await localStorage.fetchAllMixed()

        XCTAssertEqual(values.count, 1)
    }

    func test_add_two_expect_two() async throws {
        let value = createValue()
        let secondValue = createSecondValue()
        let _ = await localStorage.add(value)
        _ = await localStorage.add(secondValue)
        
        let values = await localStorage.fetchAllMixed()

        XCTAssertEqual(values.count, 2)
    }

    func test_add_When_add_three_with_same_value_expect_One() async throws {
        let value = createValue()

        _ = try await localStorage.add(value).get()
        _ = try await localStorage.add(value).get()
        _ = try await localStorage.add(value).get()
        
        let values = await localStorage.fetchAllMixed()

        XCTAssertEqual(values.count, 1)
    }

    func test_add_three_expect_three() async throws {
        let value = createValue()
        let secondValue = createSecondValue()
        let thirdValue = createValueSecondCar()

        _ = try await localStorage.add(value).get()
        _ = try await localStorage.add(secondValue).get()
        _ = try await localStorage.add(thirdValue).get()
        
        let values = await localStorage.fetchAllMixed()

        XCTAssertEqual(values.count, 3)
    }

    // MARK: - Remove

    func test_add_one_remove_one_expect_zero() async throws {
        let value = try await localStorage.add(createValue()).get()

        var values = await localStorage.fetchAllMixed()
        
        XCTAssertEqual(values.count, 1)

         _ = await localStorage.remove(value)

        values = await localStorage.fetchAllMixed()

        XCTAssertEqual(values.count, 0)
    }

    func test_remove_when_add_two_remove_one_expect_one() async throws {
        let value = try await localStorage.add(createValue()).get()
        let secondValue =  try await localStorage.add(createSecondValue()).get()
        _ = await localStorage.remove(value)

        let values = await localStorage.fetchAllMixed()

        XCTAssertEqual(values, [secondValue])
    }

    // MARK: - Erase

    func test_erase_when_add_two_erase_expect_zero() async throws {
        let value = createValue()

        _ = await localStorage.add(value)
        _ = await localStorage.add(value)

        _ = await localStorage.erase()
 
        let values = await localStorage.fetchAllMixed()

        XCTAssertEqual(values.count, 0)
    }

    // MARK: - Fetch

    func test_fetch_When_no_data_expect_zero() async throws {
        let result = try await localStorage.fetch()

        XCTAssertEqual(result.count, 0)
    }

    func test_fetch_When_add_one_or_more_car_operation_from_one_car_expect_one() async throws {
        _ = await localStorage.add(createValue())
        _ = await localStorage.add(createSecondValue())
        let result = try await localStorage.fetch()
        
        XCTAssertEqual(result.count, 1)
    }
    
    func test_fetch_When_add_two_car_operation_expect_two() async throws {
        
        _ = await localStorage.add(createValue())
        _ = await localStorage.add(createSecondValue())
        _ = await localStorage.add(createValueSecondCar())
        _ = await localStorage.add(createSecondValueSecondCar())
        let result = try await localStorage.fetch()
        
        XCTAssertEqual(result.count, 2)
    }

    // MARK: - Create

    func test_create_When_create_expect_one() async throws {
        let value = try await localStorage.create(withCarId: firstCarId)

        let result = await localStorage.fetchAllMixed()

        XCTAssertEqual(result.count, 1)
    }


    // MARK: - fetchLastOperations

    func test_fetchLastOperations_When_no_data_expect_empty() async throws {
        let fetch = try await localStorage.fetchLastOperations()

        XCTAssertEqual(fetch.isEmpty, true)
    }

    func test_fetchLastOperations_When_add_value_expect_last_five() async throws {

        for value in (1...10) {
             _ = await localStorage.add(FakeData.Operation.create(carId: firstCarId, title: "\(value)"))
        }

        let fetch = try await localStorage.fetchLastOperations()

        XCTAssertEqual(fetch.count, 1)
        XCTAssertEqual(fetch[firstCarId]?.count, 5)

        var index = 6
        for value in fetch[firstCarId] ?? [] {
            XCTAssertEqual(value.title, "\(index)")
            index += 1
        }
    }

    func test_fetchLastOperations_When_add_2_type_of_car_value_expect_last_five() async throws {

        for value in (1...15) {
            _ = await localStorage.add(FakeData.Operation.create(carId: firstCarId, title: "\(firstCarId)|\(value)"))
            _ = await localStorage.add(FakeData.Operation.create(carId: secondCarId, title: "\(secondCarId)|\(value)"))
        }

        let fetch = try await localStorage.fetchLastOperations()

        XCTAssertEqual(fetch.count, 2)
        XCTAssertEqual(fetch[firstCarId]?.count, 5)
        XCTAssertEqual(fetch[secondCarId]?.count, 5)

        var index = 11
        for (key, operations) in fetch {
            for operation in operations {
                XCTAssertEqual(operation.title, "\(key)|\(index)")
                index += 1
            }
            index = 11
        }
    }

    // MARK: - Fetch(ByCarId)
    
    func test_fetchByCarId_When_No_value_Expect_empty() async throws {
        let result = try await localStorage.fetch(byCarId: firstCarId)
        
        XCTAssertEqual(result.count, 0)
    }

    func test_fetchByCarId_When_two_value_Expect_two() async throws {
        _ = await localStorage.add(FakeData.Operation.create(carId: firstCarId))
        _ = await localStorage.add(FakeData.Operation.create(carId: firstCarId))

        _ = await localStorage.add(FakeData.Operation.create(carId: secondCarId))
        _ = await localStorage.add(FakeData.Operation.create(carId: secondCarId))
        _ = await localStorage.add(FakeData.Operation.create(carId: secondCarId))
        let result = try await localStorage.fetch(byCarId: firstCarId)
        
        XCTAssertEqual(result.count, 2)
    }
    
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



