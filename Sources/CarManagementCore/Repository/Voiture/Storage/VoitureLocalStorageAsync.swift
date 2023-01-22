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
