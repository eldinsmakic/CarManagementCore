//
//  TestsMarqueRepository.swift
//  
//
//  Created by eldin smakic on 08/10/2022.
//

import XCTest
import CarManagementCore

final class TestsMarqueRepository: TestRepositoryGeneric<MarqueLocalStorage> {

    override func setUp() {
        Injection.shared.removeAll()
        Injection.shared.register(MarqueLocalStorage.self) { _ in
            MarqueLocalStorage.shared
        }
        super.setUp()
    }
    override func creategenericRepository() -> MarqueRepository {
        MarqueRepository()
    }
    
    override func createValue() -> MarqueDTO {
        MarqueDTO(name: "bmw", model: "serie 5", motorisation: "2.5TDS")
    }
    
    override func createSecondValue() -> MarqueDTO {
        MarqueDTO(name: "bmw", model: "serie 5 Break", motorisation: "2.5TDS")
    }
}
