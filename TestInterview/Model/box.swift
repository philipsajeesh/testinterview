//
//  box.swift
//  TestInterview
//
//  Created by Sajeesh Philip on 22/09/18.
//  Copyright © 2018 Sajeesh Philip. All rights reserved.
//

import UIKit

/// Binding using Boxing
class Box<T>{
    typealias Listener = (T) -> Void
    var listener: Listener?
    var value:T{
        didSet{
            listener?(value)
        }
    }
    init(_value:T){
        self.value = _value
        
    }
    func bind(listener:Listener?){
        self.listener = listener
        listener?(value)
    }
}
