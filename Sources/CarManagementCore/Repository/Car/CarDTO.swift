//
//  File.swift
//  
//
//  Created by eldin smakic on 08/10/2022.
//

import Foundation
import Defaults

public struct CarDTO {
    public var id: UUID
    public var brandName: String
    public var brandModel: String
    public var motor: String
    public var mileage: Int
    public var fuelType: FuelTypeDTO
    public var year: Date
    public var purchaseDate: Date
    
    public init(
        id: UUID,
        brandName: String,
        brandModel: String,
        motor: String,
        mileage: Int,
        fuelType: FuelTypeDTO,
        year: Date,
        purchaseDate: Date
    ) {
        self.id = id
        self.brandName = brandName
        self.brandModel = brandModel
        self.motor = motor
        self.mileage = mileage
        self.fuelType = fuelType
        self.year = year
        self.purchaseDate = purchaseDate
    }
}

extension CarDTO: Codable, Equatable {}

extension CarDTO: DefaultsSerializable {
    public static let bridge = MyBridge<Self>()
}

public enum FuelTypeDTO: String, Codable {
    case gazoline
    case diesel
}
