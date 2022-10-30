//
//  extentions.swift
//  SpaceX
//
//  Created by Константин Кнор on 29.10.2022.
//

import Foundation

extension Int {
    
    func millionsOfDollars() -> String {
        //90 000 000
       return "$\(self / 1000000)млн"
        }
    
}
