//
//  VoitureLocalStorageAsync.swift
//  
//
//  Created by eldin smakic on 10/10/2022.
//

import Foundation
import Defaults

public protocol StorageProtocolAsync {
    associatedtype Value: Equatable

    func add(_ value: Value) async throws -> Value
    func update(_ value: Value) async throws -> Value
    func remove(_ value: Value) async throws -> Value
    func fetch() async throws  -> [Value]
    func erase() async throws
}

public enum GenericErrorAsync: Error {
    case unknowError
}

public protocol LocalStorageProtocolAsync: StorageProtocolAsync {}
public protocol RemoteStorageProtocolAsync: StorageProtocolAsync {}

public protocol RepositoryProtocolAsync {
    associatedtype Value: Equatable

    func add(_ value: Value) async -> Result<Value,GenericErrorAsync>
    func update(_ value: Value) async -> Result<Value,GenericErrorAsync>
    func remove(_ value: Value) async -> Result<Value,GenericErrorAsync>
    func fetch() async -> Result<[Value],GenericErrorAsync>
    func erase() async -> Result<Void,GenericErrorAsync>
}

public class VoitureRemoteStorageAsync: RemoteStorageProtocolAsync {
    public static var shared = VoitureRemoteStorageAsync()

    var values: [VoitureDTO] = []

    public func add(_ value: CarManagementCore.VoitureDTO) async throws -> CarManagementCore.VoitureDTO {
        return value
    }

    public func update(_ value: CarManagementCore.VoitureDTO) async throws -> CarManagementCore.VoitureDTO {
        return value
    }
    
    public func remove(_ value: CarManagementCore.VoitureDTO) async throws -> CarManagementCore.VoitureDTO {
        return value
    }
    
    public func fetch() async throws -> [CarManagementCore.VoitureDTO] {
        return values
    }
    
    public func erase() async throws {
    }
}


public class VoitureLocalStorageAsync: LocalStorageProtocolAsync {
    public static var shared = VoitureLocalStorageAsync()

    private var list: [VoitureDTO] {
        get { Defaults[.voitures] }
        set { Defaults[.voitures] = newValue }
    }
    
    private init() {}

    public func add(_ value: CarManagementCore.VoitureDTO) async throws -> CarManagementCore.VoitureDTO {
        list.append(value)
        return value
    }
    
    public func update(_ value: CarManagementCore.VoitureDTO) async throws -> CarManagementCore.VoitureDTO {
        return value
    }
    
    public func remove(_ value: CarManagementCore.VoitureDTO) async throws -> CarManagementCore.VoitureDTO {
        list.removeAll { voiture in
            voiture == value
        }
        return value
    }
    
    public func fetch() async throws -> [CarManagementCore.VoitureDTO] {
        return list
    }
    
    public func erase() async throws {
        list = []
    }
}

public class VoitureRepositoryAsync: RepositoryGenericAsync<VoitureLocalStorageAsync,VoitureRemoteStorageAsync, VoitureDTO> {}


public struct AnyRepositoryAsync<I> {

    public init<T: RepositoryProtocolAsync>(_ repo: T) where T.Value == I {
        self.add = repo.add(_:)
        self.fetch = repo.fetch
        self.remove = repo.remove(_:)
        self.update = repo.update(_:)
//        self.delete = repo.delete(at:)
        self.erase = repo.erase
    }

    var add: (_ value: I) async throws -> Result<I,GenericErrorAsync>
    var update: (_ value: I) async throws -> Result<I,GenericErrorAsync>
    var remove: (_ value: I) async throws -> Result<I,GenericErrorAsync>
    var fetch: () async throws  -> Result<[I],GenericErrorAsync>
    var erase: () async -> Result<Void,GenericErrorAsync>
}

public class RepositoryGenericAsync<L: LocalStorageProtocolAsync, R: RemoteStorageProtocolAsync, Value>: RepositoryProtocolAsync where L.Value == Value, R.Value == Value {
    @Injected private var localStorage: L
    @Injected private var remoteStorage: R

    public init() {}
    
    public func add(_ value: Value) async -> Result<Value, GenericErrorAsync>  {
        do {
            _ = try? await remoteStorage.add(value)
            _ = try? await localStorage.add(value)
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
