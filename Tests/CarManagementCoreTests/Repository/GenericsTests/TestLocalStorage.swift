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

public class TestLocalStorage<L: LocalStorageProtocol>: XCTestCase {
    private var queue = DispatchQueue(label: "test_local_storage")
    
    @Published var values: [L.Value] = []
    @Published var value: L.Value?

    var localStorage: L!

    func createLocalStorage() -> L { fatalError() }
    func createValue() -> L.Value { fatalError() }
    func createSecondValue() -> L.Value { fatalError() }

    public override func setUp() {
        super.setUp()
        localStorage = createLocalStorage()
        self.values = []
        self.localStorage.erase()
    }

    func test_listPub_get_expect_zero() {
        localStorage.model.receive(on: queue).assign(to: &$values)
        
        localStorage.fetch()

        queue.sync { }
        // Asserting that our Combine pipeline yielded the
        // correct output:
        XCTAssertEqual(values.count, 0)
    }

    func test_listPub_get_expect_two() {
        let value = createValue()
        let secondValue = createSecondValue()

        localStorage.add(value)
        localStorage.add(secondValue)

        localStorage.model.receive(on: queue).assign(to: &$values)
        
        localStorage.fetch()
        
        queue.sync { }

        XCTAssertEqual(values.count, 2)
        XCTAssertEqual(values, [value, secondValue])
    }

    func test_listPub_expect_one() {
        let value = createValue()

        localStorage.model.receive(on: queue).assign(to: &$values)
        
        localStorage.add(value)
        
        queue.sync { }

        XCTAssertEqual(values.count, 1)
    }

    func test_listPub_expect_two() {
        let value = createValue()

        localStorage.add(value)

        localStorage.model.receive(on: queue).assign(to: &$values)
        
        localStorage.add(value)
        
        queue.sync { }

        XCTAssertEqual(values.count, 2)
    }

    func test_listPub_expect_three() {
        let value = createValue()

        localStorage.add(value)
        localStorage.add(value)

        localStorage.model.receive(on: queue).assign(to: &$values)
        
        localStorage.add(value)
        
        queue.sync { }

        XCTAssertEqual(values.count, 3)
    }

    func test_listPub_remove_expect_zero() {
        let value = createValue()

        localStorage.add(value)

        localStorage.model.receive(on: queue).assign(to: &$values)
        
        localStorage.remove(value)

        queue.sync { }

        XCTAssertEqual(values.count, 0)
    }

    func test_listPub_remove_when_add_two_expect_one() {
        let value = createValue()
        let secondValue = createSecondValue()

        localStorage.add(value)
        localStorage.add(secondValue)

        localStorage.model.receive(on: queue).assign(to: &$values)
        
        localStorage.remove(value)

        queue.sync { }
 
        XCTAssertEqual(values, [secondValue])
    }

    func test_listPub_erase_expect_zero() {
        let value = createValue()

        localStorage.add(value)
        localStorage.add(value)

        localStorage.model.receive(on: queue).assign(to: &$values)
        
        localStorage.erase()

        queue.sync { }

        XCTAssertEqual(values.count, 0)
    }
    
    func test_remove_atOffset() {
        let value = createValue()
        let secondValue = createSecondValue()
        localStorage.add(value)

        localStorage.add(secondValue)
        
        localStorage.model.receive(on: queue).assign(to: &$values)

        localStorage.delete(at: .init(integer: .zero))

        queue.sync { }
        
        XCTAssertEqual(values, [secondValue])
    }
}

