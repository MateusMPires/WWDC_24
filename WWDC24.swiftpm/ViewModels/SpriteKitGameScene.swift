//: A SpriteKit based Playground

//import PlaygroundSupport


import SpriteKit
import SwiftUI
import CoreMotion
import SceneKit


class SpriteKitGameScene: SKScene, SKPhysicsContactDelegate, ObservableObject {
    
    // BACKGROUND
    private var starsBackground = SKSpriteNode(imageNamed: "Space") // This is my background
    
    // CAMERA
    private var cameraNode: SKCameraNode?
    private var cameraIndicator = SKSpriteNode(imageNamed: "Scope")
    
    // EARTH
    private var earthNode = EarthNode()
    private var earth = SK3DNode() // This is my Earth
    
    private var nearestAsteroid: EarthNode?
    
    // PROGRESS BAR
    private let progressBar = ProgressBar()
    private let pointerBox = SKSpriteNode(imageNamed: "PointerBox")
    private let pointer = SKSpriteNode(imageNamed: "PointerSprite")
    
    // COUNT
    private let countLabel = SKLabelNode()
    private let counterBG = SKSpriteNode(imageNamed: "Counter")
    private let counterImage = SKSpriteNode(imageNamed: "Asteroid_5")
    private let detectLabel = SKLabelNode(text: "keep pointed")
    
    // TUTORIAL
    private let tutorialLabel = SKLabelNode(text: "Hello, welcome to asteroid hunting\n My name is João and I will help you")
    private let tutorialiPad = SKSpriteNode(imageNamed: "iPadSprite_frame1")
    private let tutorialArrow = SKSpriteNode(imageNamed: "tutorialArrowSprite")
    private let tutorialDialog: [String] = ["Hello, welcome to asteroid hunting\n My name is João and I will help you", "Move the iPad to move the telescope", "Center your aim on the asteroids to identify them"]
    private var tutorialIndex: Int = 0
    private var isPresentingTutotial: Bool = true
    
    private var isProgressOnScene: Bool = false
    var progressTimer: Timer?
    
    // View Models
    @ObservedObject private var motionVM = CoreMotionViewModel()
    @Published var changeScene: Bool = false
    
    // Moviment
    private var velocityX: CGFloat = 0.0
    private var velocityY: CGFloat = 0.0
    
    // time on scene
    private var timeOnScene: Timer?
    
    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        
        // Cenario Code
        starsBackground.zPosition = -1
        addChild(starsBackground)
        
        // Camera
        setupCamera()
        
        // Creating and positioning Earth.scn
        create3DEarth()
        
        // ProgressBar
        //progressBar.name = "circular"
        // Pointer
//        if AsteroidCount.count > 0 {
//            addPointerWithTime()
//        }
        // Label
        //countAsteroids()
        
