//
//  File.swift
//  
//
//  Created by eldin smakic on 09/10/2022.
//

import Foundation
import Defaults

public struct OperationDTO: Codable, Equatable, Identifiable {
    public var carId: UUID
    public var id: UUID
    public var title: String
    public var mileage: Int
    public var cost: Double
    public var date: Date
    public var type: OperationTypeDTO

    public init(
        carId: UUID,
        id: UUID,
        title: String,
        mileage: Int,
        cost: Double,
        date: Date,
        type: OperationTypeDTO
    ) {
        self.carId = carId
        self.id = id
        self.title = title
        self.mileage = mileage
        self.cost = cost
        self.date = date
        self.type = type
    }
}

public enum OperationTypeDTO: Codable, Equatable {
    case upgrade
    case repair
    case maintenance
}

