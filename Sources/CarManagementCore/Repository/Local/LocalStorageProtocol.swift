//
//  File.swift
//  
//
//  Created by eldin smakic on 08/10/2022.
//

import Foundation

import Combine
import Foundation

public protocol LocalStorageProtocol {
    associatedtype Value: Equatable

    var model: AnyPublisher<[Value], Never> { get }

    func add(_ value: Value)
    func fetch()
    func remove(_ value: Value)
    func delete(at offsets: IndexSet)
    func erase()
}
