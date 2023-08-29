//
//  File.swift
//  
//
//  Created by eldin smakic on 08/10/2022.
//

import Foundation
import SwiftDate
import CarManagementCore

enum FakeData {
    enum Voiture {
        static var fistValue: CarDTO = .init(
            id: .init(),
            brandName: FakeData.Marque.firstValue.name,
            brandModel: FakeData.Marque.firstValue.model, motor: FakeData.Marque.firstValue.motorisation,
            mileage: 100_000,
            fuelType: .diesel,
            year: .now,
            purchaseDate: .now
        )

        static var secondValue: CarDTO =  .init(
            id: .init(),
            brandName: FakeData.Marque.secondValue.name,
            brandModel: FakeData.Marque.secondValue.model, motor: FakeData.Marque.secondValue.motorisation,
            mileage: 299_000,
            fuelType: .gazoline,
            year: .now,
            purchaseDate: .now
        )
    }
    enum Marque {
        static var firstValue: BrandDTO = .init(id: .init(), name: "bmw", model: "serie 5 e39", motorisation: "2.5 tds")
        static var secondValue: BrandDTO = .init(id: .init(), name: "audi", model: "a4", motorisation: "2.4")

        static func create() -> BrandDTO {
            .init(id: .init(), name: "audi", model: "a4", motorisation: "2.4")
        }
    }
    enum Operation {
        static var fistValue: OperationDTO = .init(
            carId: Marque.firstValue.id,
            id: .init(),
            title: "Vidange",
            mileage: 100000,
            cost: 100,
            date: .now,
            type: .maintenance
        )
        static var secondValue: OperationDTO = .init(
            carId: Marque.secondValue.id,
            id: .init(),
            title: "Courroie accesoire",
            mileage: 110000,
            cost: 300,
            date: .now,
            type: .repair
        )

        static func create(carId: UUID) -> OperationDTO {
            .init(
                carId: carId,
                id: .init(),
                title: "Courroie accesoire",
                mileage: 110000,
                cost: 300,
                date: .now,
                type: .repair
            )
        }

        static func create(carId: UUID, title: String) -> OperationDTO {
            .init(
                carId: carId,
                id: .init(),
                title: title,
                mileage: 110000,
                cost: 300,
                date: .now,
                type: .repair
            )
        }
    }
}
