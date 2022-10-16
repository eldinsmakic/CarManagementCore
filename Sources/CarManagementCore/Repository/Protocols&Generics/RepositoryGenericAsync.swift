//
//  File.swift
//  
//
//  Created by eldin smakic on 17/10/2022.
//

import Foundation

public protocol RepositoryProtocolAsync {
    associatedtype Value: Equatable

    func add(_ value: Value) async -> Result<Value,GenericErrorAsync>
    func update(_ value: Value) async -> Result<Value,GenericErrorAsync>
    func remove(_ value: Value) async -> Result<Value,GenericErrorAsync>
    func fetch() async -> Result<[Value],GenericErrorAsync>
    func erase() async -> Result<Void,GenericErrorAsync>
}

public struct AnyRepositoryAsync<I> {

    public init<T: RepositoryProtocolAsync>(_ repo: T) where T.Value == I {
        self.add = repo.add(_:)
        self.fetch = repo.fetch
        self.remove = repo.remove(_:)
        self.update = repo.update(_:)
//        self.delete = repo.delete(at:)
        self.erase = repo.erase
    }

    public var add: (_ value: I) async -> Result<I,GenericErrorAsync>
    public var update: (_ value: I) async -> Result<I,GenericErrorAsync>
    public var remove: (_ value: I) async -> Result<I,GenericErrorAsync>
    public var fetch: () async  -> Result<[I],GenericErrorAsync>
    public var erase: () async -> Result<Void,GenericErrorAsync>
}

public class RepositoryGenericAsync<L: LocalStorageProtocolAsync, R: RemoteStorageProtocolAsync, Value>: RepositoryProtocolAsync where L.Value == Value, R.Value == Value {
    @Injected private var localStorage: L
    @Injected private var remoteStorage: R

    public init() {}
    
    public func add(_ value: Value) async -> Result<Value, GenericErrorAsync>  {
        do {
            _ = try await remoteStorage.add(value)
            _ = try await localStorage.add(value)
            return .success(value)
        } catch {
            return .failure(GenericErrorAsync.unknowError)
        }
    }
    
    public func update(_ value: Value) async ->  Result<Value, GenericErrorAsync>  {
        do {
            _ = try await remoteStorage.update(value)
            _ = try await localStorage.update(value)
            return .success(value)
        } catch {
            return .failure(GenericErrorAsync.unknowError)
        }
    }

    public func remove(_ value: Value) async  -> Result<Value, GenericErrorAsync>  {
        do {
            _ = try await remoteStorage.remove(value)
            _ = try await localStorage.remove(value)
            return .success(value)
        } catch {
            return .failure(GenericErrorAsync.unknowError)
        }
    }
    
    public func fetch() async -> Result<[Value], GenericErrorAsync> {
        do {
            let _ = try await remoteStorage.fetch()
            let localValue = try await localStorage.fetch()
            return .success(localValue)
        } catch {
            return .failure(GenericErrorAsync.unknowError)
        }
    }
    
    public func erase() async -> Result<Void, GenericErrorAsync> {
        do {
            try await remoteStorage.erase()
            try await localStorage.erase()
            return .success(())
        } catch {
            return .failure(GenericErrorAsync.unknowError)
        }
    }
}
