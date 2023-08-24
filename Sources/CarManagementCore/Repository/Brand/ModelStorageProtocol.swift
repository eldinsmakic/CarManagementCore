//
//  ModelStorageProtocol.swift
//  
//
//  Created by eldin smakic on 19/05/2023.
//

import Foundation
import RealmSwift

public struct ModelDTO: DTO {
    public let brandId: UUID
    public let id: UUID
    public var name: String

    public init(brandId: UUID, id: UUID, name: String) {
        self.brandId = brandId
        self.id = id
        self.name = name
    }
}

public protocol ModelStorageProtocol {
    func create(brandID: UUID) async throws -> ModelDTO
    func add(_ value: ModelDTO) async throws -> ModelDTO
    func update(_ value: ModelDTO) async throws-> ModelDTO
    func remove(_ value: ModelDTO) async throws-> ModelDTO
    func remove(byID id: UUID) async throws-> ModelDTO
    func get(byId id: UUID) async throws -> ModelDTO
    func get(byBrandId brandId: UUID) async throws -> [ModelDTO]
    func fetch() async throws -> [ModelDTO]
    func erase() async throws
}

public final class ModelNewStorageRealm: ModelStorageProtocol {
    private let realm: Realm

    public init() async throws {
        realm = try await Realm(
            configuration: Realm.Configuration(deleteRealmIfMigrationNeeded: true),
            actor: BackgroundActor.shared
        )
    }

    @BackgroundActor
    public func create(brandID: UUID) async throws -> ModelDTO {
        let marqueEntity = ModelEntity(
            brandId: brandID
        )

        try realm.write {
            realm.add(marqueEntity)
        }

        return marqueEntity.toDTO()
    }

    @BackgroundActor
    public func add(_ value: ModelDTO) async throws -> ModelDTO {
        let marqueEntity = ModelEntity(dto: value)

        try realm.write {
            realm.add(marqueEntity, update: .modified)
        }

        return marqueEntity.toDTO()
    }

    @BackgroundActor
    public func update(_ value: ModelDTO) async throws -> ModelDTO {
        return try await add(value)
    }

    @BackgroundActor
    public func get(byId id: UUID) async throws -> ModelDTO {
        let all = realm.objects(ModelEntity.self)

        let result = all.first { marqueEntity in
            marqueEntity.id == id
        }

        if result != nil {
            return result!.toDTO()
        }

        throw NSError(domain: "Erreur", code: 1)
    }

    @BackgroundActor
    public func get(byBrandId brandId: UUID) async throws -> [ModelDTO] {
        let all = realm.objects(ModelEntity.self)

        let results = all.filter { marqueEntity in
            marqueEntity.brandId == brandId
        }

        return results.map { $0.toDTO() }
    }
    

    @BackgroundActor
    public func remove(_ value: ModelDTO) async throws -> ModelDTO {
        let all = realm.objects(ModelEntity.self)

        let result = all.where { entity in
            entity.id == value.id
        }

        guard let element = result.first?.toDTO() else {
            throw NSError(domain: "element not exist", code: 2)
        }

        try realm.write {
            realm.delete(result)
        }

        return element
    }

    @BackgroundActor
    public func fetch() async throws -> [ModelDTO] {
        let all = realm.objects(ModelEntity.self)

        return all.map { marqueEntity in
            marqueEntity.toDTO()
        }
    }

    @BackgroundActor
    public func remove(byID id: UUID) async throws -> ModelDTO {
        let all = realm.objects(ModelEntity.self)

        let result = all.where { entity in
            entity.id == id
        }

        guard let element = result.first?.toDTO() else {
            throw NSError(domain: "element not exist", code: 2)
        }

        try realm.write {
            realm.delete(result)
        }

        return element
    }

    @BackgroundActor
    public func erase() async throws {
        try realm.write {
            let all = realm.objects(ModelEntity.self)
            realm.delete(all)
        }
    }
}
        
class ModelEntity: Object {
    @Persisted var brandId: UUID
    @Persisted(primaryKey: true) var id: UUID
    @Persisted var name: String

    convenience init(brandId: UUID) {
        self.init()
        self.brandId = brandId
        self.name = ""
    }

    convenience init(brandId: UUID, name: String) {
        self.init()
        self.brandId = brandId
        self.name = name
    }

    convenience init(id: UUID, brandId: UUID, name: String) {
        self.init()
        self.id = id
        self.brandId = brandId
        self.name = name
    }

    convenience init(dto: ModelDTO) {
        self.init()
        self.brandId = dto.brandId
        self.id = dto.id
        self.name = dto.name
    }
}

extension ModelEntity {
    func toDTO() -> ModelDTO {
        .init(brandId: brandId, id: id, name: name)
    }
}
