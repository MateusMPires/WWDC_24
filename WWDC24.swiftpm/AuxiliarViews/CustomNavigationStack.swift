//
//  File.swift
//  
//
//  Created by Mateus Martins Pires on 17/01/24.
//

import Foundation
import SwiftUI

struct CustomNavigationStack<Content>: View where Content: View {
    var content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        NavigationStack {
            content
                .navigationBarBackButtonHidden(true)
        }
    }
}
