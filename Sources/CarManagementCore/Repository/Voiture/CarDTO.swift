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
    public let brand: BrandDTO
    public var mileage: Int
    public let fuelType: FuelTypeDTO
    public let year: Date
    public let purchaseDate: Date
    
    public init(
        id: UUID,
        marque: BrandDTO,
        kilometrage: Int,
        carburant: FuelTypeDTO,
        annee: Date,
        dateAchat: Date
    ) {
        self.id = id
        self.brand = marque
        self.mileage = kilometrage
        self.fuelType = carburant
        self.year = annee
        self.purchaseDate = dateAchat
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
