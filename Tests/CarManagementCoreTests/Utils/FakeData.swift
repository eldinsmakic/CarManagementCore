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
        static var fistValue: CarDTO = .init(id: .init(), marque: FakeData.Marque.firstValue, kilometrage: 100_000, carburant: .essence, annee: 1999.years.ago, dateAchat: .now)
        static var secondValue: CarDTO = .init(id: .init(), marque: FakeData.Marque.secondValue, kilometrage: 100_000, carburant: .gazole, annee: 2002.years.ago, dateAchat: .now)
    }
    enum Marque {
        static var firstValue: BrandDTO = .init(id: .init(), name: "bmw", model: "serie 5 e39", motorisation: "2.5 tds")
        static var secondValue: BrandDTO = .init(id: .init(), name: "audi", model: "a4", motorisation: "2.4")
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
