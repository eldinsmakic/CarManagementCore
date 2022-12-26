//
//  File.swift
//  
//
//  Created by eldin smakic on 09/10/2022.
//

import Foundation
import Defaults

//public struct OperationDTO: Codable {
//    var idVoiture: UUID
//    var nom: String
//    var kilometrage: String
//    var cout: String
//    var date: Date
//    var typeOperation: OperationType
//}
//
//enum OperationType {
//    case upgrade
//    case repair
//    case maintenance
//}

public protocol OperationDTO: DefaultsSerializable, Codable, Equatable {
    var idVoiture: UUID { get }
    var nom: String { get }
    var kilometrage: String { get }
    var cout: String { get }
    var date: Date { get }
}

public struct CarburantDT: OperationDTO {
    public var idVoiture: UUID
    public var nom: String
    public var kilometrage: String
    public var cout: String
    public var date: Date
    public var quantité: Double
    public var prixAuLitre: Double
}

extension CarburantDT: DefaultsSerializable {
    public static let bridge = MyBridge<Self>()
}

public struct EntretienDTO: OperationDTO {
    public var idVoiture: UUID
    public var nom: String
    public var kilometrage: String
    public var cout: String
    public var date: Date
}

extension EntretienDTO: DefaultsSerializable {
    public static let bridge = MyBridge<Self>()
}

public struct RepartionDTO: OperationDTO {
    public var idVoiture: UUID
    public var nom: String
    public var kilometrage: String
    public var cout: String
    public var date: Date
}

extension RepartionDTO: DefaultsSerializable {
    public static let bridge = MyBridge<Self>()
}

public struct AmeliorationDTO: OperationDTO {
    public var idVoiture: UUID
    public var nom: String
    public var kilometrage: String
    public var cout: String
    public var date: Date
}

extension AmeliorationDTO: DefaultsSerializable {
    public static let bridge = MyBridge<Self>()
}
