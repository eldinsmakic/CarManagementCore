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
        FakeData.Marque.firstValue
    }
    
    override func createSecondValue() -> MarqueDTO {
        FakeData.Marque.secondValue
    }
}
