//
//  OnibusDelegate.swift
//  Transito Rio
//
//  Created by Rodrigo Amora on 30/11/23.
//

import Foundation

protocol OnibusDelegate {
    func populateMap(listaOnibus: [Onibus])
    func replaceAll(listaOnibus: [Onibus])
    func showError()
}
