//
//  TestsVoitureRepositoryAsyncG.swift
//  
//
//  Created by eldin smakic on 11/10/2022.
//

import XCTest
import CarManagementCore

final class TestsVoitureRepositoryAsync: TestRepositoryAsyncProtocol<VoitureRepositoryAsync> {
    
    let injection = Injection.shared
    
    override func creategenericRepository() -> VoitureRepositoryAsync { VoitureRepositoryAsync() }
    override func createValue() -> CarDTO { FakeData.Voiture.fistValue}
    override func createSecondValue() -> CarDTO { FakeData.Voiture.secondValue }
    
    override func setUp() async throws {
        let local = VoitureLocalStorageAsync.shared
        let remote = VoitureRemoteStorageAsync.shared
        injection.removeAll()
        injection.register((VoitureLocalStorageAsync).self) { _ in
            local
        }
        injection.register(VoitureRemoteStorageAsync.self) { _ in
            remote
        }
        try await local.erase()
        try await remote.erase()
    }
}
