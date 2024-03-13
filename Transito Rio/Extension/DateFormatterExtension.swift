//
//  DateFormatterExtension.swift
//  Transito Rio
//
//  Created by Rodrigo Amora on 30/11/23.
//

import Foundation

extension DateFormatter {
    func capturarDataHoraAtual() -> String {
        self.dateFormat = "yyyy-dd-MM:HH:mm:ss"
        return self.string(from: Date())
    }
}
