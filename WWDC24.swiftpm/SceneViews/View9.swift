//
//  SwiftUIView.swift
//  
//
//  Created by Mateus Martins Pires on 01/02/24.
//

import SwiftUI
import SceneKit

enum HologramTextState {
    case state1
    case state2
}

struct View9: View {
    
    @State private var isEndAnimation: Bool = false
    
    @State private var changeBalloon: Bool = false
    
    // These variables are used on SceneView1 and SceneKitViewController to adjust some atributtes of SceneKitViewController
    @State var isRotatingEnabled: Bool? = .init(true)
    @State var isUserInteractionEnabled: Bool? = .init(false)
    @State var scene: SCNScene? = .init(named: "Pangea4Scene.scn")
    
    var body: some View {
        NavigationStack {
            VStack {
                if changeBalloon {
                    HologramSpeaking(fullText1: "It appears that they would see our Earth on Pagea! ", fullText2: "It means that for them, dinosaurs are still alive.", isEndAnimation: $isEndAnimation)
                } else {
                    HologramSpeaking(fullText1: "Wow! So that's how aliens in NCG-015 exoplanet would see Earth? ", fullText2: "That`s awesome.", isEndAnimation: $isEndAnimation)
                }
                
                Spacer()
                
                // ⚠️ Fazer um zoomRing específico aqui
                ZoomView().zoomRing
                    .scaleEffect(0.9)
                    .overlay {
                        SceneKitViewController(scene: $scene, isInteractionEnabled: $isUserInteractionEnabled, isRotationEnabled: $isRotatingEnabled)
                            .frame(height: height * 0.4)
                    }
                
                Spacer()
                
                if isEndAnimation {
                    if changeBalloon {
                        ArrowButton(destination: View10())
                    } else {
                        Button(action: {
                            changeBalloon = true
                        }, label: {
                            Image("Arrow")
                                .resizable()
                                .frame(width: width * 0.06, height: width * 0.03)
                                .frame(maxWidth: .infinity, alignment: .bottomTrailing)
                                .padding(EdgeInsets(top: 0, leading: 0, bottom: 20, trailing: 60))
                        })
                    }
                } else {
                    ArrowButton(destination: View5())
                        .hidden()
                }
            }
            .background(content: {
                Image("Background")
            })
        }
        .navigationBarBackButtonHidden()
    }
}

#Preview {
    View9()
}
