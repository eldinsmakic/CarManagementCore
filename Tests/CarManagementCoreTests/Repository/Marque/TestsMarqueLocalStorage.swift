//
//  TestsMarqueLocalStorage.swift
//  
//
//  Created by eldin smakic on 08/10/2022.
//

import XCTest
import CarManagementCore

final class TestsMarqueLocalStorage: TestLocalStorage<MarqueLocalStorage> {
    override func createLocalStorage() -> MarqueLocalStorage {
        MarqueLocalStorage.shared
    }

    override func createValue() -> MarqueDTO {
        MarqueDTO(name: "test", model: "hello", motorisation: "1.5l")
    }

    override func createSecondValue() -> MarqueDTO {
        MarqueDTO(name: "bmw", model: "serie 5 e39", motorisation: "2.5 tds")
    }
}
