//
//  File.swift
//
//
//  Created by Mateus Martins Pires on 11/12/23.
//

import SpriteKit
import SwiftUI
import CoreMotion

class GameScene: SKScene, SKPhysicsContactDelegate {
    // Nodes
    let motionManager = CMMotionManager()
    var cameraNode: SKCameraNode?
    var cameraIndicator = SKShapeNode(circleOfRadius: 5)
    
    var bondaries = SKNode()
    
    // Cenário
    var cenario = SKSpriteNode(imageNamed: "Ceu.Teste")
    
    // View Models
    @ObservedObject var motionVM = CoreMotionViewModel()
    
    // Moviment
    var velocityX: CGFloat = 0.0
    var velocityY: CGFloat = 0.0
    
    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        print("eu si mato")
        setupCamera()
        motionManager.startDeviceMotionUpdates()
        
        // Cenario Code
        cenario.position.y = frame.origin.y
        cenario.position.x = frame.origin.x
        cenario.zPosition = -1
        addChild(cenario)
        
    }
    
//    func didBegin(_ contact: SKPhysicsContact) {
//        let bodyA = contact.bodyA.node?.name
//        let bodyB = contact.bodyB.node?.name
//      //  print("Contato entre player e cameraIndicator")
//        if (bodyA == "player" && bodyB == "cameraIndicator") || (bodyA == "cameraIndicator" && bodyB == "player") {
//            print("Contato entre player e cameraIndicator")
//        }
//    }
    
    func moveCamera(){
        velocityX = motionVM.rotationRate.x * 10
        velocityY = motionVM.rotationRate.y * 10
        // print("X: \(velocityX * 10)")
       // print("Y: \(velocityY * 10)")
        
        camera?.position.y -= velocityY
        camera?.position.x -= velocityX
    
    }
    
    func setupCamera() {
        cameraNode = SKCameraNode()
        self.camera = cameraNode
        self.addChild(cameraNode!)
        cameraNode?.zPosition = 0
        
//        // Camera bounds
        let cameraXBounds = frame.width / 2
        let cameraYBounds = frame.height / 2
//        // Definindo tamanho do cenário
//        let mapXSize = cenario.size.width
//        let mapYSize = cenario.size.height
//        // Coordenadas do centro do cenário
//         let centerX = mapXSize / 2
//         let centerY = mapYSize / 2
//
//         // Place camera
       cameraNode?.position = CGPoint(x: cenario.frame.midX, y: cenario.frame.midY)
        
        // Adiciona um ponto vermelho como representação visual da câmera
        cameraIndicator.fillColor = .red
        cameraIndicator.strokeColor = .clear
        cameraIndicator.physicsBody = SKPhysicsBody(circleOfRadius: 5)
        cameraIndicator.physicsBody?.isDynamic = false
        cameraIndicator.physicsBody?.allowsRotation = false
        cameraIndicator.physicsBody?.affectedByGravity = false
        cameraIndicator.name = "cameraIndicator"
        //cameraIndicator.physicsBody?.categoryBitMask = CategoryCollision.cameraIndicator.rawValue
        //cameraIndicator.physicsBody?.contactTestBitMask = CategoryCollision.asteroid.rawValue
        cameraIndicator.zPosition = 2
        cameraNode?.addChild(cameraIndicator)
    }
    
    
    
    override func update(_ currentTime: TimeInterval) {
        // Lógica de atualização do jogo, se necessário
     //   camera?.position = player.position

        moveCamera()
    }
}
