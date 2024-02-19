//
//  SwiftUIView.swift
//  
//
//  Created by Mateus Martins Pires on 30/01/24.
//

import SwiftUI
import SceneKit

struct SceneKitViewController: UIViewRepresentable {
    @Binding var scene: SCNScene?
    
    @Binding var isInteractionEnabled: Bool?
    
    @Binding var isRotationEnabled: Bool?
    
    func makeUIView(context: Context) -> some UIView {
        let view = SCNView()
        view.allowsCameraControl = isInteractionEnabled ?? false
        view.autoenablesDefaultLighting = true
        view.antialiasingMode = .multisampling2X
        view.scene = scene
        view.scene?.rootNode.rotation = SCNVector4(x: 0, y: 5, z: 0, w: 20)
        view.backgroundColor = .clear
        
        // Adicione a rotação contínua aqui, condicionada à variável booleana
        if isRotationEnabled ?? false {
            let rotation = SCNAction.rotateBy(x: 0, y: 2 * .pi, z: 0, duration: 25.0)
            let rotateForever = SCNAction.repeatForever(rotation)
            view.scene?.rootNode.runAction(rotateForever)
        }
        
        return view
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
}

//#Preview {
//    SceneKitViewController()
//}
