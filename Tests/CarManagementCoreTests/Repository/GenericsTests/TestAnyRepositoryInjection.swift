//
//  TestAnyRepositoryInjection.swift
//  
//
//  Created by Eldin SMAKIC on 23/06/2022.
//

@testable import CarManagementCore

import XCTest
import Combine

class SpyRepositoryString: RepositoryProtocol {

    private var values: [String] = []

    private var publisher = PassthroughSubject<[String], Never>()

    var model: AnyPublisher<[String], Never> { publisher.eraseToAnyPublisher() }

    init() {}

    func add(_ value: String) {
        self.values.append(value)
        self.publisher.send(values)
    }

    func remove(_ value: String) {
        self.values.removeAll { $0 == value }
        self.publisher.send(values)
    }

    func delete(at offsets: IndexSet) {
//        self.values.remove(atOffsets: offsets)
        self.publisher.send(values)
    }

    func fetch() {
        publisher.send(values)
    }

    func erase() {
        self.values = []
        publisher.send(values)
    }
}

class SpyRepositoryString2: RepositoryProtocol {
    private var values: [String] = []

    private var publisher = PassthroughSubject<[String], Never>()

    var model: AnyPublisher<[String], Never> { publisher.eraseToAnyPublisher() }
    
    init() {}
    
    func add(_ value: String) {
        self.values.append(value + " World")
        self.publisher.send(values)
    }
    
    func remove(_ value: String) {
        self.values.removeAll { $0 == value }
        self.publisher.send(values)
    }

    func delete(at offsets: IndexSet) {
//        self.values.remove(atOffsets: offsets)
        self.publisher.send(values)
    }

    func fetch() {
        publisher.send(values)
    }
    
    func erase() {
        self.values = []
        publisher.send(values)
    }
}

public class PresenterString {
    @Injected var repo: AnyRepository<String>

    public init() {}
    
    public var model: AnyPublisher<[String], Never> { repo.model }
    
    func add(_ value: String) {
        repo.add(value)
    }
    
    func remove(_ value: String) {
        repo.remove(value)
    }
    
    func fetch() {
        repo.fetch()
    }
    
    func erase() {
        repo.erase()
    }
}

class TestAnyRepositoryInjection: XCTestCase {
    @Published var value: [String] = []

    let queue = DispatchQueue(label: "test_injection")

    override func setUpWithError() throws {
        Injection.shared.removeAll()
        Injection.shared.register(AnyRepository<String>.self) { _ in
            AnyRepository(SpyRepositoryString())
        }
    }



    func testExample() throws {
        let presenter = PresenterString()

        presenter.model.receive(on: queue).assign(to: &$value)

        presenter.add("hello")
        
        queue.sync {}
        
        XCTAssertEqual(value, ["hello"])
    }
    
    func testExample_with_another_injection() throws {
        Injection.shared.removeAll()
        Injection.shared.register(AnyRepository<String>.self) { _ in
            AnyRepository(SpyRepositoryString2())
        }

        let presenter = PresenterString()

        presenter.model.receive(on: queue).assign(to: &$value)

        presenter.add("hello")
        
        queue.sync {}

        XCTAssertEqual(value, ["hello World"])
    }
    
    func testExample_with_another_injection_and_add_2_Example_and_expect_it() throws {
        Injection.shared.removeAll()
        Injection.shared.register(AnyRepository<String>.self) { _ in
            AnyRepository(SpyRepositoryString2())
        }

        let presenter = PresenterString()

        presenter.model.receive(on: queue).assign(to: &$value)

        presenter.add("hello")
        
        presenter.add("holla")
        
        queue.sync {}

        XCTAssertEqual(value, ["hello World", "holla World"])
    }
    
}
