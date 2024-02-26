//
//  SwiftUIView.swift
//  
//
//  Created by Mateus Martins Pires on 05/02/24.
//

import SwiftUI

struct ViewFinal: View {
    
    @State var isEndAnimation: Bool = false
    
    var body: some View {
        NavigationStack {
            VStack {
                
                Spacer()
                HologramSpeaking(fullText1: "Maybe no one has contacted us because, from where they live, Earth hasn't even formed yet.", fullText2: "", isEndAnimation: $isEndAnimation)
                Spacer()
                
                if isEndAnimation {
                    NavigationLink(destination: View1()) {
                        Text("Restart")
                            .foregroundStyle(.white)
                            .font(FontManager.customFont(font: .orbitron, fontSize: .regular))
                            .frame(maxWidth: .infinity, alignment: .bottomTrailing)
                            .padding(EdgeInsets(top: 0, leading: 0, bottom: 20, trailing: 60))
                        
                    }
                } else {
                    ArrowButton(destination: View5())
                        .hidden()
                }
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
