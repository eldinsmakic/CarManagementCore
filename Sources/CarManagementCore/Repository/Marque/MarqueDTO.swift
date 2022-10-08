//
//  MarqueDTO.swift
//  
//
//  Created by eldin smakic on 08/10/2022.
//

import Foundation
import Defaults

public struct MarqueDTO: Codable, Equatable {
    public let name: String
    public let model: String
    public let motorisation: String
    
    public init(
        name: String,
        model: String,
        motorisation: String
    ) {
        self.name = name
        self.model = model
        self.motorisation = motorisation
    }
}

extension MarqueDTO: DefaultsSerializable {
    public static let bridge = MyBridge<Self>()
}

struct VoitureDTO {
    let marque: MarqueDTO
    let kilometrage: Int
    let carburant: CarburantDTO
}

enum CarburantDTO {
    case essence
    case gazole
}
