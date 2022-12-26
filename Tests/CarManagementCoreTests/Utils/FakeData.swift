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
}
