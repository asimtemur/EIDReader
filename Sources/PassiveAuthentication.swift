//
//  PassiveAuthentication.swift
//  EIDReader
//
//  Created by Volkan SÖNMEZ on 6.04.2020.
//  Copyright © 2020 sonmez.volkan. All rights reserved.
//

import Foundation
import OpenSSL


public enum PassiveAuthenticationError: Error {
    case UnableToParseSODHashes(String)
    case InvalidDataGroupHash(String)
    case SODMissing(String)
}


extension PassiveAuthenticationError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .UnableToParseSODHashes(let reason):
            return NSLocalizedString("Unable to parse the SOD Datagroup hashes. \(reason)", comment: "UnableToParseSODHashes")
        case .InvalidDataGroupHash(let reason):
            return NSLocalizedString("DataGroup hash not present or didn't match  \(reason)!", comment: "InvalidDataGroupHash")
        case .SODMissing(let reason):
            return NSLocalizedString("DataGroup SOD not present or not read  \(reason)!", comment: "SODMissing")

        }
    }
}
