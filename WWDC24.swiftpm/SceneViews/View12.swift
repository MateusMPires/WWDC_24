//
//  SwiftUIView.swift
//  
//
//  Created by Mateus Martins Pires on 22/02/24.
//

import SwiftUI
import SceneKit

struct View12: View {
    @State private var isEndAnimation: Bool = false
    
    @State private var changeBalloon: Bool = false
    
    // These variables are used on SceneView1 and SceneKitViewController to adjust some atributtes of SceneKitViewController
    @State var isRotatingEnabled: Bool? = .init(true)
    @State var isUserInteractionEnabled: Bool? = .init(false)
    @State var scene: SCNScene? = .init(named: "Pangea4Scene.scn")
    
    var body: some View {
        NavigationStack {
            VStack {
                HologramSpeaking(fullText1: "On this point, they would see earth on Ice Age!", fullText2: "", isEndAnimation: $isEndAnimation)
                
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
                        ArrowButton(destination: View13())
                    
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
    View12()
}
