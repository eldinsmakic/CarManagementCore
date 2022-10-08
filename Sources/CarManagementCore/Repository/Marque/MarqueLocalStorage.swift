//
//  File.swift
//  
//
//  Created by eldin smakic on 08/10/2022.
//

import Foundation
import Defaults
import Combine

public class MarqueLocalStorage: LocalStorageProtocol {
    
    public static var shared = MarqueLocalStorage()

    public let model: AnyPublisher<[MarqueDTO], Never>

    private var publisher = PassthroughSubject<[MarqueDTO], Never>()
    
    private init() {
        self.model = publisher.eraseToAnyPublisher()
    }

    func updateDate() {
        publisher.send(list)
    }

    public func fetch() {
        updateDate()
    }

    public func add(_ value: MarqueDTO) {
        var localList = list
        localList.append(value)
        list = localList
    
        updateDate()
    }

    public func remove(_ value: MarqueDTO) {
        var localList = list
        localList.removeAll { transaction in
            value == transaction
        }
        list = localList
    
        updateDate()
    }

    public func delete(at offsets: IndexSet) {
        var localList = list
        localList.remove(atOffsets: offsets)

        list = localList
    
        updateDate()
    }

    public func erase() {
        list = []

        updateDate()
    }

    private var list: [MarqueDTO] {
        get { Defaults[.marques] }
        set { Defaults[.marques] = newValue }
    }
}

extension Defaults.Keys {
    static let marques = Key<[MarqueDTO]>("marques", default: [])
}
