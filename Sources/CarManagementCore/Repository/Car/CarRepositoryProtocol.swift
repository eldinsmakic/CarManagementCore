//
//  File.swift
//  
//
//  Created by eldin smakic on 25/08/2023.
//

import Foundation

public protocol CarRepositoryProtocol: CarStorageProtocol {}

public final class CarRepository: CarRepositoryProtocol {
    @Injected var localStorage: CarStorageProtocol
    
    public init() {}

    public func create(
        brandName: String,
        brandModel: String,
        motor: String,
        mileage: Int,
        fuelType: FuelTypeDTO,
        year: Date,
        purchaseDate: Date
    ) async -> Result<CarDTO, GenericErrorAsync> {
        await localStorage.create(
            brandName: brandName,
            brandModel: brandModel,
            motor: motor,
            mileage: mileage,
            fuelType: fuelType,
            year: year,
            purchaseDate: purchaseDate
        )
    }
    
    public func update(_ value: CarDTO) async -> Result<CarDTO, GenericErrorAsync> {
        await localStorage.update(value)
    }
    
    public func remove(_ value: CarDTO) async -> Result<CarDTO, GenericErrorAsync> {
        await localStorage.remove(value)
    }
    
    public func remove(byID id: UUID) async -> Result<CarDTO?, GenericErrorAsync> {
        await localStorage.remove(byID: id)
    }
    
    public func get(byId id: UUID) async -> Result<CarDTO, GenericErrorAsync> {
        await localStorage.get(byId: id)
    }
    
    public func fetch() async -> Result<[CarDTO], GenericErrorAsync> {
        await localStorage.fetch()
    }
    
    public func erase() async -> Result<Void, GenericErrorAsync> {
        await localStorage.erase()
    }
}
