//
//  RepositoryGeneric.swift
//  
//
//  Created by eldin smakic on 08/10/2022.
//

import Foundation
import Combine

public protocol RepositoryProtocol {
    associatedtype Value: Equatable

    var model: AnyPublisher<[Value], Never> { get }

    func add(_ value: Value)
    func remove(_ value: Value)
    func delete(at offsets: IndexSet)
    func fetch()
    func erase()
}

public class RepositoryGeneric<L: LocalStorageProtocol, Value>: RepositoryProtocol where L.Value == Value {
    
    @Injected private var localStorage: L

    public init() {}

    public var model: AnyPublisher<[Value], Never> { localStorage.model }

    public func add(_ value: Value) {
        localStorage.add(value)
    }

    public func fetch() {
        localStorage.fetch()
    }

    public func remove(_ value: Value) {
        localStorage.remove(value)
    }

    public func delete(at offsets: IndexSet) {
        localStorage.delete(at: offsets)
    }

    public func erase() {
        localStorage.erase()
    }
}

public struct AnyRepository<I> {

    public init<T: RepositoryProtocol>(_ repo: T) where T.Value == I {
        self.model = repo.model
        self.add = repo.add(_:)
        self.fetch = repo.fetch
        self.remove = repo.remove(_:)
        self.delete = repo.delete(at:)
        self.erase = repo.erase
    }

    public var model: AnyPublisher<[I], Never>
    public var add: (_ value: I) -> Void
    public var fetch: () -> Void
    public var remove: (_ value: I) -> Void
    public var delete: (_ at: IndexSet) -> Void
    public var erase: () -> Void
}

