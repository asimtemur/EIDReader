//
//  EIDReader+Extension.swift
//  EIDReader
//
//  Created by Asım Temür on 9.11.2020.
//  Copyright © 2020 asim.temur All rights reserved.
//

import Foundation

@available(iOS 13, *)
public extension EIDReader {
        
    private func handleProgress(percentualProgress: Int) -> String {
        let p = (percentualProgress / 20)
        let full = String(repeating: "🟢 ", count: p)
        let empty = String(repeating: "⚪️ ", count: 5-p)
        return "\(full)\(empty)"
    }
    
    private func getDisplayMessage(displayMessage: NFCViewDisplayMessage) -> String? {
        switch displayMessage {
            case .requestPresentPassport:
                return "Lütfen kimliğinizi telefonunuzun üst kısmına yakın tutunuz."
            case .authenticatingWithPassport(let progress):
                let progressString = handleProgress(percentualProgress: progress)
                return "Kimlik doğrulanıyor.....\n\n\(progressString)"
            case .readingDataGroupProgress(let dataGroup, let progress):
                let progressString = handleProgress(percentualProgress: progress)
                return "Lütfen kartınızı hareket ettirmeyin.\n\n\(progressString)"
            case .error(let tagError):
                switch tagError {
                case TagError.TagNotValid:
                    return "Lütfen kimlik kartınızı okutunuz."
                case TagError.MoreThanOneTagFound:
                    return "1'den fazla NFC Tag bulundu, lütfen 1 tane NFC Tag yaklaştırınız."
                case TagError.ConnectionError:
                    return "Bağlantı hatası, lütfen tekrar deneyiniz."
                case TagError.InvalidMRZKey:
                    return "MRZ Key geçerli değil."
                case TagError.ResponseError(let description):
                   return convertLocaziedDesription(description: description)
                default:
                    return "Üzgünüm Kimlik okunurken bir hata ile karşılaşıldı, lütfen tekrar deneyiniz"
                }
            case .successfulRead:
                return "Kimlik başarılı şekilde okundu."
        }
    }
    
    private func convertLocaziedDesription(description: (String, UInt8, UInt8)) -> String {
        let errorMessage = description.0
        if errorMessage.contains("Security status not satisfied") {
            return "Lütfen girilen kimlik bilgilerini kontrol ederek tekrar deneyiniz."
        } else if errorMessage.contains("Tag connection lost") {
            return "Lütfen kartı hareket ettirmeden tekrar okutunuz."
        }
        return "Üzgünüm Kimlik okunurken bir hata ile karşılaşıldı, lütfen tekrar deneyiniz."
    }
    
    private func setPemFile() {
        if let pemUrl = Bundle.main.url(forResource: "masterList", withExtension: ".pem") {
            self.setMasterListURL(pemUrl)
        }
    }
    
    private func getTags(tags: [DataGroupId]?) -> [DataGroupId] {
        if tags == nil || tags!.count == 0 {
            return  [ .COM, .DG1, .DG3, .DG4, .DG5, .DG6, .DG8, .DG9, .DG10, .DG11, .DG12, .DG13, .DG14, .DG15, .DG16, .SOD ]
        }
        return tags!
    }
    
    private func getAllTags() -> [DataGroupId] {
        return  [ .COM, .DG1, .DG2, .DG3, .DG4, .DG5, .DG6, .DG7, .DG8, .DG9, .DG10, .DG11, .DG12, .DG13, .DG14, .DG15, .DG16, .SOD ]
    }
    
    public func readEIDAllTag(documentNo: String,
                              dateOfBirth: Date, expiryDate: Date,
                              completed: @escaping (NFCIdentityModel?, TagError?) -> (),
                              onSessionTimeOut: (() -> Void)? = nil) {
        readEID(documentNo: documentNo, dateOfBirth: dateOfBirth, expiryDate: expiryDate, tags: getAllTags(), completed: completed, onSessionTimeOut: onSessionTimeOut)
    }
    
    public func readEIDAllTag(with mrzKey: String,
                              completed: @escaping (NFCIdentityModel?, TagError?) -> (),
                              onSessionTimeOut: (() -> Void)? = nil) {
        readEID(mrzKey: mrzKey, tags: getAllTags(), skipSecureElements: true, customDisplayMessage: { [weak self] (message) -> String? in
            return self?.getDisplayMessage(displayMessage: message)
        }, completed: completed, onSessionTimeOut: onSessionTimeOut)
    }
    
    public func readEID(documentNo: String,
                        dateOfBirth: Date, expiryDate: Date,
                        tags: [DataGroupId] = [],
                        skipSecureElements: Bool = true,
                        completed: @escaping (NFCIdentityModel?, TagError?) -> (),
                        onSessionTimeOut: (() -> Void)? = nil) {
        
        setPemFile()
        
        let eidModel = EIDModel(documentNo: documentNo, dateOfBirth: dateOfBirth, expiryDate: expiryDate)
        
        readEID(mrzKey: eidModel.getMRZKey(), tags: getTags(tags: tags), skipSecureElements: skipSecureElements, customDisplayMessage: { [weak self] (message) -> String? in
            return self?.getDisplayMessage(displayMessage: message)
        }, completed: completed, onSessionTimeOut: onSessionTimeOut)
    }
    
    public func readEID(with mrzKey: String,
                        tags: [DataGroupId] = [],
                        skipSecureElements: Bool = true,
                        completed: @escaping (NFCIdentityModel?, TagError?) -> (),
                        onSessionTimeOut: (() -> Void)? = nil) {
        setPemFile()
        
        readEID(mrzKey: mrzKey, tags: getTags(tags: tags), skipSecureElements: true, customDisplayMessage: { [weak self] (message) -> String? in
            return self?.getDisplayMessage(displayMessage: message)
        }, completed: completed, onSessionTimeOut: onSessionTimeOut)
    }
}

