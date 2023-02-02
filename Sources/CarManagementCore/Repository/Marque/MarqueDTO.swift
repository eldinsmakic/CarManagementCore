//
//  MarqueDTO.swift
//  
//
//  Created by eldin smakic on 08/10/2022.
//

import Foundation
import Defaults

public struct MarqueDTO: Codable, Equatable, Identifiable {
    public let id: UUID
    public let name: String
    public let model: String
    public let motorisation: String
    
    public init(
        id: UUID,
        name: String,
        model: String,
        motorisation: String
    ) {
        self.id = id
        self.name = name
        self.model = model
        self.motorisation = motorisation
    }
}

extension MarqueDTO: DefaultsSerializable {
    public static let bridge = MyBridge<Self>()
}
