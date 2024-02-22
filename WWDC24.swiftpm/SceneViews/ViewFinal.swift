//
//  SwiftUIView.swift
//  
//
//  Created by Mateus Martins Pires on 04/02/24.
//

import SwiftUI

struct ViewFinal: View {
    
    @State var isEndAnimation: Bool = false
    
    var body: some View {
        NavigationStack {
            VStack {
                
                Spacer()
                HologramSpeaking(fullText1: "Maybe someone never contacted us because for THEM Earth hasn't even formed yet.", fullText2: "", isEndAnimation: $isEndAnimation)
                Spacer()
                
                    ArrowButton(destination: View5())
                        .hidden()
            }
            .background {
                Image("Background")
            }
        }
        .navigationBarBackButtonHidden()
    }
}

#Preview {
    ViewFinal()
}
