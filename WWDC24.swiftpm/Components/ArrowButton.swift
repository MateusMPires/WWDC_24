//
//  SwiftUIView.swift
//  
//
//  Created by Mateus Martins Pires on 05/02/24.
//

import SwiftUI

struct ArrowButton<Content: View>: View {
    var destination: Content
    
    var body: some View {
        NavigationLink(destination: destination) {
            Image("Arrow")
                .resizable()
                .frame(width: width * 0.06, height: width * 0.03)
                .frame(maxWidth: .infinity, alignment: .bottomTrailing)
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 20, trailing: 60))
        }
    }
}

#Preview {
    ArrowButton(destination: View2())
}


