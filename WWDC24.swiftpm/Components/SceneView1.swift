//
//  SwiftUIView.swift
//  
//
//  Created by Mateus Martins Pires on 24/01/24.
//

import SwiftUI
import SceneKit

struct SceneView1: View {
    
    @State var scene: SCNScene? = .init(named: "EarthScene.scn")
    
    @State var isInteractionEnabled: Bool? = .init(true)

    @State var isRotationEnabled: Bool? = .init(false)
    
    var body: some View {
        VStack {
            SceneKitViewController(scene: $scene, isInteractionEnabled: $isInteractionEnabled, isRotationEnabled: $isRotationEnabled)
                .frame(height: 350)
                //.background(Color.blue)
                
        }
        .padding()
    }
}

//#Preview {
//    SceneView1()
//}
