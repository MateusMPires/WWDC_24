//
//  SwiftUIView.swift
//  
//
//  Created by Mateus Martins Pires on 04/02/24.
//

import SwiftUI

struct View11: View {
    
    @State var isEndAnimation: Bool = false
    
    var body: some View {
        NavigationStack {
            VStack {
                
                Spacer()
                HologramSpeaking(fullText1: "Maybe someone never contacted us because for THEM Earth hasn't even formed yet.", fullText2: "", isEndAnimation: $isEndAnimation)
                Spacer()
                
//                if isEndAnimation {
//                    NavigationLink(destination: View1()) {
//                        Text("Finish")
//                            .font(FontManager.customFont(font: .orbitron, fontSize: .regular))
//                    }
//                    .frame(maxWidth: .infinity, alignment: .bottomTrailing)
//                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 20, trailing: 60))
                //} else {
                    ArrowButton(destination: View5())
                        .hidden()
                //}
            }
            .background {
                Image("Background")
            }
        }
        .navigationBarBackButtonHidden()
    }
}

#Preview {
    View11()
}
