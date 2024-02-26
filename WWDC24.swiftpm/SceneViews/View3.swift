//
//  SwiftUIView.swift
//  
//
//  Created by Mateus Martins Pires on 05/02/24.
//

import SwiftUI

struct View3: View {
    
    @State var isEndAnimation: Bool = false
    
    var body: some View {
        
        NavigationStack {
            VStack {
                
                HologramSpeaking(fullText1: "One light-year is the distance that the light travels in one year.", fullText2: " This means we are seeing an object as it was one year ago.", isEndAnimation: $isEndAnimation)
                
                
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
                                    .hidden()
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
                        Spacer()
                        Text("4 light-years away")
                            .font(FontManager.customFont(font: .orbitron, fontSize: .regular))
                            .font(.title)
                        Text("4 years in the past")
                            .font(FontManager.customFont(font: .roboto, fontSize: .caption))
                            .padding(.vertical, 1)
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
