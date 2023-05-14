//
//  TestVoitureLocalStorageAsync.swift
//  
//
//  Created by eldin smakic on 10/10/2022.
//

import XCTest
import CarManagementCore

final class TestVoitureLocalStorageAsync: TestLocalStorageAsync<VoitureLocalStorageAsync> {

    override func createLocalStorage() -> VoitureLocalStorageAsync { VoitureLocalStorageAsync.shared }
    override func createValue() -> CarDTO { FakeData.Voiture.fistValue }
    override func createSecondValue() -> CarDTO { FakeData.Voiture.secondValue }
}
