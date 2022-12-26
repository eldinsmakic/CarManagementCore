//
//  TestsMarqueLocalStorage.swift
//  
//
//  Created by eldin smakic on 08/10/2022.
//

import XCTest
import CarManagementCore

final class TestsMarqueLocalStorage: TestLocalStorageAsync<MarqueLocalStorageRealm> {

    override func createLocalStorage() -> MarqueLocalStorageRealm {
        MarqueLocalStorageRealm.shared
    }

    override func createValue() -> MarqueDTO {
        FakeData.Marque.firstValue
    }

    override func createSecondValue() -> MarqueDTO {
        FakeData.Marque.secondValue
    }
}
