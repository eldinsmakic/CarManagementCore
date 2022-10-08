//
//  File.swift
//  
//
//  Created by eldin smakic on 08/10/2022.
//

import Foundation
import Defaults

public struct MyBridge<Value: Codable>: DefaultsCodableBridge {}

extension DefaultsSerializable where Self: Codable {
    typealias Bridge = DefaultsCodableBridge
    typealias ArrayBridge = DefaultsCodableBridge
}
