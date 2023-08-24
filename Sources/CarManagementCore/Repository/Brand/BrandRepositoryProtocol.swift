//
//  File.swift
//  
//
//  Created by eldin smakic on 19/05/2023.
//

import Foundation


public protocol BrandRepositoryProtocolNew: BrandStorageProtocolNew {}

public final class BrandRepositoryNew: BrandRepositoryProtocolNew {
    @Injected var localStorage: BrandStorageProtocolNew

    public func create() async throws -> BrandDTONew {
        try await localStorage.create()
    }
    
    public func add(_ value: BrandDTONew) async throws -> BrandDTONew {
        try await localStorage.add(value)
    }
    
    public func update(_ value: BrandDTONew) async throws -> BrandDTONew {
        try await localStorage.update(value)
    }
    
    public func remove(_ value: BrandDTONew) async throws -> BrandDTONew {
        try await localStorage.remove(value)
    }
    
    public func remove(byID id: UUID) async throws -> BrandDTONew? {
        try await localStorage.remove(byID: id)
    }
    
    public func get(byId id: UUID) async throws -> BrandDTONew {
        try await localStorage.get(byId: id)
    }
    
    public func fetch() async throws -> [BrandDTONew] {
        try await localStorage.fetch()
    }
    
    public func erase() async throws {
        try await localStorage.erase()
    }
}
