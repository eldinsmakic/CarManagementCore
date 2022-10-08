//
//  File.swift
//  
//
//  Created by eldin smakic on 08/10/2022.
//

import Foundation
import Defaults

public struct VoitureDTO {
    public let marque: MarqueDTO
    public var kilometrage: Int
    public let carburant: CarburantDTO
    public let annee: Date
    public let dateAchat: Date
    
    public init(
        marque: MarqueDTO,
        kilometrage: Int,
        carburant: CarburantDTO,
        annee: Date,
        dateAchat: Date
    ) {
        self.marque = marque
        self.kilometrage = kilometrage
        self.carburant = carburant
        self.annee = annee
        self.dateAchat = dateAchat
    }
}

extension VoitureDTO: Codable, Equatable {}

extension VoitureDTO: DefaultsSerializable {
    public static let bridge = MyBridge<Self>()
}

public enum CarburantDTO: Codable {
    case essence
    case gazole
}
