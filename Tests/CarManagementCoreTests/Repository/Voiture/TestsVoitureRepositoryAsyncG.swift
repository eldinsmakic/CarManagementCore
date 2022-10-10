//
//  TestsVoitureRepositoryAsyncG.swift
//  
//
//  Created by eldin smakic on 11/10/2022.
//

import XCTest
import CarManagementCore

final class TestsVoitureRepositoryAsyncG: TestRepositoryAsyncProtocol<VoitureRepositoryAsync> {
    
    let injection = Injection.shared
    
    override func creategenericRepository() -> VoitureRepositoryAsync { VoitureRepositoryAsync() }
    override func createValue() -> VoitureDTO { FakeData.Voiture.fistValue}
    override func createSecondValue() -> VoitureDTO { FakeData.Voiture.secondValue }
    
    override func setUp() {
        let local = VoitureLocalStorageAsync.shared
        let remote = VoitureRemoteStorageAsync.shared
        injection.removeAll()
        injection.register(VoitureLocalStorageAsync.self) { _ in
            local
        }
        injection.register(VoitureRemoteStorageAsync.self) { _ in
            remote
        }
        local.erase()
        remote.erase()
    }
}
