//
//  SwiftUIView.swift
//  
//
//  Created by Mateus Martins Pires on 05/02/24.
//

import SwiftUI
import SceneKit

struct SceneView1: View {
    
    @State var scene: SCNScene? = .init(named: "EarthNormalOriginScene.scn")
    
    @State var isInteractionEnabled: Bool? = .init(true)

    @State var isRotationEnabled: Bool? = .init(true)
    
    var body: some View {
        VStack {
            SceneKitViewController(scene: $scene, isInteractionEnabled: $isInteractionEnabled, isRotationEnabled: $isRotationEnabled)
                .frame(height: 350)                
        }
        .padding()
    }
}

