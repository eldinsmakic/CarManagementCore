//
//  MarqueDTO.swift
//  
//
//  Created by eldin smakic on 08/10/2022.
//

import Foundation
import Defaults

public struct BrandDTO: Codable, Equatable, Identifiable {
    public var id: UUID
    public var name: String
    public var model: String
    public var motorisation: String
    
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

extension BrandDTO: DefaultsSerializable {
    public static let bridge = MyBridge<Self>()
}
