//
//  TestsMotorizationLocalStorage.swift
//  
//
//  Created by eldin smakic on 20/05/2023.
//

import XCTest
import CarManagementCore

final class TestsMotorizationLocalStorage: TestsDefaultStorageProtocol<MotorizationStorageRealm> {
    
    override func createLocalStorage() async throws -> MotorizationStorageRealm { try await MotorizationStorageRealm() }
    
    override func createValue() -> MotorizationDTO { MotorizationDTO(brandId: .init(), modelId: .init(), id: .init(), name: "2.5d", type: .diesel) }
    override func createSecondValue() -> MotorizationDTO { MotorizationDTO(brandId: .init(), modelId: .init(), id: .init(), name: "2.5d", type: .diesel) }
    override func createThirdValue() -> MotorizationDTO { MotorizationDTO(brandId: .init(), modelId: .init(), id: .init(), name: "2.5d", type: .diesel)  }

    // MARK: - Create
    
    func test_Create_when_create_Expect_data_in_DB() async throws {
        let brandID = UUID()
        let modelID = UUID()
        let value = try await localStorage.create(brandID: brandID , modelId: modelID)
        
        let result = try await localStorage.fetch()

        XCTAssertEqual(value.brandId, brandID)
        XCTAssertEqual(value.modelId, modelID)
        XCTAssertEqual(result.count, 1)
    }

    func test_repository_with_other_repositories() async throws {
        let brandStorage = try await BrandNewStorageReal()
        let modelStorage = try await ModelNewStorageRealm()
        
//        modelStorage.get(byBrandId: <#T##UUID#>)
        
    }
}
