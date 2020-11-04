//
//  PassportModel.swift
//  EIDReader
//
//  Created by Volkan SÖNMEZ on 6.04.2020.
//  Copyright © 2020 sonmez.volkan. All rights reserved.
//

import Foundation

public class EIDModel {
    var documentNo: String
    var dateOfBirth: String
    var expiryDate: String
    
    public init(documentNo: String, dateOfBirth: Date, expiryDate: Date) {
        self.documentNo = documentNo
        
        let dateFormatter           = DateFormatter()
        dateFormatter.dateFormat    = "yyMMdd"
        
        self.dateOfBirth = dateFormatter.string(from: dateOfBirth)
        self.expiryDate = dateFormatter.string(from: expiryDate)
    }
    
    public init(documentNo: String, dateOfBirth: String, expiryDate: String) {
        self.documentNo = documentNo
        self.dateOfBirth = dateOfBirth
        self.expiryDate = expiryDate
    }
    
    public func getMRZKey() -> String {
        let documentNoChksum    = calcCheckSum(documentNo)
        let dateOfBirthChksum   = calcCheckSum(dateOfBirth)
        let expiryDateChksum    = calcCheckSum(expiryDate)
        
        let mrzKey = "\(documentNo)\(documentNoChksum)\(dateOfBirth)\(dateOfBirthChksum)\(expiryDate)\(expiryDateChksum)"
        
        return mrzKey
    }
    
    private func calcCheckSum( _ checkString : String ) -> Int {
        let characterDict  = ["0" : "0", "1" : "1", "2" : "2", "3" : "3", "4" : "4", "5" : "5", "6" : "6", "7" : "7", "8" : "8", "9" : "9", "<" : "0", " " : "0", "A" : "10", "B" : "11", "C" : "12", "D" : "13", "E" : "14", "F" : "15", "G" : "16", "H" : "17", "I" : "18", "J" : "19", "K" : "20", "L" : "21", "M" : "22", "N" : "23", "O" : "24", "P" : "25", "Q" : "26", "R" : "27", "S" : "28","T" : "29", "U" : "30", "V" : "31", "W" : "32", "X" : "33", "Y" : "34", "Z" : "35"]
        
        var sum = 0
        var m = 0
        let multipliers : [Int] = [7, 3, 1]
        for c in checkString {
            guard let lookup = characterDict["\(c)"],
                let number = Int(lookup) else { return 0 }
            let product = number * multipliers[m]
            sum += product
            m = (m+1) % 3
        }
        
        return (sum % 10)
    }
}
