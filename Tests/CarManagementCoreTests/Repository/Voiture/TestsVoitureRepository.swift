//
//  TestsVoitureRepository.swift
//  
//
//  Created by eldin smakic on 08/10/2022.
//

import XCTest
import CarManagementCore

final class TestsVoitureRepository: TestRepositoryGeneric<VoitureLocalStorage> {

    override func setUp() {
        Injection.shared.removeAll()
        Injection.shared.register(VoitureLocalStorage.self) { _ in
            VoitureLocalStorage.shared
        }
        super.setUp()
    }

    override func creategenericRepository() -> VoitureRepository { VoitureRepository() }
    override func createValue() -> VoitureDTO { FakeData.Voiture.fistValue }
    override func createSecondValue() -> VoitureDTO { FakeData.Voiture.secondValue }
}
