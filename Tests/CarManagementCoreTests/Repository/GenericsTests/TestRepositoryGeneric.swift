//
//  TestLocalStorage.swift
//  
//
//  Created by S858071 on 21/11/2021.
//

import Foundation
import XCTest
import Combine
@testable import CarManagementCore

public class TestRepositoryGeneric<L: LocalStorageProtocol>: XCTestCase {
    private var cancellables: Set<AnyCancellable>!
    private var queue = DispatchQueue(label: "Test_repository_generic")
    
    @Published var values: [L.Value] = []

    var genericRepository: RepositoryGeneric<L, L.Value>!

    func creategenericRepository() -> RepositoryGeneric<L, L.Value> { fatalError() }
    func createValue() -> L.Value { fatalError() }
    func createSecondValue() -> L.Value { fatalError() }

    public override func setUp() {
        super.setUp()
        genericRepository = creategenericRepository()
        cancellables = []
        genericRepository.erase()
    }

    func test_listPub_get_expect_zero() {
        genericRepository.model.receive(on: queue).assign(to: &$values)
        
        genericRepository.fetch()
        
        queue.sync {}

        XCTAssertEqual(values.count, 0)
    }

    func test_listPub_get_expect_two() {
        let value = createValue()
        let secondValue = createSecondValue()

        genericRepository.model.receive(on: queue).assign(to: &$values)

        genericRepository.add(value)
        genericRepository.add(secondValue)
        
        genericRepository.fetch()
        
        queue.sync {}

        XCTAssertEqual(values.count, 2)
        XCTAssertEqual(values, [value, secondValue])
    }

    func test_listPub_expect_one() {
        let value = createValue()
        
        genericRepository.model.receive(on: queue).assign(to: &$values)

        genericRepository.add(value)
        
        queue.sync {}

        XCTAssertEqual(values.count, 1)
    }

    func test_listPub_expect_two() {
        let value = createValue()

        genericRepository.model.receive(on: queue).assign(to: &$values)

        genericRepository.add(value)
        
        genericRepository.add(value)
        
        queue.sync {}

        XCTAssertEqual(values.count, 2)
    }

    func test_listPub_expect_three() {
        let value = createValue()
 
        genericRepository.model.receive(on: queue).assign(to: &$values)

        genericRepository.add(value)
        genericRepository.add(value)
        genericRepository.add(value)

        queue.sync {}

        XCTAssertEqual(values.count, 3)
    }

    func test_listPub_remove_expect_zero() {
        let value = createValue()

        genericRepository.model.receive(on: queue).assign(to: &$values)

        genericRepository.add(value)
        genericRepository.remove(value)
        
        queue.sync {}

        XCTAssertEqual(values.count, 0)
    }

    func test_listPub_remove_when_add_two_expect_one() {
        let value = createValue()
        let secondValue = createSecondValue()
  
        genericRepository.model.receive(on: queue).assign(to: &$values)

        genericRepository.add(value)
        genericRepository.add(secondValue)
        genericRepository.remove(value)
        
        queue.sync {}

        XCTAssertEqual(values, [secondValue])
    }

    func test_listPub_erase_expect_zero() {
        let value = createValue()

        genericRepository.model.receive(on: queue).assign(to: &$values)

        genericRepository.add(value)
        genericRepository.add(value)
        genericRepository.erase()
        
        queue.sync {}

        XCTAssertEqual(values.count, 0)
    }

    func test_remove_atOffset() {
        let value = createValue()
        let secondValue = createSecondValue()
        genericRepository.add(value)

        genericRepository.add(secondValue)
        
        genericRepository.model.receive(on: queue).assign(to: &$values)

        genericRepository.delete(at: .init(integer: .zero))

        queue.sync { }
        
        XCTAssertEqual(values, [secondValue])
    }
}


