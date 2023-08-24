//
//  File.swift
//  
//
//  Created by eldin smakic on 19/05/2023.
//

import Foundation
import RealmSwift

public protocol BrandStorageProtocolNew {
    func create() async throws -> BrandDTONew
    func add(_ value: BrandDTONew) async throws -> BrandDTONew
    func update(_ value: BrandDTONew) async throws-> BrandDTONew
    func remove(_ value: BrandDTONew) async throws-> BrandDTONew
    func remove(byID id: UUID) async throws-> BrandDTONew?
    func get(byId id: UUID) async throws -> BrandDTONew
    func fetch() async throws -> [BrandDTONew]
    func erase() async throws
}

public final class BrandNewStorageReal: BrandStorageProtocolNew {
    private let realm: Realm

    public init() async throws {
        realm = try await Realm(
            configuration: Realm.Configuration(deleteRealmIfMigrationNeeded: true),
            actor: BackgroundActor.shared
        )
    }

    @BackgroundActor
    public func create() async throws -> BrandDTONew {
        let marqueEntity = BrandEntity(
            name: ""
        )

        try realm.write {
            realm.add(marqueEntity)
        }

        return marqueEntity.toDTO()
    }

    @BackgroundActor
    public func add(_ value: BrandDTONew) async throws -> BrandDTONew {
        let marqueEntity = BrandEntity(dto: value)

        try realm.write {
            realm.add(marqueEntity, update: .modified)
        }

        return marqueEntity.toDTO()
    }

    @BackgroundActor
    public func update(_ value: BrandDTONew) async throws -> BrandDTONew {
        return try await add(value)
    }

    @BackgroundActor
    public func get(byId id: UUID) async throws -> BrandDTONew {
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
    public func remove(_ value: BrandDTONew) async throws -> BrandDTONew {
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
    public func fetch() async throws -> [BrandDTONew] {
        let all = realm.objects(BrandEntity.self)

        return all.map { marqueEntity in
            marqueEntity.toDTO()
        }
    }

    public func remove(byID id: UUID) async throws -> BrandDTONew? {
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

    convenience init(name: String) {
        self.init()
        self.name = name
    }

    convenience init(id: UUID, name: String) {
        self.init()
        self.id = id
        self.name = name
    }

    convenience init(dto: BrandDTONew) {
        self.init()
        self.id = dto.id
        self.name = dto.name
    }
}

extension BrandEntity {
    func toDTO() -> BrandDTONew {
        .init(id: id, name: name)
    }
}

public struct BrandDTONew {
    let id: UUID
    let name: String
}

