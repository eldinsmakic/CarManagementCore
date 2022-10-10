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
    func erase()
}

public protocol LocalStorageProtocolAsync: StorageProtocolAsync {}
public protocol RemoteStorageProtocolAsync: StorageProtocolAsync {}

public protocol RepositoryProtocolAsync {
    associatedtype Value: Equatable

    func add(_ value: Value) async throws -> Value
    func update(_ value: Value) async throws -> Value
    func remove(_ value: Value) async throws -> Value
    func fetch() async throws  -> [Value]
    func erase()
}

public protocol RepositoryProtocolAsync2 {
    associatedtype LocalStorage: LocalStorageProtocolAsync where LocalStorage.Value == Value
    associatedtype RemoteStorage: RemoteStorageProtocolAsync where RemoteStorage.Value == Value
    associatedtype Value: Equatable
    
    var localStorage: LocalStorage { get }
    var remoteStorage: RemoteStorage { get }

    func add(_ value: Value) async throws -> Value
    func update(_ value: Value) async throws -> Value
    func remove(_ value: Value) async throws -> Value
    func fetch() async throws  -> [Value]
    func erase()
}

extension RepositoryProtocolAsync2 {
    public func add(_ value: Value) async throws -> Value {
        let _ = try await remoteStorage.add(value)
        let _ = try await localStorage.add(value)
        return value
    }
    
    public func update(_ value: Value) async throws -> Value {
        let _ = try await remoteStorage.update(value)
        let _ = try await localStorage.update(value)
        return value
    }

    public func remove(_ value: Value) async throws -> Value {
        let _ = try await remoteStorage.remove(value)
        let _ = try await localStorage.remove(value)
        return value
    }
    
    public func fetch() async throws -> [Value] {
        let remoteValue = try await localStorage.fetch()
        return remoteValue
    }
    
    public func erase() {
        remoteStorage.erase()
        localStorage.erase()
    }
}

public class VoitureRepositoryAsync: RepositoryProtocolAsync2 {
    public typealias Value = VoitureDTO

    @Injected public var localStorage: VoitureLocalStorageAsync
    @Injected public var remoteStorage: VoitureRemoteStorageAsync

   public init() {}
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
    
    public func erase() {
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
    
    public func erase() {
        list = []
    }
}


public class RepositoryGenericAsync<L: LocalStorageProtocolAsync, R: RemoteStorageProtocolAsync, Value>: RepositoryProtocolAsync where L.Value == Value, R.Value == Value {

    @Injected private var localStorage: L
    @Injected private var remoteStorage: R

    public init() {}
    
    public func add(_ value: Value) async throws -> Value {
        _ = try await remoteStorage.add(value)
        _ = try await localStorage.add(value)
        return value
    }
    
    public func update(_ value: Value) async throws -> Value {
        _ = try await remoteStorage.update(value)
        _ = try await localStorage.update(value)
        return value
    }

    public func remove(_ value: Value) async throws -> Value {
        _ = try await remoteStorage.remove(value)
        _ = try await localStorage.remove(value)
        return value
    }
    
    public func fetch() async throws -> [Value] {
        let remoteValue = try await remoteStorage.fetch()
        return remoteValue
    }
    
    public func erase() {
        remoteStorage.erase()
        localStorage.erase()
    }
}
