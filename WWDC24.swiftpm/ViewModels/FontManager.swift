//
//  File.swift
//  
//
//  Created by Mateus Martins Pires on 29/01/24.
//

import Foundation
import UIKit
import SwiftUI

class FontManager {
    
    enum FontStyle: String {
        case orbitron = "Orbitron-SemiBold"
        case roboto = "RobotoMono-Regular"
        
        var fileName: String {
            return rawValue
        }
    }
    
    enum FontSize: CGFloat {
        case title = 40
        case subtitle = 32
        case regular = 24
        case caption = 16
        
        var fontSizeText: CGFloat {
            return rawValue
        }
    }
    
    static func customFont(font: FontStyle, fontSize: FontSize) -> Font {

        if let url = Bundle.main.url(forResource: font.fileName, withExtension: "ttf"){
                CTFontManagerRegisterFontsForURL(url as CFURL, CTFontManagerScope.process, nil)

            let myFont = UIFont(name: font.fileName, size: fontSize.fontSizeText) ?? UIFont.systemFont(ofSize: 12)

                return Font(myFont)
            } else {

                return Font(UIFont.systemFont(ofSize: 12))
            }
        }
}
