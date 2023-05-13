//
//  File.swift
//  
//
//  Created by eldin smakic on 12/05/2023.
//

import Foundation

public protocol OperationRepositoryProtocol: OperationStorageProtocol {}

@globalActor public actor BackgroundActor: GlobalActor {
    public static var shared = BackgroundActor()
}

public final class OperationRepository: OperationRepositoryProtocol {
    @Injected var localStorage: OperationStorageProtocol
    
    public init() {}

    public func create(withCarId carId: UUID) async throws -> OperationDTO {
        try await localStorage.create(withCarId: carId)
    }
    
    public func add(_ value: OperationDTO) async -> Result<OperationDTO, GenericErrorAsync> {
        await localStorage.add(value)
    }
    
    public func update(_ value: OperationDTO) async -> Result<OperationDTO, GenericErrorAsync> {
        await localStorage.update(value)
    }
    
    public func remove(_ value: OperationDTO) async -> Result<OperationDTO, GenericErrorAsync> {
        await localStorage.remove(value)
    }
    
    public func remove(byCarID carId: UUID, andId id: UUID) async throws -> OperationDTO {
        try await localStorage.remove(byCarID: carId, andId: id)
    }
    
    public func get(fromCarId carId: UUID, andId id: UUID) async -> Result<OperationDTO, GenericErrorAsync> {
        await localStorage.get(fromCarId: carId, andId: id)
    }
    
    public func fetchAllMixed() async -> [OperationDTO] {
        await localStorage.fetchAllMixed()
    }
    
    public func fetch() async throws -> [UUID : [OperationDTO]] {
        try await localStorage.fetch()
    }
    
    public func fetchLastOperations() async throws -> [UUID : [OperationDTO]] {
        try await localStorage.fetchLastOperations()
    }
    
    public func fetch(byCarId carID: UUID) async throws -> [OperationDTO] {
        try await localStorage.fetch(byCarId: carID)
    }
    
    public func erase() async -> Result<Void, GenericErrorAsync> {
        await localStorage.erase()
    }
}
