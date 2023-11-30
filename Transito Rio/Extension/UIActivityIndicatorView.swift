//
//  UIActivityIndicatorView.swift
//  Transito Rio
//
//  Created by Rodrigo Amora on 30/11/23.
//

import Foundation
import UIKit

extension UIActivityIndicatorView {
    func configureActivityIndicatorView() {
        self.backgroundColor = .gray
        self.layer.cornerRadius = CGRectGetWidth(self.frame)/4.0
        self.color = .blue
        self.isHidden = false
    }
    
    func hideActivityIndicatorView() {
        self.isHidden = true
    }
}
