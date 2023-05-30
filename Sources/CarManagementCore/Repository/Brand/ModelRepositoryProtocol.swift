//
//  File.swift
//  
//
//  Created by eldin smakic on 19/05/2023.
//

import Foundation

public protocol ModelRepositoryProtocol: ModelStorageProtocol {}

public final class ModelRepository: ModelRepositoryProtocol {
    @Injected var localStorage: ModelStorageProtocol
    
    public init() {}

    public func create(brandID: UUID) async throws -> ModelDTO {
        try await localStorage.create(brandID: brandID)
    }
    
    public func add(_ value: ModelDTO) async throws -> ModelDTO {
        try await localStorage.add(value)
    }
    
    public func update(_ value: ModelDTO) async throws -> ModelDTO {
        try await localStorage.update(value)
    }
    
    public func remove(_ value: ModelDTO) async throws -> ModelDTO {
        try await localStorage.remove(value)
    }
    
    public func remove(byID id: UUID) async throws -> ModelDTO {
        try await localStorage.remove(byID: id)
    }
    
    public func get(byId id: UUID) async throws -> ModelDTO {
        try await localStorage.get(byId: id)
    }

    public func get(byBrandId brandId: UUID) async throws -> [ModelDTO] {
        try await localStorage.get(byBrandId: brandId)
    }

    public func fetch() async throws -> [ModelDTO] {
        try await localStorage.fetch()
    }
    
    public func erase() async throws {
        try await localStorage.erase()
    }
}
