//
//  File.swift
//  
//
//  Created by Mateus Martins Pires on 31/01/24.
//

import Foundation
import SwiftUI

extension UIColor {
    static var spaceBlue: UIColor {
        if let color = UIColor(named: "SpaceBlue") {
            return color
        } else {
            return .pink
        }
    }
}