        // Tutorial
        // tutorialScene()
//        if AsteroidCount.count < 1 {
//            addTutorial()
//        }
        // Font
        //customFont()
    }
    
    override func update(_ currentTime: TimeInterval) {
        moveCamera()
        detectAsteroid(earthNode: earth)
        if  pointer.parent != nil && !AsteroidCount.asteroids.isEmpty {
            // verify if pointer is present on scene an has asteroids do hunt
            rotatePointer(target: AsteroidCount.asteroids[0])
        }
    }
    
    //MARK: My Functions --
    
    // This function creates our 3D Earth in SpriteKit
    func create3DEarth() {
        let sceneKitEarth = SCNScene(named: "Pangea4Scene.scn")
        
        earth.scnScene = sceneKitEarth
        
        // Positioned at the center of View
        earth.position = CGPoint(x: frame.midX, y: frame.midY)
        
        self.addChild(earth)
    }
    
    func setupCamera() {
        cameraNode = SKCameraNode()
        self.camera = cameraNode
        self.addChild(cameraNode!)
        cameraNode?.zPosition = 2
        
        
        // Add a scope to guide
        cameraIndicator.name = "cameraIndicator"
        cameraIndicator.zPosition = 2
        //cameraNode?.addChild(cameraIndicator)
        addChild(cameraIndicator)
        
        // Map limit - constraints
        let cameraWidthBounds = self.frame.width / 2
        let cameraHeightBounds = self.frame.height / 2
        
        // Converter os limites globais para o sistema de coordenadas local da cena
        let bounds = self.calculateAccumulatedFrame()
        let widthBounds = bounds.width / 2 - cameraWidthBounds
        let heightBounds = bounds.height / 2 - cameraHeightBounds
        
        let cameraWidthConstraint = SKConstraint.positionX(SKRange(lowerLimit: -widthBounds, upperLimit: widthBounds))
        let cameraHeightConstraint = SKConstraint.positionY(SKRange(lowerLimit: -heightBounds, upperLimit: heightBounds))
        
        self.camera?.constraints = [cameraWidthConstraint, cameraHeightConstraint]
        cameraIndicator.constraints = [cameraWidthConstraint, cameraHeightConstraint]
    }
    
    func moveCamera(){
        velocityX = motionVM.rotationRate.x * 7
        velocityY = motionVM.rotationRate.y * 7
        
        camera?.position.y -= velocityY
        camera?.position.x -= velocityX
        
        cameraIndicator.position.y -= velocityY
        cameraIndicator.position.x -= velocityX
        
    }
    
    func getRandomPosition() -> CGPoint {
        // obtain scene size
        let sceneWidth = size.width
        let sceneHeight = size.height
        
        // get random positions
        let randomX = CGFloat.random(in: 0..<sceneWidth)
        let randomY = CGFloat.random(in: 0..<sceneHeight)
        
        return CGPoint(x: randomX, y: randomY)
    }
    
    // find a new asteroid func
    func detectAsteroid(earthNode: SK3DNode){
        if let earth = earthNode as? SK3DNode { // AQUI TEM QUE SER NOSSA TERRA
            let dx = (cameraIndicator.position.x) - earth.position.x
            let dy = (cameraIndicator.position.y) - earth.position.y
            let distanceSquared = dx * dx + dy * dy
            let detectionRange:CGFloat = 70 * 70
            
            // check if the scope is in the asteroid range
            if distanceSquared <= detectionRange {
                // checking if the node has already been removed from the scene
                pointer.zRotation += 10
                if isProgressOnScene == false {
                    // change the refenrence of nearest asteroid to know if player find an asteroid
                        //nearestAsteroid = asteroid
                    // add progressBar to scene
                    cameraNode?.addChild(progressBar)
                    isProgressOnScene = true
                    self.progressBar.progress = 1   // Start progress
                    print("\(progressBar.progress)\n")
                }
                
                // calling timer to increase the variable every second
                if progressTimer == nil {
                    progressTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
                        if self.progressBar.progress >= 5 || self.isProgressOnScene == false{
                            timer.invalidate()
                            self.progressTimer = nil  // Invalidates the timer and sets it to nil to avoid cyclic retention
                            self.progressBar.progress = 0
                        } else {
                            self.progressBar.progress += 1
                            print(self.progressBar.progress)
                        }
                    }
                }
            } else {
                if earth == nearestAsteroid {
                    if isProgressOnScene == true {
                        progressBar.removeFromParent()
                        isProgressOnScene = false
                    }
                    progressBar.progress = 0 // deinit progress value
                }
            }
            if progressBar.completeProgress ==  true && earth == nearestAsteroid {
                //AsteroidCount.count += 1
                //AsteroidCount.asteroids.removeAll { $0 == asteroid }
                self.removeAllChildren() // evit problems
                self.changeScene = true
            }
        }
    }
    
//    func detectAllAsteroids() {
//        // using ateroids appendeds on static array
//        let allAsteroids = AsteroidCount.asteroids
//        for asteroid in allAsteroids {
//            detectAsteroid(asteroid: asteroid)
//        }
//    }
    
    func addPointer() {

        // BackGround
        pointerBox.zPosition = 90
        pointerBox.alpha = 0.0
        // Arrow - pointer
        pointer.zPosition = 100
        // Animation
        pointerBox.run(.fadeAlpha(to: 0.7, duration: 0.3))
        // Add Nodes
        pointerBox.addChild(pointer)
        cameraNode?.addChild(pointerBox)
        var scaleWidth: CGFloat = 0
        var scaleHeight: CGFloat = 0
        var tipScopePosition: CGPoint = CGPoint.zero
        // Poistion and Scale based on Screen Size
        if self.size.width >= 1330 {
            tipScopePosition = CGPoint(x: .zero, y: -size.height * 0.35)
        } else if self.size.width >= 1100 {
            scaleWidth = 180
            scaleHeight = 180
            tipScopePosition = CGPoint(x: .zero, y: -size.height * 0.35)
        }
        pointerBox.position = tipScopePosition
        // Set the desired size
        let desiredSize = CGSize(width: scaleWidth, height: scaleHeight)
        // Calculate scale ratios to fit the image to the desired size
        let originalSize = pointerBox.size
        let scaleX = desiredSize.width / originalSize.width
        let scaleY = desiredSize.height / originalSize.height
        // Apply the minimum scale to fit the image to the desired size without distortion
        let minScale = min(scaleX, scaleY)
        // Only Scale if isnt 12 polegadas
        if self.size.width <= 1330 {
            pointerBox.scale(to: CGSize(width: originalSize.width * minScale, height: originalSize.height * minScale))
           // pointer.scale(to: CGSize(width: originalSize.width * minScale, height: originalSize.height * minScale))
            
        }
        
    }
    
    func rotatePointer(target: SKNode) {
        // using camera by referece because pointer dont move, only camera
        let dx = target.position.x - (camera?.position.x ?? 0)
        let dy = target.position.y - (camera?.position.y ?? 0)
        let angle = atan2(dy, dx)
        let distance = hypot(dx, dy)
        // rodar if perto and apontar if longe
        if distance <= 10 * 10 {
            pointer.zRotation += 0.0001
        } else {
            pointer.zRotation = angle
        }
    }
    
    func addPointerWithTime() {
        // Start a timer so know if player needs help to find an asteroid
        var time: Int = 0
        timeOnScene = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            if time == 10 {
                self.addPointer()
                timer.invalidate()
            }
            time += 1
            print("timer rolando a cena \(time)")
        }
    }
    
