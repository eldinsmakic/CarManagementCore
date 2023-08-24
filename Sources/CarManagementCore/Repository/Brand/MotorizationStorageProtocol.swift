//
//  File.swift
//  
//
//  Created by eldin smakic on 19/05/2023.
//

import Foundation
import RealmSwift

public protocol DefaultStorageProtocol<ValueDTO> {
    associatedtype ValueDTO: DTO
    func add(_ value: ValueDTO) async throws -> ValueDTO
    func update(_ value: ValueDTO) async throws-> ValueDTO
    func remove(_ value: ValueDTO) async throws-> ValueDTO
    func remove(byID id: UUID) async throws-> ValueDTO
    func get(byId id: UUID) async throws -> ValueDTO
    func fetch() async throws -> [ValueDTO]
    func erase() async throws
}

public protocol DefaultRepositoryProtocol: DefaultStorageProtocol {}

public protocol DTO: Equatable {
    var id: UUID { get }
}

public protocol MotorizationStorageProtocolTest {
    associatedtype value: DefaultStorageProtocol where value.ValueDTO == MotorizationDTO
    func create(brandID: UUID, modelId: UUID) async throws -> value.ValueDTO
//    func get(byBrandId brandId: UUID, andModelID modelID: UUID) async throws -> [ValueDTO]
}


public protocol MotorizationStorageProtocol: DefaultStorageProtocol where ValueDTO == MotorizationDTO {
    func create(brandID: UUID, modelId: UUID) async throws -> ValueDTO
//    func get(byBrandId brandId: UUID, andModelID modelID: UUID) async throws -> [ValueDTO]
}

public final class MotorizationStorageRealm: MotorizationStorageProtocol {
    private let realm: Realm

    public init() async throws {
        realm = try await Realm(
            configuration: Realm.Configuration(deleteRealmIfMigrationNeeded: true),
            actor: BackgroundActor.shared
        )
    }

    @BackgroundActor
    public func create(brandID: UUID, modelId: UUID) async throws -> MotorizationDTO {
        let marqueEntity = MotorizationEntity(
            brandId: brandID,
            modelId: modelId
        )

        try realm.write {
            realm.add(marqueEntity)
        }

        return marqueEntity.toDTO()
    }

    @BackgroundActor
    public func add(_ value: MotorizationDTO) async throws -> MotorizationDTO {
        let marqueEntity = MotorizationEntity(dto: value)

        try realm.write {
            realm.add(marqueEntity, update: .modified)
        }

        return marqueEntity.toDTO()
    }

    @BackgroundActor
    public func update(_ value: MotorizationDTO) async throws -> MotorizationDTO {
        return try await add(value)
    }

    @BackgroundActor
    public func get(byId id: UUID) async throws -> MotorizationDTO {
        let all = realm.objects(MotorizationEntity.self)

        let result = all.first { marqueEntity in
            marqueEntity.id == id
        }

        if result != nil {
            return result!.toDTO()
        }

        throw NSError(domain: "Erreur", code: 1)
    }

    @BackgroundActor
    public func remove(_ value: MotorizationDTO) async throws -> MotorizationDTO {
        let all = realm.objects(MotorizationEntity.self)

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
    public func fetch() async throws -> [MotorizationDTO] {
        let all = realm.objects(MotorizationEntity.self)

        return all.map { marqueEntity in
            marqueEntity.toDTO()
        }
    }

    @BackgroundActor
    public func remove(byID id: UUID) async throws -> MotorizationDTO {
        let all = realm.objects(MotorizationEntity.self)

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
            let all = realm.objects(MotorizationEntity.self)
            realm.delete(all)
        }
    }
}
        
class MotorizationEntity: Object {
    @Persisted var brandId: UUID
    @Persisted var modelId: UUID
    @Persisted(primaryKey: true) var id: UUID
    @Persisted var name: String
    @Persisted var fuelType: String

    convenience init(brandId: UUID, modelId: UUID) {
        self.init()
        self.brandId = brandId
        self.modelId = modelId
        self.name = ""
        self.fuelType = ""
    }

    convenience init(brandId: UUID, modelId: UUID, name: String, fuelType: String) {
        self.init()
        self.brandId = brandId
        self.modelId = modelId
        self.name = name
        self.fuelType = fuelType
    }

    convenience init(id: UUID, brandId: UUID, modelId: UUID, name: String, fuelType: String) {
        self.init()
        self.id = id
        self.init(brandId: brandId, modelId: modelId, name: name, fuelType: fuelType)
    }

    convenience init(dto: MotorizationDTO) {
        self.init()
        self.id = dto.id
        self.brandId = dto.brandId
        self.modelId = dto.modelId
        self.name = dto.name
    }
}

extension MotorizationEntity {
    func toDTO() -> MotorizationDTO {
        .init(brandId: brandId, modelId: modelId, id: id, name: name, type: .diesel)
    }
}

public struct MotorizationDTO: DTO {
    public let brandId: UUID
    public let modelId: UUID
    public let id: UUID
    public var name: String
    public var type: FuelTypeDTO

    public init(brandId: UUID, modelId: UUID, id: UUID, name: String, type: FuelTypeDTO) {
        self.brandId = brandId
        self.modelId = modelId
        self.id = id
        self.name = name
        self.type = type
    }
}
