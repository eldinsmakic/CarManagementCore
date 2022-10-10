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

public class TestRepositoryAsyncProtocol<R: RepositoryProtocolAsync2>: XCTestCase {

    var genericRepository: R { creategenericRepository() }

    func creategenericRepository() -> R { fatalError() }
    func createValue() -> R.Value { fatalError() }
    func createSecondValue() -> R.Value { fatalError() }

    public override func setUp() {
        super.setUp()
//        genericRepository = creategenericRepository()
    
        genericRepository.erase()
    }

    func test_get_expect_zero() async throws {
        
        let values = try await genericRepository.fetch()

        XCTAssertEqual(values.count, 0)
    }

    
    func test_add_expect_one() async throws {
        try await genericRepository.add(createValue())
        
        let values = try await genericRepository.fetch()

        XCTAssertEqual(values.count, 1)
    }

    
    func test_add_expect_two() async throws {
        let value = createValue()
        let secondValue = createSecondValue()

        try await genericRepository.add(value)
        try await genericRepository.add(secondValue)
        
        let values = try await genericRepository.fetch()

        XCTAssertEqual(values.count, 2)
        XCTAssertEqual(values, [value, secondValue])
    }

    func test_add_expect_three() async throws {
        let value = createValue()
        let secondValue = createSecondValue()

        try await genericRepository.add(value)
        try await genericRepository.add(secondValue)
        try await genericRepository.add(value)
        
        let values = try await genericRepository.fetch()

        XCTAssertEqual(values.count, 3)
        XCTAssertEqual(values, [value, secondValue, value])
    }

    func test_listPub_remove_expect_zero() async throws {
        let value = createValue()

        try await genericRepository.add(value)
        try await genericRepository.remove(value)

        let values = try await genericRepository.fetch()

        XCTAssertEqual(values.count, 0)
    }

    func test_listPub_remove_when_add_two_expect_one() async throws {
        let value = createValue()
        let secondValue = createSecondValue()

        try await genericRepository.add(value)
        try await genericRepository.add(secondValue)
        try await genericRepository.remove(value)

        let values = try await genericRepository.fetch()

        XCTAssertEqual(values, [secondValue])
    }

    func test_listPub_erase_expect_zero() async throws {
        let value = createValue()

        try await genericRepository.add(value)
        try await genericRepository.add(value)
        try await genericRepository.erase()
        
        let values = try await genericRepository.fetch()

        XCTAssertEqual(values.count, 0)
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


