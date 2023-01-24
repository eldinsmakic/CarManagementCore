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
        static var fistValue: VoitureDTO = .init(marque: FakeData.Marque.firstValue, kilometrage: 100_000, carburant: .essence, annee: 1999.years.ago, dateAchat: .now)
        static var secondValue: VoitureDTO = .init(marque: FakeData.Marque.secondValue, kilometrage: 100_000, carburant: .gazole, annee: 2002.years.ago, dateAchat: .now)
    }
    enum Marque {
        static var firstValue: MarqueDTO = .init(id: .init(), name: "bmw", model: "serie 5 e39", motorisation: "2.5 tds")
        static var secondValue: MarqueDTO = .init(id: .init(), name: "audi", model: "a4", motorisation: "2.4")
    }
    enum Operation {
        static var fistValue: OperationDTO = .init(
            idVoiture: Marque.firstValue.id,
            id: .init(),
            nom: "Vidange",
            kilometrage: "100 000",
            cout: "100",
            date: .now,
            typeOperation: .maintenance
        )
        static var secondValue: OperationDTO = .init(
            idVoiture: Marque.secondValue.id,
            id: .init(),
            nom: "Courroie accesoire",
            kilometrage: "110 000",
            cout: "300",
            date: .now,
            typeOperation: .repair
        )
    }
}
