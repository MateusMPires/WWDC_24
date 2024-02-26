//
//  SwiftUIView.swift
//  
//
//  Created by Mateus Martins Pires on 05/02/24.
//

import SwiftUI

struct View4: View {
    
    @State var isEndAnimation: Bool = false
    
    var body: some View {
        NavigationStack {
            VStack {
                
                Spacer()
                
                HologramSpeaking(fullText1: "If we could see Earth from other planets, then we would see it in the past.", fullText2: "", isEndAnimation: $isEndAnimation)
                
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
