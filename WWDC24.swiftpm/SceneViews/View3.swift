//
//  SwiftUIView.swift
//  
//
//  Created by Mateus Martins Pires on 18/01/24.
//

import SwiftUI

struct View3: View {
    
    @State var isEndAnimation: Bool = false
    
    var body: some View {
        
        NavigationStack {
            VStack {
                
                HologramSpeaking(fullText1: "One light-year  is the distance that the light travels in one year.", fullText2: " That's 6 trillion miles!", isEndAnimation: $isEndAnimation)
                
                
                Spacer()
                
                VStack {
                    HStack {
                        
                        VStack(alignment: .center) {
                            Text("You")
                                .font(FontManager.customFont(font: .orbitron, fontSize: .regular))
                                .font(.title)
                            
                            SceneView1()
                                .frame(width: width * 0.28, height: height * 0.3)
                        }
                        
                        Spacer()
                        
                        VStack(alignment: .trailing) {
                            
                            Text("Alpha Centauri Star")
                                .font(FontManager.customFont(font: .orbitron, fontSize: .regular))
                                .font(.title2)
                                .padding(.bottom, 50)
                            HStack {
                                //if isEndAnimation {
                                    MovingLightLine()
                                //}
                                
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
                    .frame(width: width * 0.8, height: width * 0.3)
                    
                    Spacer()
                    VStack {
                        
                        Image("LineView03")
                            .resizable()
                            .scaledToFit()
                            .frame(width: width * 0.63)
                            .padding()
                        
                        Text("4.2 light-years")
                            .font(FontManager.customFont(font: .orbitron, fontSize: .regular))
                            .font(.title)
                        Spacer()
                        Text("Nearly 24 trillion miles!")
                            .font(FontManager.customFont(font: .orbitron, fontSize: .caption))
                    }
                    .frame(width: width * 0.63)
                    .padding(EdgeInsets(top: 0, leading: 30, bottom: 0, trailing: 0))
                }
                .frame(height: width * 0.45)
            }
            .background(content: {
                Image("Background")
            })
            
            if isEndAnimation {
                ArrowButton(destination: View4())
            } else {
                ArrowButton(destination: View4())
                    .hidden()
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    View3()
}
