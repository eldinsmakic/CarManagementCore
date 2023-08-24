//
//  File.swift
//  
//
//  Created by eldin smakic on 13/05/2023.
//

import Foundation
import RealmSwift

public protocol OperationStorageProtocol {
    func create(withCarId carId: UUID) async throws -> OperationDTO
    func add(_ value: OperationDTO) async -> Result<OperationDTO,GenericErrorAsync>
    func update(_ value: OperationDTO) async -> Result<OperationDTO,GenericErrorAsync>
    func remove(_ value: OperationDTO) async -> Result<OperationDTO,GenericErrorAsync>
    func remove(byCarID carId: UUID, andId id: UUID) async throws -> OperationDTO
    func get(fromCarId carId: UUID, andId id: UUID) async -> Result<OperationDTO,GenericErrorAsync>
    func fetchAllMixed() async -> [OperationDTO]
    func fetch() async throws -> [UUID:[OperationDTO]]
    func fetchLastOperations() async throws -> [UUID:[OperationDTO]]
    func fetch(byCarId carID: UUID) async throws -> [OperationDTO]
    func erase() async -> Result<Void,GenericErrorAsync>
}

public final class OperationLocaleStorageRealm: OperationStorageProtocol {
    private let realm: Realm

    public init() async throws {
        realm = try await Realm(
            configuration: Realm.Configuration(deleteRealmIfMigrationNeeded: true),
            actor: BackgroundActor.shared
        )
    }

    @BackgroundActor
    public func create(withCarId carId: UUID) async throws -> OperationDTO {
        let operationLocale = OperationLocaleEntity(carId: carId)
        do {
            return try await self.add(operationLocale.toDTO()).get()
        } catch {
            throw error
        }
    }

    @BackgroundActor
    public func add(_ value: OperationDTO) async -> Result<OperationDTO, GenericErrorAsync> {
        do {
            let operationLocale = OperationLocaleEntity(operationDTO: value)
            try await realm.asyncWrite {
                self.realm.add(operationLocale, update: .modified)
            }
            return .success(operationLocale.toDTO())
        } catch {
            return .failure(.unknowError)
        }
    }
    
    public func update(_ value: OperationDTO) async -> Result<OperationDTO, GenericErrorAsync> {
        await add(value)
    }

    @BackgroundActor
    public func remove(_ value: OperationDTO) async -> Result<OperationDTO, GenericErrorAsync> {
        let entity = OperationLocaleEntity(operationDTO: value)
        do {
            let all = realm.objects(OperationLocaleEntity.self)
            let result = all.filter { operation in
                operation.carId == entity.carId &&
                operation.id == entity.id
            }
            try realm.write {
                realm.delete(result)
            }
            return .success(value)
        } catch {
            return .failure(.unknowError)
        }
    }
    
    public func remove(byCarID carId: UUID, andId id: UUID) async throws -> OperationDTO {
        .init(carId: .init(), id: .init(), title: "", mileage: 0, cost: 0, date: .now, type: .maintenance)
    }
    
    public func get(fromCarId carId: UUID, andId id: UUID) async -> Result<OperationDTO, GenericErrorAsync> {
        .failure(.unknowError)
    }

    @BackgroundActor
    public func fetchAllMixed() async -> [OperationDTO] {
        let all = realm.objects(OperationLocaleEntity.self)
        return all.map { $0.toDTO() }
    }
    
    public func fetch() async throws -> [UUID : [OperationDTO]] {
        var result: [UUID: [OperationDTO]] = [:]
        let all = realm.objects(OperationLocaleEntity.self)

        let carIds = Set(all.map { $0.carId })
        for carId in carIds {
            result[carId] = all.where { $0.carId == carId }.map { $0.toDTO() }
        }
        return result
    }
    
    public func fetchLastOperations() async throws -> [UUID : [OperationDTO]] {
        var result: [UUID: [OperationDTO]] = [:]
        let all = realm.objects(OperationLocaleEntity.self).sorted(by: \.date)
    
        let carIds = Set(all.map { $0.carId })
        for carId in carIds {
            let operations = all.where { $0.carId == carId }.suffix(5).map { $0.toDTO() }
            result[carId] = Array(operations)
        }
        return result
    }
    
    public func fetch(byCarId carID: UUID) async throws -> [OperationDTO] {
        let all = realm.objects(OperationLocaleEntity.self).sorted(by: \.date)
        return all.where { $0.carId == carID }.map { $0.toDTO() }
    }

    @BackgroundActor
    public func erase() async -> Result<Void, GenericErrorAsync> {
        do {
            try realm.write { [self] in
                let all = self.realm.objects(OperationLocaleEntity.self)
                realm.delete(all)
            }
            return .success(())
        } catch {
            return .failure(.unknowError)
        }
    }
}

public class OperationLocaleEntity: Object {
    @Persisted var carId: UUID
    @Persisted(primaryKey: true) var id: UUID
    @Persisted var title: String
    @Persisted var mileage: Int
    @Persisted var cost: Double
    @Persisted var date: Date
    @Persisted var type: String

    convenience init(carId: UUID, title: String, mileage: Int, cost: Double, date: Date, type: String) {
        self.init()
        self.carId = carId
        self.title = title
        self.mileage = mileage
        self.cost = cost
        self.date = date
        self.type = type
    }

    convenience init(carId: UUID) {
        self.init()
        self.carId = carId
        self.title = ""
        self.mileage = 0
        self.cost = 0
        self.date = .now
        self.type = OperationTypeDTO.maintenance.rawValue
    }

    convenience init(operationDTO: OperationDTO) {
        self.init()
        self.carId = operationDTO.carId
        self.id = operationDTO.id
        self.title = operationDTO.title
        self.mileage = operationDTO.mileage
        self.cost = operationDTO.cost
        self.date = operationDTO.date
        self.type = operationDTO.type.rawValue
    }

    func toDTO() -> OperationDTO {
        OperationDTO(
            carId: carId,
            id: id,
            title: title,
            mileage: mileage,
            cost: cost,
            date: date,
            type: .init(rawValue: type) ?? .maintenance
        )
    }
}
