//
//  File.swift
//  
//
//  Created by eldin smakic on 23/12/2022.
//

import Foundation
import RealmSwift

public protocol BrandStorageProtocol {
    func create() async throws -> BrandDTO
    func add(_ value: BrandDTO) async throws -> BrandDTO
    func update(_ value: BrandDTO) async throws-> BrandDTO
    func remove(_ value: BrandDTO) async throws-> BrandDTO
    func remove(byID id: UUID) async throws-> BrandDTO?
    func get(byId id: UUID) async throws -> BrandDTO
    func fetch() async throws -> [BrandDTO]
    func erase() async throws
}

public protocol BrandRepositoryProtocol: BrandStorageProtocol {}

public final class MarqueLocalStorageRealm: BrandStorageProtocol {
    private let realm: Realm

    public init() async throws {
        realm = try await Realm(
            configuration: Realm.Configuration(deleteRealmIfMigrationNeeded: true),
            actor: BackgroundActor.shared
        )
    }

    @BackgroundActor
    public func create() async throws -> BrandDTO {
        let marqueEntity = BrandEntity(
            name: "",
            model: "",
            motorisation: ""
        )

        try realm.write {
            realm.add(marqueEntity)
        }

        return marqueEntity.toDTO()
    }

    @BackgroundActor
    public func add(_ value: BrandDTO) async throws -> BrandDTO {
        let marqueEntity = BrandEntity(dto: value)

        try realm.write {
            realm.add(marqueEntity, update: .modified)
        }

        return marqueEntity.toDTO()
    }

    @BackgroundActor
    public func update(_ value: BrandDTO) async throws -> BrandDTO {
        return try await add(value)
    }

    @BackgroundActor
    public func get(byId id: UUID) async throws -> BrandDTO {
        let all = realm.objects(BrandEntity.self)

        let result = all.first { marqueEntity in
            marqueEntity.id == id
        }

        if result != nil {
            return result!.toDTO()
        }

        throw NSError(domain: "Erreur", code: 1)
    }

    @BackgroundActor
    public func remove(_ value: BrandDTO) async throws -> BrandDTO {
        let all = realm.objects(BrandEntity.self)

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
    public func fetch() async throws -> [BrandDTO] {
        let all = realm.objects(BrandEntity.self)

        return all.map { marqueEntity in
            marqueEntity.toDTO()
        }
    }

    public func remove(byID id: UUID) async throws -> BrandDTO? {
        let all = realm.objects(BrandEntity.self)

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
            let all = realm.objects(BrandEntity.self)
            realm.delete(all)
        }
    }
}
        
class BrandEntity: Object {
    @Persisted(primaryKey: true) var id: UUID
    @Persisted var name: String
    @Persisted var model: String
    @Persisted var motorisation: String

    convenience init(name: String, model: String, motorisation: String) {
        self.init()
        self.name = name
        self.model = model
        self.motorisation = motorisation
    }

    convenience init(dto: BrandDTO) {
        self.init()
        self.id = dto.id
        self.name = dto.name
        self.model = dto.model
        self.motorisation = dto.motorisation
    }
}

extension BrandEntity {
    func toDTO() -> BrandDTO {
        .init(id: id, name: name, model: model, motorisation: motorisation)
    }
}
