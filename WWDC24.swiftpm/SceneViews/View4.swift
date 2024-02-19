//
//  SwiftUIView.swift
//  
//
//  Created by Mateus Martins Pires on 23/01/24.
//

import SwiftUI

struct View4: View {
    
    @State var isEndAnimation: Bool = false
    
    var body: some View {
        NavigationStack {
            VStack {
                
                Spacer()
                
                HologramSpeaking(fullText1: "This light effect would be the same for aliens living in other planets.", fullText2: "", isEndAnimation: $isEndAnimation)
                
                Spacer()
                
                if isEndAnimation {
                    ArrowButton(destination: View5())
                } else {
                    ArrowButton(destination: View5())
                        .hidden()
                }
            }
            .background(content: {
                Image("Background")
            })
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    View4()
}
