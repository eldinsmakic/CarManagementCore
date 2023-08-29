//
//  CarLocalStorageRealm.swift
//  
//
//  Created by eldin smakic on 25/08/2023.
//

import Foundation
import RealmSwift
import Realm

@BackgroundActor
public final class CarLocalStorageRealm: CarStorageProtocol {
    private let realm: Realm

    public init() async throws {
        realm = try await Realm(
            configuration: Realm.Configuration(deleteRealmIfMigrationNeeded: true),
            actor: BackgroundActor.shared
        )
    }

    public func create(
        brandName: String,
        brandModel: String,
        motor: String,
        mileage: Int,
        fuelType: FuelTypeDTO,
        year: Date, purchaseDate: Date
    ) async -> Result<CarDTO, GenericErrorAsync> {
        do {
            let carLocaleEntity = CarLocalEntity(
                brandName: brandName,
                brandModel: brandModel,
                motor: motor,
                mileage: mileage,
                fuelType: fuelType,
                year: year,
                purchaseDate: purchaseDate
            )
            try await realm.asyncWrite {
                self.realm.add(carLocaleEntity, update: .modified)
            }
            return .success(carLocaleEntity.toDTO())
        } catch {
            return .failure(.unknowError)
        }
    }

    public func update(_ value: CarDTO) async -> Result<CarDTO, GenericErrorAsync> {
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
    
    public func remove(_ value: CarDTO) async -> Result<CarDTO, GenericErrorAsync> {
        let entity = CarLocalEntity(car: value)
        do {
            let all = realm.objects(CarLocalEntity.self)
            let result = all.filter { car in
                car.id == entity.id
            }
            try realm.write {
                realm.delete(result)
            }
            return .success(value)
        } catch {
            return .failure(.unknowError)
        }
    }
    
    public func remove(byID id: UUID) async -> Result<CarDTO?, GenericErrorAsync> {
        do {
            let all = realm.objects(CarLocalEntity.self)
            let result = all.filter { car in
                car.id == id
            }
            try realm.write {
                realm.delete(result)
            }
            return .success(result.first?.toDTO())
        } catch {
            return .failure(.unknowError)
        }
    }
    
    public func get(byId id: UUID) async -> Result<CarDTO, GenericErrorAsync> {
        let all = realm.objects(CarLocalEntity.self)
        if let result = all.first(where:{ $0.id == id })?.toDTO() {
            return .success(result)
        } else {
            return .failure(.notFound)
        }
    }
    
    public func fetch() async -> Result<[CarDTO], GenericErrorAsync> {
        .success(
            realm.objects(CarLocalEntity.self).map { $0.toDTO() }
        )
    }
    
    public func erase() async -> Result<Void, GenericErrorAsync> {
        do {
            let result = realm.objects(CarLocalEntity.self)
            try realm.write {
                realm.delete(result)
            }
            return .success(())
        } catch {
            return .failure(.unknowError)
        }
    }
}

public class CarLocalEntity: Object {
    @Persisted(primaryKey: true) var id: UUID
    @Persisted var brandName: String
    @Persisted var brandModel: String
    @Persisted var motor: String
    @Persisted var mileage: Int
    @Persisted var year: Date
    @Persisted var fuelType: String
    @Persisted var purchaseDate: Date?

    public convenience init(
        brandName: String,
        brandModel: String,
        motor: String,
        mileage: Int,
        fuelType: FuelTypeDTO,
        year: Date,
        purchaseDate: Date
    ) {
        self.init()
        self.brandName = brandName
        self.brandModel = brandModel
        self.motor = motor
        self.mileage = mileage
        self.fuelType = fuelType.rawValue
        self.year = year
        self.purchaseDate = purchaseDate
    }

    convenience init(car: CarDTO) {
        self.init()
        self.id = car.id
        self.brandName = car.brandName
        self.brandModel = car.brandModel
        self.motor = car.motor
        self.mileage = car.mileage
        self.year = car.year
        self.purchaseDate = car.purchaseDate
    }

    func toDTO() -> CarDTO {
        .init(
            id: id,
            brandName: brandName,
            brandModel: brandModel,
            motor: motor,
            mileage: mileage,
            fuelType: .init(rawValue: fuelType) ?? .gazoline,
            year: year,
            purchaseDate: purchaseDate ?? .now
        )
    }
}
