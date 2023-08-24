//
//  VoitureRepository.swift
//  
//
//  Created by eldin smakic on 08/10/2022.
//

import Foundation
import RealmSwift

public class VoitureRepository: RepositoryGeneric<VoitureLocalStorage, CarDTO> {}

public protocol CarStorageProtocol {
    func add(_ value: CarDTO) async throws -> Result<CarDTO,GenericErrorAsync>
    func update(_ value: CarDTO) async throws-> Result<CarDTO,GenericErrorAsync>
    func remove(_ value: CarDTO) async throws-> Result<CarDTO,GenericErrorAsync>
    func remove(byID id: UUID) async throws-> Result<CarDTO?,GenericErrorAsync>
    func get(byId id: UUID) async throws -> Result<CarDTO,GenericErrorAsync>
    func fetch() async throws -> Result<[CarDTO],GenericErrorAsync>
    func erase() async throws -> Result<Void,GenericErrorAsync>
}

public protocol CarRepositoryProtocol: CarStorageProtocol {}

public final class CarLocalStorageRealm: CarStorageProtocol {
    private let realm: Realm

    public init() async throws {
        realm = try await Realm(
            configuration: Realm.Configuration(deleteRealmIfMigrationNeeded: true),
            actor: BackgroundActor.shared
        )
    }

    @BackgroundActor
    public func add(_ value: CarDTO) async throws -> Result<CarDTO, GenericErrorAsync> {
        do {
            let carLocaleEntity = CarLocalEntity(car: value)
            try await realm.asyncWrite {
                self.realm.add(carLocaleEntity, update: .modified)
            }
            return .success(carLocaleEntity.toDTO())
        } catch {
            return .failure(.unknowError)
        }
    }

    @BackgroundActor
    public func update(_ value: CarDTO) async throws -> Result<CarDTO, GenericErrorAsync> {
        .failure(.unknowError)
    }
    
    public func remove(_ value: CarDTO) async throws -> Result<CarDTO, GenericErrorAsync> {
        .failure(.unknowError)
    }
    
    public func remove(byID id: UUID) async throws -> Result<CarDTO?, GenericErrorAsync> {
        .failure(.unknowError)
    }
    
    public func get(byId id: UUID) async throws -> Result<CarDTO, GenericErrorAsync> {
        .failure(.unknowError)
    }
    
    public func fetch() async throws -> Result<[CarDTO], GenericErrorAsync> {
        .failure(.unknowError)
    }
    
    public func erase() async throws -> Result<Void, GenericErrorAsync> {
        .failure(.unknowError)
    }
}

public class CarLocalEntity: Object {
    @Persisted(primaryKey: true) var id: UUID
    @Persisted var brand: String
    @Persisted var mileage: Int
    @Persisted var year: Date
    @Persisted var fuelType: String
    @Persisted var purchaseDate: Date?

    public convenience init(
        id: UUID,
        brand: String,
        mileage: Int,
        year: Date,
        fuelType: String,
        purchaseDate: Date? = nil
    ) {
        self.init()
        self.id = id
        self.brand = brand
        self.mileage = mileage
        self.year = year
        self.fuelType = fuelType
        self.purchaseDate = purchaseDate
    }

    convenience init(car: CarDTO) {
        self.init()
        self.brand = car.brand.model
        self.mileage = car.mileage
        self.year = car.year
        self.purchaseDate = car.purchaseDate
    }

    func toDTO() -> CarDTO {
        .init(
            id: id,
            marque: .init(id: .init(), name: "", model: "", motorisation: ""),
            kilometrage: mileage,
            carburant: .init(rawValue: fuelType) ?? .gazoline,
            annee: year,
            dateAchat: purchaseDate ?? .now
        )
    }
}
