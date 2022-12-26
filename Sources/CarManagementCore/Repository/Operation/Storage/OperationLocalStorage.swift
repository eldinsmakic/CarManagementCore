//
//  MarqueLocalStorage.swift
//  
//
//  Created by eldin smakic on 19/10/2022.
//
//
//import Foundation
//import Defaults
//import Combine
//
//public class OperationLocalStorage {
//
//    public static var shared = OperationLocalStorage()
//
//    private var list: [any OperationDTO] {
//        get { Defaults[.operations] }
//        set { Defaults[.operations] = newValue }
//    }
//
//    private init() {}
//
//    public func add(_ value: any CarManagementCore.OperationDTO) async throws -> any CarManagementCore.OperationDTO {
//        list.append(value)
//        return value
//    }
//
//    public func update(_ value: any CarManagementCore.OperationDTO) async throws -> any CarManagementCore.OperationDTO {
//        return value
//    }
//
//    public func remove(_ value: any CarManagementCore.OperationDTO) async throws -> any CarManagementCore.OperationDTO {
//        list.removeAll { voiture in
//            voiture == value
//        }
//        return value
//    }
//
//    public func fetch() async throws -> [any CarManagementCore.OperationDTO] {
//        return list
//    }
//
//    public func erase() async throws {
//        list = []
//    }
//}
//
//extension Defaults.Keys {
//    static let operations = Key<[any OperationDTO]>("operations", default: [])
//}
//
