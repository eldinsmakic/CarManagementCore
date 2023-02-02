//
//  File.swift
//  
//
//  Created by eldin smakic on 23/12/2022.
//

import Foundation
import RealmSwift

public final class MarqueLocalStorageRealm: LocalStorageProtocolAsync {
    public static var shared = MarqueLocalStorageRealm()

    private init() {}

    public typealias Value = MarqueDTO

    @MainActor
    public func add(_ value: MarqueDTO) async throws -> MarqueDTO {
        let realm = try! await Realm(configuration: Realm.Configuration(deleteRealmIfMigrationNeeded: true))
        let marqueEntity = MarqueEntity(
            name: value.name,
            model: value.model,
            motorisation: value.motorisation
        )

        try! realm.write {
            realm.add(marqueEntity)
        }

        return marqueEntity.toDTO()
    }

    @MainActor
    public func update(_ value: MarqueDTO) async throws -> MarqueDTO {
        return try await add(value)
    }

    @MainActor
    public func get(byId id: UUID) async throws -> MarqueDTO {
        let realm = try! await Realm(configuration: Realm.Configuration(deleteRealmIfMigrationNeeded: true))
        let all = realm.objects(MarqueEntity.self)

        let result = all.first { marqueEntity in
            marqueEntity._id == id
        }
        
        if result != nil {
            return result!.toDTO()
        }
        
        throw NSError(domain: "Erreur", code: 1)
    }

    @MainActor
    public func remove(_ value: MarqueDTO) async throws -> MarqueDTO {
        let realm = try! await Realm(configuration: Realm.Configuration(deleteRealmIfMigrationNeeded: true))
        
        let all = realm.objects(MarqueEntity.self)

        let result = all.where { entity in
            entity._id == value.id
        }

        guard let element = result.first?.toDTO() else {
            throw NSError(domain: "element not exist", code: 2)
        }

        try! realm.write {
            realm.delete(result)
        }

        return element
    }

    @MainActor
    public func fetch() async throws -> [MarqueDTO] {
        let realm = try! await Realm(configuration: Realm.Configuration(deleteRealmIfMigrationNeeded: true))
        let all = realm.objects(MarqueEntity.self)

        return all.map { marqueEntity in
            marqueEntity.toDTO()
        }
    }

    @MainActor
    public func erase() async throws {
        let realm = try! await Realm(configuration: Realm.Configuration(deleteRealmIfMigrationNeeded: true))
        try! realm.write {
            let all = realm.objects(MarqueEntity.self)
            realm.delete(all)
        }
    }
}
        
class MarqueEntity: Object {
    @Persisted(primaryKey: true) var _id: UUID
    @Persisted var name: String
    @Persisted var model: String
    @Persisted var motorisation: String
 
    convenience init(name: String, model: String, motorisation: String) {
        self.init()
        self.name = name
        self.model = model
        self.motorisation = motorisation
    }
}

extension MarqueEntity {
    func toDTO() -> MarqueDTO {
        .init(id: _id, name: name, model: model, motorisation: motorisation)
    }
}
