//
//  SwiftUIView.swift
//  
//
//  Created by Mateus Martins Pires on 05/02/24.
//

import SwiftUI

struct View2: View {
    
    @State var isEndAnimation = false

    var body: some View {
        NavigationStack {
            VStack {
                
                HologramSpeaking(fullText1: "The light from a star or planet travels across intergalactic distances to reach our eyes and telescopes.", fullText2: "", isEndAnimation: $isEndAnimation)
                    .padding()
                
                
                Spacer()
                
                HStack {
                    
                    // Planeta terra!! 🌎
                    // 👉🏻 Vou colocar meu planeta 3D bem aí!! ✅
                    // 👉🏻 Colocar animação dele rodando
                    // 👉🏻 Desabilitar User Interaction ✅
                    VStack(alignment: .center) {
                        Text("You")
                            .font(FontManager.customFont(font: .orbitron, fontSize: .regular))
                            .font(.title)
                        
                        SceneView1()
                            .frame(width: width * 0.28, height: height * 0.3)
                            //.background(Color.red)
                    }
                    //.background(Color.blue)
                    

                    Spacer()
                    
                    // Quando a animação do texto terminar, começa a animação da seta
//                    if isEndAnimation {
//                        MovingLightLine()
//                    }
                    
                    // Proxima Centauri Star!! ☀️
                    VStack(alignment: .trailing) {
                        
                        Text("Alpha Centauri Star")
                            .font(FontManager.customFont(font: .orbitron, fontSize: .regular))
                            .font(.title2)
                            .padding(.bottom, 50)
                        HStack {
                            if isEndAnimation {
                                MovingLightLine()
                            }
                            
                            Spacer()
                            Circle()
                                .frame(width: width * 0.12, height: height * 0.12)
                                .foregroundStyle(Color.yellow)
                                .glow()
                                .padding(.trailing, 60)
                        }
                        .frame(width: width * 0.5)
                        
                    }
                }
                .frame(width: width * 0.8)
                //.background(Color.green)
            
                Spacer()
                
                }
            .background(content: {
                Image("Background")
            })
            
            if isEndAnimation {
                ArrowButton(destination: View3())
            } else {
                ArrowButton(destination: View3())
                    .hidden()
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    View2()
}
