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
        self.color = .green
        self.startAnimating()
        self.isHidden = false
        self.layer.cornerRadius = CGRectGetWidth(self.frame)/4.0
    }
    
    func hideActivityIndicatorView() {
        self.stopAnimating()
        self.isHidden = true
    }
}
