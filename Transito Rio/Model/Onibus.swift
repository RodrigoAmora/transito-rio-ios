//
//  Onibus.swift
//  Transito Rio
//
//  Created by Rodrigo Amora on 29/11/23.
//

import Foundation
import CoreData

class Onibus: NSCoding, Decodable {
    
    // MARK: - Atributes
    var ordem: String = ""
    var latitude: String = ""
    var longitude: String = ""
    var linha: String = ""
    
    // MARK: - NSCoding
    func encode(with coder: NSCoder) {
        coder.encode(ordem, forKey: "ordem")
        coder.encode(latitude, forKey: "latitude")
        coder.encode(longitude, forKey: "longitude")
        coder.encode(linha, forKey: "linha")
    }
    
    required init?(coder: NSCoder) {
        ordem = coder.decodeObject(forKey: "ordem") as! String
        latitude = coder.decodeObject(forKey: "latitude") as! String
        longitude = coder.decodeObject(forKey: "longitude") as! String
        linha = coder.decodeObject(forKey: "linha") as! String
    }
}
