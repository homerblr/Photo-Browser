//
//  Binding.swift
//  Photo Browser
//
//  Created by Mikhail Kisly on 10.02.21.
//

import Foundation


class Box<T> {
    
    typealias Listener = (T) -> ()
    var listener: ((T) -> ())?
    var value: T {
        didSet {
            listener?(value)
        }
    }
    func bind(listener: @escaping Listener) {
        self.listener = listener
        listener(value)
    }
    
    init(_ value: T) {
        self.value = value
    }
    
}
