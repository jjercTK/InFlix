//
//  FontHelper.swift
//  InFlix
//
//  Created by Juanjo on 12/2/16.
//  Copyright © 2016 Tektonlabs. All rights reserved.
//

import Foundation

import UIKit

struct FontHelper {
    
    enum FontType: String {
        case gravityLight = "Gravity-Light"
        case yanoneKaaffeesatzRegular = "YanoneKaffeesatz-Regular"
        case forgottenFuturistShadow = "ForgottenFuturistShadow"
    }
    
    static var title: UIFont {
        return UIFont(name: FontType.yanoneKaaffeesatzRegular.rawValue, size: 18) ?? UIFont.systemFont(ofSize: 18, weight: UIFontWeightBold)
    }
    
    static var text: UIFont {
        return UIFont(name: FontType.gravityLight.rawValue, size: 18) ?? UIFont.systemFont(ofSize: 18, weight: UIFontWeightBold)
    }
    
    static var head: UIFont {
        return UIFont(name: FontType.forgottenFuturistShadow.rawValue, size: 18) ?? UIFont.systemFont(ofSize: 18, weight: UIFontWeightBold)
    }
    
    static func verifyFonts() {
        
        for family: String in UIFont.familyNames
        {
            print("\(family)")
            for names: String in UIFont.fontNames(forFamilyName: family)
            {
                print("== \(names)")
            }
        }
        
    }

}
