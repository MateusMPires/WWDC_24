//
//  SwiftUIView.swift
//  
//
//  Created by Mateus Martins Pires on 05/02/24.
//

import SwiftUI
import SceneKit

struct View12: View {
    @State private var isEndAnimation: Bool = false
    
    @State private var changeBalloon: Bool = false
    
    // These variables are used on SceneView1 and SceneKitViewController to adjust some atributtes of SceneKitViewController
    @State var isRotatingEnabled: Bool? = .init(true)
    @State var isUserInteractionEnabled: Bool? = .init(false)
    @State var scene: SCNScene? = .init(named: "IceageUVGeoOriginScene.scn")
    
    var body: some View {
        NavigationStack {
            VStack {
                HologramSpeaking(fullText1: "So at 20 thousand light-years away, we would see Earth on Ice Age! ", fullText2: "And humans would already be inhabiting the planet.", isEndAnimation: $isEndAnimation)
                
                Spacer()
                
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
