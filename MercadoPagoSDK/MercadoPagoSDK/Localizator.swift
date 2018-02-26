//
//  Localizator.swift
//  MercadoPagoSDK
//
//  Created by AUGUSTO COLLERONE ALFONSO on 22/2/18.
//  Copyright © 2018 MercadoPago. All rights reserved.
//

import Foundation

private class Localizator {
    
    static let sharedInstance = Localizator()
    
    lazy var localizableDictionary: NSDictionary! = {
        let bundle = MercadoPago.getBundle()
        
        if let path = bundle?.path(forResource: "poc_translations", ofType: "plist") {
            return NSDictionary(contentsOfFile: path)
        }
        fatalError("Localizable file NOT found")
    }()
    
    func localize(string: String) -> String {
        let languageID = MercadoPagoContext.getLanguage()
        let parentlanguageID = MercadoPagoContext.getParentLanguage()
        
        guard let localizedStringDictionary = localizableDictionary.value(forKey: string) as? NSDictionary, let localizedString = localizedStringDictionary.value(forKey: languageID) as? String else {
            
            
            let localizedStringDictionary = localizableDictionary.value(forKey: string) as? NSDictionary
            
            if let parentLocalizedString = localizedStringDictionary?.value(forKey: parentlanguageID) as? String {
                return parentLocalizedString
            }
            
            #if DEBUG
                assertionFailure("Missing translation for: \(string)")
            #endif
            
            return ""
        }
        
        return localizedString
    }
}

extension String {
    var localized_beta: String {
        return Localizator.sharedInstance.localize(string: self)
    }
}
