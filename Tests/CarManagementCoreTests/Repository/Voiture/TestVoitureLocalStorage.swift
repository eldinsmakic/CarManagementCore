//
//  TestVoitureLocalStorage.swift
//  
//
//  Created by eldin smakic on 08/10/2022.
//

import XCTest
import CarManagementCore

final class TestVoitureLocalStorage: TestLocalStorage<VoitureLocalStorage> {

    override func createLocalStorage() -> VoitureLocalStorage {
        VoitureLocalStorage.shared
    }

    override func createValue() -> VoitureDTO {
        VoitureDTO(marque: FakeData.Marque.firstValue, kilometrage: 100_000, carburant: .essence, annee: 1999.years.ago, dateAchat: .now)
    }

    override func createSecondValue() -> VoitureDTO {
        VoitureDTO(marque: FakeData.Marque.secondValue, kilometrage: 100_000, carburant: .gazole, annee: 2002.years.ago, dateAchat: .now)
    }
}
