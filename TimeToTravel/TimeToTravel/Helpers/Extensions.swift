//
//  Extensions.swift
//  TimeToTravel
//
//  Created by Sokolov on 17.10.2023.
//

import UIKit

extension String {
    func isValidCityCode() -> Bool {
        let codeRegex = "^[A-Za-z]{3}$"
        let codePredicate = NSPredicate(format: "SELF MATCHES %@", codeRegex)
        return codePredicate.evaluate(with: self)
    }
}


