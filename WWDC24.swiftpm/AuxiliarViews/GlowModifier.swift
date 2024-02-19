//
//  File.swift
//  
//
//  Created by Mateus Martins Pires on 01/02/24.
//

import SwiftUI

struct Glow: ViewModifier {
    func body(content: Content) -> some View {
        ZStack {
            content.blur(radius: 10)
        }
    }
}


extension View {
    func glow() -> some View {
        modifier(Glow())
    }
}
