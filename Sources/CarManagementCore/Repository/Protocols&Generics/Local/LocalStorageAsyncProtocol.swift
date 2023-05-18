//
//  LocalStorageProtocolAsync.swift
//  
//
//  Created by eldin smakic on 23/01/2023.
//

import Foundation

public protocol StorageProtocolAsync {
    associatedtype Value: Equatable

    func add(_ value: Value) async throws -> Value
    func update(_ value: Value) async throws -> Value
    func remove(_ value: Value) async throws -> Value
//    func get(byId id: Value.ID) async throws -> Value
    func fetch() async throws  -> [Value]
    
    func erase() async throws
}

public enum GenericErrorAsync: Error {
    case unknowError
}

public protocol LocalStorageProtocolAsync: StorageProtocolAsync {}

public protocol RemoteStorageProtocolAsync: StorageProtocolAsync {}
