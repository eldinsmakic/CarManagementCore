//
//  TestRepositoryAsyncProtocol.swift
//  
//
//  Created by eldin smakic on 11/10/2022.
//

import Foundation
import XCTest
import Combine
@testable import CarManagementCore

public class TestRepositoryAsyncProtocol<R: RepositoryProtocolAsync>: XCTestCase {

    var genericRepository: R { creategenericRepository() }

    func creategenericRepository() -> R { fatalError() }
    func createValue() -> R.Value { fatalError() }
    func createSecondValue() -> R.Value { fatalError() }

    public override func setUp() async throws {
        try await super.setUp()
//        genericRepository = creategenericRepository()
    
        _ = await genericRepository.erase()
    }

    func test_get_expect_zero() async throws {
        
        let values = await genericRepository.fetch()
        let result = try values.get()

        XCTAssertEqual(result.count, 0)
    }

    
    func test_add_expect_one() async throws {
        _ = await genericRepository.add(createValue())

        let values = await genericRepository.fetch()
        let result = try values.get()

        XCTAssertEqual(result.count, 1)
    }


    func test_add_expect_two() async throws {
        let value = createValue()
        let secondValue = createSecondValue()

        _ = await genericRepository.add(value)
        _ = await genericRepository.add(secondValue)

        let values = await genericRepository.fetch()
        let result = try values.get()

        XCTAssertEqual(result.count, 2)
        XCTAssertEqual(result, [value, secondValue])
    }

    func test_add_expect_three() async throws {
        let value = createValue()
        let secondValue = createSecondValue()

        _ = await genericRepository.add(value)
        _ = await genericRepository.add(secondValue)
        _ = await genericRepository.add(value)

        let values = await genericRepository.fetch()
        let result = try values.get()

        XCTAssertEqual(result.count, 3)
        XCTAssertEqual(result, [value, secondValue, value])
    }

    func test_listPub_remove_expect_zero() async throws {
        let value = createValue()

        _ = await genericRepository.add(value)
        _ = await genericRepository.remove(value)

        let values = await genericRepository.fetch()
        let result = try values.get()

        XCTAssertEqual(result.count, 0)
    }

    func test_listPub_remove_when_add_two_expect_one() async throws {
        let value = createValue()
        let secondValue = createSecondValue()

        _ = await genericRepository.add(value)
        _ = await genericRepository.add(secondValue)
        _ = await genericRepository.remove(value)

        let values = await genericRepository.fetch()
        let result = try values.get()

        XCTAssertEqual(result, [secondValue])
    }

    func test_listPub_erase_expect_zero() async throws {
        let value = createValue()

        _ = await genericRepository.add(value)
        _ = await genericRepository.add(value)
        _ = await genericRepository.erase()

        let values = await genericRepository.fetch()
        let result = try values.get()

        XCTAssertEqual(result.count, 0)
    }
//
//    func test_remove_atOffset() {
//        let value = createValue()
//        let secondValue = createSecondValue()
//        genericRepository.add(value)
//
//        genericRepository.add(secondValue)
//
//        genericRepository.model.receive(on: queue).assign(to: &$values)
//
//        genericRepository.delete(at: .init(integer: .zero))
//
//        queue.sync { }
//
//        XCTAssertEqual(values, [secondValue])
//    }
}


