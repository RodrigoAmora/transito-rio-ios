//
//  Resource.swift
//  Transito Rio
//
//  Created by Rodrigo Amora on 30/11/23.
//

import Foundation

class Resource<T> {
    
    var result: T?
    var errorCode: Int? = nil
    
    init(result: T? = [], errorCode: Int? = nil) {
        self.result = result
        self.errorCode = errorCode
    }
   
}
