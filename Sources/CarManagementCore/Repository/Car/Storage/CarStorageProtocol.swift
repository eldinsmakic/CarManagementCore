//
//  CarStorageProtocol.swift
//  
//
//  Created by eldin smakic on 25/08/2023.
//

import Foundation

public protocol CarStorageProtocol {
    func create(
        brandName: String,
        brandModel: String,
        motor: String,
        mileage: Int,
        fuelType: FuelTypeDTO,
        year: Date,
        purchaseDate: Date
    ) async -> Result<CarDTO, GenericErrorAsync>

    func update(_ value: CarDTO) async-> Result<CarDTO,GenericErrorAsync>
    func remove(_ value: CarDTO) async-> Result<CarDTO,GenericErrorAsync>
    func remove(byID id: UUID) async-> Result<CarDTO?,GenericErrorAsync>
    func get(byId id: UUID) async -> Result<CarDTO,GenericErrorAsync>
    func fetch() async -> Result<[CarDTO],GenericErrorAsync>
    func erase() async -> Result<Void,GenericErrorAsync>
}
