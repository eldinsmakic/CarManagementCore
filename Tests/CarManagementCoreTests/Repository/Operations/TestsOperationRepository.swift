//
//  TestsOperationRepository.swift
//  
//
//  Created by eldin smakic on 13/05/2023.
//

import XCTest
import CarManagementCore

final class TestsOperationRepository: XCTestCase {
    var repository: OperationRepositoryProtocol!
    let firstCarId: UUID = .init()
    let secondCarId: UUID = .init()
    
    func createRepository() async -> OperationRepositoryProtocol {  OperationRepository() }
    
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
        let localStorage = try await OperationLocaleStorageRealm()
        Injection.shared.register(OperationStorageProtocol.self) { _ in
            localStorage
        }
        repository = await createRepository()
        _ = await self.repository.erase()
    }
    
    // MARK: - Get
    func test_get_expect_zero() async throws {
        let values = await repository.fetchAllMixed()
        // Asserting that our Combine pipeline yielded the
        // correct output:
        XCTAssertEqual(values.count, 0)
    }
    
    // MARK: - ADD
    func test_add_two_expect_two_same_value() async throws {
        var input = createValue()
        var secondInput = createSecondValue()
        
        input = try await repository.add(input).get()
        secondInput = try await repository.add(secondInput).get()
        
        let values = await repository.fetchAllMixed()
        
        XCTAssertEqual(values.count, 2)
        XCTAssertEqual(values, [input, secondInput])
    }
    
    func test_add_one_expect_one() async throws {
        let value = createValue()
        
        _ = await repository.add(value)
        let values = await repository.fetchAllMixed()
        
        XCTAssertEqual(values.count, 1)
    }
    
    func test_add_two_expect_two() async throws {
        let value = createValue()
        let secondValue = createSecondValue()
        let _ = await repository.add(value)
        _ = await repository.add(secondValue)
        
        let values = await repository.fetchAllMixed()
        
        XCTAssertEqual(values.count, 2)
    }
    
    func test_add_When_add_three_with_same_value_expect_One() async throws {
        let value = createValue()
        
        _ = try await repository.add(value).get()
        _ = try await repository.add(value).get()
        _ = try await repository.add(value).get()
        
        let values = await repository.fetchAllMixed()
        
        XCTAssertEqual(values.count, 1)
    }
    
    func test_add_three_expect_three() async throws {
        let value = createValue()
        let secondValue = createSecondValue()
        let thirdValue = createValueSecondCar()
        
        _ = try await repository.add(value).get()
        _ = try await repository.add(secondValue).get()
        _ = try await repository.add(thirdValue).get()
        
        let values = await repository.fetchAllMixed()
        
        XCTAssertEqual(values.count, 3)
    }
    
    // MARK: - Remove
    
    func test_add_one_remove_one_expect_zero() async throws {
        let value = try await repository.add(createValue()).get()
        
        var values = await repository.fetchAllMixed()
        
        XCTAssertEqual(values.count, 1)
        
        _ = await repository.remove(value)
        
        values = await repository.fetchAllMixed()
        
        XCTAssertEqual(values.count, 0)
    }
    
    func test_remove_when_add_two_remove_one_expect_one() async throws {
        let value = try await repository.add(createValue()).get()
        let secondValue =  try await repository.add(createSecondValue()).get()
        _ = await repository.remove(value)
        
        let values = await repository.fetchAllMixed()
        
        XCTAssertEqual(values, [secondValue])
    }
    
    // MARK: - Erase
    
    func test_erase_when_add_two_erase_expect_zero() async throws {
        let value = createValue()
        
        _ = await repository.add(value)
        _ = await repository.add(value)
        
        _ = await repository.erase()
        
        let values = await repository.fetchAllMixed()
        
        XCTAssertEqual(values.count, 0)
    }
    
    // MARK: - Fetch
    
    func test_fetch_When_no_data_expect_zero() async throws {
        let result = try await repository.fetch()
        
        XCTAssertEqual(result.count, 0)
    }
    
    func test_fetch_When_add_one_or_more_car_operation_from_one_car_expect_one() async throws {
        _ = await repository.add(createValue())
        _ = await repository.add(createSecondValue())
        let result = try await repository.fetch()
        
        XCTAssertEqual(result.count, 1)
    }
    
    func test_fetch_When_add_two_car_operation_expect_two() async throws {
        
        _ = await repository.add(createValue())
        _ = await repository.add(createSecondValue())
        _ = await repository.add(createValueSecondCar())
        _ = await repository.add(createSecondValueSecondCar())
        let result = try await repository.fetch()
        
        XCTAssertEqual(result.count, 2)
    }
    
    // MARK: - Create
    
    func test_create_When_create_expect_one() async throws {
        let value = try await repository.create(withCarId: firstCarId)
        
        let result = await repository.fetchAllMixed()
        
        XCTAssertEqual(result.count, 1)
    }
    
    
    // MARK: - fetchLastOperations
    
    func test_fetchLastOperations_When_no_data_expect_empty() async throws {
        let fetch = try await repository.fetchLastOperations()
        
        XCTAssertEqual(fetch.isEmpty, true)
    }
    
    func test_fetchLastOperations_When_add_value_expect_last_five() async throws {
        
        for value in (1...10) {
            _ = await repository.add(FakeData.Operation.create(carId: firstCarId, title: "\(value)"))
        }
        
        let fetch = try await repository.fetchLastOperations()
        
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
            _ = await repository.add(FakeData.Operation.create(carId: firstCarId, title: "\(firstCarId)|\(value)"))
            _ = await repository.add(FakeData.Operation.create(carId: secondCarId, title: "\(secondCarId)|\(value)"))
        }
        
        let fetch = try await repository.fetchLastOperations()
        
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
        let result = try await repository.fetch(byCarId: firstCarId)
        
        XCTAssertEqual(result.count, 0)
    }
    
    func test_fetchByCarId_When_two_value_Expect_two() async throws {
        _ = await repository.add(FakeData.Operation.create(carId: firstCarId))
        _ = await repository.add(FakeData.Operation.create(carId: firstCarId))
        
        _ = await repository.add(FakeData.Operation.create(carId: secondCarId))
        _ = await repository.add(FakeData.Operation.create(carId: secondCarId))
        _ = await repository.add(FakeData.Operation.create(carId: secondCarId))
        let result = try await repository.fetch(byCarId: firstCarId)
        
        XCTAssertEqual(result.count, 2)
    }
}
