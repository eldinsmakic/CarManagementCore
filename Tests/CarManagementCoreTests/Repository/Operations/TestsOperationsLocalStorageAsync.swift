//
//  TestsOperationsLocalStorageAsync.swift
//  
//
//  Created by eldin smakic on 23/01/2023.
//

import XCTest
import CarManagementCore

final class TestsOperationsLocalStorageAsync: TestLocalStorageAsync<OperationLocalStorageAsync> {

    override func createLocalStorage() -> OperationLocalStorageAsync { OperationLocalStorageAsync.shared }
    override func createValue() -> OperationDTO { FakeData.Operation.fistValue }
    override func createSecondValue() -> OperationDTO { FakeData.Operation.secondValue }
}
