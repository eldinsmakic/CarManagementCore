//
//  File.swift
//  
//
//  Created by eldin smakic on 08/10/2022.
//

import Foundation
import Defaults

public struct CarDTO: Identifiable {
    public var id: UUID
    public let marque: BrandDTO
    public var kilometrage: Int
    public let carburant: FuelTypeDTO
    public let annee: Date
    public let dateAchat: Date
    
    public init(
        id: UUID,
        marque: BrandDTO,
        kilometrage: Int,
        carburant: FuelTypeDTO,
        annee: Date,
        dateAchat: Date
    ) {
        self.id = id
        self.marque = marque
        self.kilometrage = kilometrage
        self.carburant = carburant
        self.annee = annee
        self.dateAchat = dateAchat
    }
}

extension CarDTO: Codable, Equatable {}

extension CarDTO: DefaultsSerializable {
    public static let bridge = MyBridge<Self>()
}

public enum FuelTypeDTO: Codable {
    case essence
    case gazole
}