//    func countAsteroids() {
//        // label count
//        let numberOfAsteroids: Int = 3
//        countLabel.text = "\(AsteroidCount.count)/\(numberOfAsteroids)"
//        countLabel.fontName = "joystix"
//        // Positions and add to scene
//        counterBG.position = CGPoint.zero
//        counterBG.position.y = frame.height * 0.42
//        cameraNode?.addChild(counterBG)
//        
//        countLabel.position = CGPoint.zero
//        countLabel.verticalAlignmentMode = .center
//        countLabel.position.x = -30
//        counterBG.addChild(countLabel)
//        
//        counterImage.position = CGPoint(x: .zero + 60, y: .zero + 5)
//        counterBG.addChild(counterImage)
//        
//    }
    
    // show tutorial
    func tutorialScene() {
        tutorialLabel.text = tutorialDialog[tutorialIndex]
        tutorialiPad.name = "tutorialFrame"
        tutorialiPad.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        tutorialiPad.position = CGPoint(x: 0, y: -size.height / 2 + 80)
        addChild(tutorialiPad)
        tutorialLabel.position = CGPoint(x: 0, y: 0)
        tutorialLabel.fontColor = .black
   
    }
    
    func attTutorialScene() {
        tutorialIndex += 1
        let fadeIn = SKAction.fadeIn(withDuration: 0.3)
        let fadeOut = SKAction.fadeOut(withDuration: 0.3)
        // last text close frame - all transitions with animation
     
        if tutorialIndex < 3 {
            let attLabel = SKAction.run {
                self.tutorialLabel.text = self.tutorialDialog[self.tutorialIndex]
            }
            let sequence = SKAction.sequence([fadeOut, attLabel, fadeIn])
            tutorialLabel.run(sequence)
            
        } else {
            let removeAction = SKAction.run {
                self.tutorialiPad.removeAllActions()
            }
            let sequence = SKAction.sequence([fadeOut, removeAction])
            tutorialiPad.run(sequence)
            // add pointer when ends text
            addPointer()
            
        }
    }
    
    func addTutorial() {
        let tutorialFrame = SKShapeNode(rectOf: CGSize(width: frame.width, height: frame.height))
        tutorialFrame.fillColor = .white
        tutorialFrame.alpha = 0
        tutorialFrame.zPosition = 100
        cameraNode?.addChild(tutorialFrame)
        self.counterBG.alpha = 0
        self.cameraIndicator.alpha = 0
        // add asset tutorial
        tutorialiPad.zPosition = 110
        tutorialArrow.zPosition = 110
        tutorialLabel.zPosition = 110
        // Animate ipad
        let moveiPad = [SKTexture(imageNamed: "iPadSprite_frame1"),
                        SKTexture(imageNamed: "iPadSprite_frame2"),
                        SKTexture(imageNamed: "iPadSprite_frame1"),
                        SKTexture(imageNamed: "iPadSprite_frame3")]
        tutorialiPad.run(.repeatForever(.animate(with: moveiPad, timePerFrame: 0.3)))
        tutorialLabel.text = "Move iPad to Explore"
        tutorialLabel.fontName = "joystix"
        tutorialLabel.fontColor = .black
        // Position
        tutorialiPad.position = CGPoint(x: CGFloat.zero, y: CGFloat.zero)
        tutorialLabel.position = CGPoint(x: CGFloat.zero, y: 280)
        tutorialArrow.position = CGPoint(x: CGFloat.zero + 20, y: -280)
        // Add scene
        cameraNode?.addChild(tutorialLabel)
        cameraNode?.addChild(tutorialiPad)
        cameraNode?.addChild(tutorialArrow)
        
        // Start Animation
        let fadeAlphaAction = SKAction.fadeAlpha(to: 0.4, duration: 0.3)
        let fadeOut = SKAction.fadeOut(withDuration: 0.3)
        let wait = SKAction.wait(forDuration: 3)
        let endTutorial = SKAction.run {
            self.isPresentingTutotial = false
            // Add pointer to help player
            self.addPointer()
            // Add label tips
            self.addTips()
            // add Counter e Scope
            self.cameraIndicator.run(.fadeIn(withDuration: 0.3))
            self.counterBG.run(.fadeIn(withDuration: 0.3))
            
            
        }
        let moveAction = SKAction.sequence([
            SKAction.moveTo(x: 10, duration: 0.3),
            SKAction.moveTo(x: tutorialArrow.position.x, duration: 0.3),
            SKAction.moveTo(x: -10, duration: 0.3),
            SKAction.moveTo(x: tutorialArrow.position.x, duration: 0.3),
            SKAction.moveTo(y: tutorialArrow.position.y + 20, duration: 0.3),
            SKAction.moveTo(y: tutorialArrow.position.y, duration: 0.3),
            SKAction.moveTo(y: tutorialArrow.position.y - 20, duration: 0.3),
            SKAction.moveTo(y: tutorialArrow.position.y, duration: 0.3)
                                           ])
        let sequence = SKAction.sequence([fadeAlphaAction, wait, fadeOut, endTutorial])
        let sequenceImages = SKAction.sequence([wait, fadeOut])
        tutorialLabel.run(sequenceImages)
        tutorialiPad.run(sequenceImages)
        tutorialArrow.run(sequenceImages)
        tutorialArrow.run(moveAction)
        tutorialFrame.run(sequence)
        
    }
    
    func addTips() {
        // Animations
        let fadeInAction = SKAction.fadeIn(withDuration: 0.3)
        let fadeOutAction = SKAction.fadeOut(withDuration: 0.3)
        let wait = SKAction.wait(forDuration: 10)
        let sequence = SKAction.sequence([fadeInAction, wait, fadeOutAction])
        // Tips Config
        let tipScopeSprite = SKSpriteNode(imageNamed: "TipScopeSprite")
        let tipPointerSprite = SKSpriteNode(imageNamed: "TipPointerSprite")
        tipScopeSprite.alpha = 0
        tipScopeSprite.zPosition = 10
        tipPointerSprite.alpha = 0
        tipPointerSprite.zPosition = 110
        var scaleWidth: CGFloat = 0
        var scaleHeight: CGFloat = 0
        var tipScopePosition: CGPoint = CGPoint.zero
        var tipPointerPosition: CGPoint = CGPoint.zero
        // Poistion and Scale based on Screen Size
        if self.size.width >= 1330 {
            tipScopePosition = CGPoint(x: .zero + 300, y: .zero + 110)
            tipPointerPosition = CGPoint(x: pointerBox.position.x + 300, y: pointerBox.position.y + 110)
        } else if self.size.width >= 1100 {
            scaleWidth = 500
            scaleHeight = 400
            tipScopePosition = CGPoint(x: .zero + 248, y: .zero + 88)
            tipPointerPosition = CGPoint(x: pointerBox.position.x + 248, y: pointerBox.position.y + 88)
        }
        
        tipScopeSprite.position = tipScopePosition
        tipPointerSprite.position = tipPointerPosition
        // Set the desired size
        let desiredSize = CGSize(width: scaleWidth, height: scaleHeight)
        // Calculate scale ratios to fit the image to the desired size
        let originalSize = tipScopeSprite.size
        let scaleX = desiredSize.width / originalSize.width
        let scaleY = desiredSize.height / originalSize.height
        // Apply the minimum scale to fit the image to the desired size without distortion
        let minScale = min(scaleX, scaleY)
        // Only Scale if isnt 12 polegadas
        if self.size.width <= 1330 {
            tipScopeSprite.scale(to: CGSize(width: originalSize.width * minScale, height: originalSize.height * minScale))
            tipPointerSprite.scale(to: CGSize(width: originalSize.width * minScale, height: originalSize.height * minScale))
        }
        cameraNode?.addChild(tipScopeSprite)
        cameraNode?.addChild(tipPointerSprite)
        tipScopeSprite.run(sequence)
        tipPointerSprite.run(sequence)
        
    }
    
}

extension CGPoint {
    // verify distance between 2 points with a node position
    func distance(to point: CGPoint) -> CGFloat {
        let dx = point.x - self.x
        let dy = point.y - self.y
        return sqrt(dx * dx + dy * dy)
    }
}

extension SKNode {
    func addChildWithAnimation(_ node: SKNode) {
        node.alpha = 0 // inicial scale is 0
        self.addChild(node)
        // creating animation
        let fadeInAction = SKAction.fadeIn(withDuration: 0.5)
        fadeInAction.timingMode = .easeIn
        node.run(fadeInAction)
    }
}
