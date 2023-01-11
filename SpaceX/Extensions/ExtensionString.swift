//
//  ExtensionString.swift
//  SpaceX
//
//  Created by Константин Кнор on 29.10.2022.
//

import Foundation

extension String {
    func shortСountry()-> String {
        switch self{
        case "Republic of the Marshall Islands":
           return "Маршалловы Острова"
        case "United States":
            return "США"
        default:
            return self
        }
    }
    
    func converterDate() -> String{
        let date = self.replacingOccurrences(of: "-", with: "")
        guard let dateInt = Int(date) else { return self }
        let day = dateInt % 100
        let month = dateInt % 10000 / 100
        let year = dateInt / 10000
        switch month {
        case 1:
            return "\(day) января \(year)"
        case 2:
            return "\(day) февраля \(year)"
        case 3:
            return "\(day) марта \(year)"
        case 4:
            return "\(day) апреля \(year)"
        case 5:
            return "\(day) мая \(year)"
        case 6:
            return "\(day) июня \(year)"
        case 7:
            return "\(day) июля \(year)"
        case 8:
            return "\(day) августа \(year)"
        case 9:
            return "\(day) сентября \(year)"
        case 10:
            return "\(day) октября \(year)"
        case 11:
            return "\(day) ноября \(year)"
        case 12:
            return "\(day) декабря \(year)"
        default:
            return self
        }
    }
    
    func deletingСharacters() -> String {
        let char = self.dropLast(14)
        return String(char)
    }
}
