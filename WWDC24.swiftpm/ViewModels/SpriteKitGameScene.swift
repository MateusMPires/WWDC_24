
import SpriteKit
import SwiftUI
import CoreMotion
import SceneKit


class SpriteKitGameScene: SKScene, SKPhysicsContactDelegate, ObservableObject {
    
    // BACKGROUND
    private var starsBackground = SKSpriteNode(imageNamed: "StarsBackground2x") // This is my background
    
    // CAMERA
    private var cameraNode: SKCameraNode?
    private var cameraIndicator = SKSpriteNode(imageNamed: "Scope")
    
    // EARTH
    private var earth = SK3DNode() // This is my Earth
    
    private var nearestAsteroid: SK3DNode?
    
    // PROGRESS BAR
    private let progressBar = ProgressBar()
    private let pointerBox = SKSpriteNode()
    private let pointer = SKSpriteNode(texture: SKTexture(imageNamed: "Arrow"))
    
    // COUNT
    private let countLabel = SKLabelNode()
    private let counterBG = SKSpriteNode(imageNamed: "Counter")
    private let counterImage = SKSpriteNode(imageNamed: "Asteroid_5")
    private let detectLabel = SKLabelNode(text: "keep pointed")
    
    // TUTORIAL
    private let tipTitleLabel = SKLabelNode(text: "")
    private let ipadTipLabel = SKLabelNode(text: "Move your iPad to explore")
    
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
        starsBackground.position = CGPoint(x: 10 , y: 10 )
        addChild(starsBackground)
        
        // Camera
        setupCamera()
        
        // Creating and positioning Earth.scn
        create3DEarth()
        
        // Creating tip Title Label
        addTipTitle()
        
        // Pointer
        addPointerWithTime()

        // Font
        customFont(fontName: "RobotoMono-Regular")
        customFont(fontName: "Orbitron-SemiBold")
    }
    
    override func update(_ currentTime: TimeInterval) {
        moveCamera()
        detectAsteroid(earthNode: earth)
        rotatePointer(target: earth)
        
    }
    
    //MARK: My Functions --
    
    // This function creates our 3D Earth in SpriteKit
    func create3DEarth() {
        let sceneKitEarth = SCNScene(named: "Pangea4Scene.scn")
        
        // Define a rotação desejada em radianos
            let rotationAngle: Float = Float.pi / 2 // Por exemplo, uma rotação de 45 graus
            
            // Aplica a rotação ao nó raiz da cena
            sceneKitEarth?.rootNode.eulerAngles.y = rotationAngle
        
        earth.scnScene = sceneKitEarth
        
        // Positioned at the center of View
        earth.position = CGPoint(x: frame.midX, y: frame.midY)
        
        earth.viewportSize = CGSize(width: frame.width * 0.03, height: frame.height * 0.03)

        self.addChild(earth)
    }
    
    func rotateEarth() {
        let rotationAction = SKAction.rotate(byAngle: CGFloat.pi * 2, duration: 10) // Um ciclo completo em 10 segundos
        
        let repeatAction = SKAction.repeatForever(rotationAction)
        
        earth.run(repeatAction)
    }
    
    func setupCamera() {
        cameraNode = SKCameraNode()
        self.camera = cameraNode
        self.addChild(cameraNode!)
        cameraNode?.zPosition = 2
                
        // Add a scope to guide
        cameraIndicator.name = "cameraIndicator"
        cameraIndicator.zPosition = 2
        cameraIndicator.color = .red
        addChild(cameraIndicator)
        
        // Map limit - constraints
        let cameraWidthBounds = self.frame.width / 2
        let cameraHeightBounds = self.frame.height / 2
        
        // Converter os limites globais para o sistema de coordenadas local da cena
        let bounds = starsBackground.calculateAccumulatedFrame()
        let widthBounds = bounds.width / 2.5 - cameraWidthBounds
        let heightBounds = bounds.height / 2.5 - cameraHeightBounds
        
        let cameraWidthConstraint = SKConstraint.positionX(SKRange(lowerLimit: -widthBounds, upperLimit: widthBounds))
        let cameraHeightConstraint = SKConstraint.positionY(SKRange(lowerLimit: -heightBounds, upperLimit: heightBounds))
        
        self.camera?.constraints = [cameraWidthConstraint, cameraHeightConstraint]
        cameraIndicator.constraints = [cameraWidthConstraint, cameraHeightConstraint]
        
        
        
//        let cameraWidthBounds = self.frame.width/2
//        let widthBounds = self.calculateAccumulatedFrame().width / 2 - cameraWidthBounds
//        let cameraWidthConstraint = SKConstraint.positionX(.init(lowerLimit: -widthBounds, upperLimit: widthBounds))
//        
//        let cameraHeightBounds = self.calculateAccumulatedFrame().height/2
//        let heightBounds = self.calculateAccumulatedFrame().height/2 - cameraHeightBounds
//        let cameraHeightConstraint = SKConstraint.positionY(.init(lowerLimit: -cameraHeightBounds, upperLimit: cameraHeightBounds))
//        
//        self.camera?.constraints = [cameraWidthConstraint, cameraHeightConstraint]

    }
    
    func moveCamera(){
        velocityX = motionVM.rotationRate.x * 13
        velocityY = motionVM.rotationRate.y * 13
        
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
                        nearestAsteroid = earth
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
            if progressBar.completeProgress ==  true {
                //AsteroidCount.count += 1
                //AsteroidCount.asteroids.removeAll { $0 == asteroid }
                //self.removeAllChildren() // evit problems
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
        
        let symbol = UIImage(systemName: "location")?.withTintColor(.blue)
        //pointer.texture = SKTexture(image: symbol!)
        let square = UIImage(systemName: "square")?.withTintColor(.blue)
        //pointerBox.texture = SKTexture(image: square!)
        
        // Animation
        pointerBox.run(.fadeAlpha(to: 0.7, duration: 0.3))
        // Add Nodes
        //pointerBox.addChild(pointer)
        cameraNode?.addChild(pointer)
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
        pointer.position = tipScopePosition
        // Set the desired size
        let desiredSize = CGSize(width: scaleWidth, height: scaleHeight)
        // Calculate scale ratios to fit the image to the desired size
        let originalSize = pointer.size
        let scaleX = desiredSize.width / originalSize.width
        let scaleY = desiredSize.height / originalSize.height
        // Apply the minimum scale to fit the image to the desired size without distortion
        let minScale = min(scaleX, scaleY)
        // Only Scale if isnt 12 polegadas
        if self.size.width <= 1330 {
            //pointer.scale(to: CGSize(width: originalSize.width * minScale, height: originalSize.height * minScale))
           // pointer.scale(to: CGSize(width: originalSize.width * minScale, height: originalSize.height * minScale))
            
        }
        
    }
    
    func rotatePointer(target: SK3DNode) {
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
            if time == 3 {
                self.addPointer()
                timer.invalidate()
            }
            time += 1
            print("timer rolando a cena \(time)")
        }
    }
    
    
    // show tutorial
    func tutorialScene() {
        tipTitleLabel.text = tutorialDialog[tutorialIndex]
        tutorialiPad.name = "tutorialFrame"
        tutorialiPad.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        tutorialiPad.position = CGPoint(x: 0, y: -size.height / 2 + 80)
        addChild(tutorialiPad)
        tipTitleLabel.position = CGPoint(x: 0, y: 0)
        tipTitleLabel.fontColor = .black
   
    }
    
    func attTutorialScene() {
        tutorialIndex += 1
        let fadeIn = SKAction.fadeIn(withDuration: 0.3)
        let fadeOut = SKAction.fadeOut(withDuration: 0.3)
        // last text close frame - all transitions with animation
     
        if tutorialIndex < 3 {
            let attLabel = SKAction.run {
                self.tipTitleLabel.text = self.tutorialDialog[self.tutorialIndex]
            }
            let sequence = SKAction.sequence([fadeOut, attLabel, fadeIn])
            tipTitleLabel.run(sequence)
            
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
    
    func addTipTitle() {
        tipTitleLabel.text = "Locate Earth with telescope"
        tipTitleLabel.fontName = "Orbitron-SemiBold"
        tipTitleLabel.position = CGPoint(x: CGFloat.zero, y: 280)
        tipTitleLabel.zPosition = 110
        
        ipadTipLabel.fontName = "RobotoMono-Regular"
        ipadTipLabel.position = CGPoint(x: CGFloat.zero, y: 230)
        ipadTipLabel.fontSize = 24
        ipadTipLabel.zPosition = 110
        
        cameraNode?.addChild(tipTitleLabel)
        cameraNode?.addChild(ipadTipLabel)
        
        startTypingAnimation(label: ipadTipLabel)
        
    }
    
    func startTypingAnimation(label: SKLabelNode) {
        var index = 0
        let initialDelay = 1.0 // Segundos de atraso antes de começar a segunda string
        var displayedText = ""
        guard let fullText = label.text else { return }
        
        let timer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { timer in
            guard index < fullText.count else {
                timer.invalidate()
                return
            }
            displayedText.append(fullText[fullText.index(fullText.startIndex, offsetBy: index)])
            label.text = displayedText
            index += 1
        }
        // Armazene o timer para que possa ser interrompido posteriormente, se necessário
        // Por exemplo, você pode armazená-lo em uma propriedade da classe.
        //self.typingTimer = timer
    }
    
    func addTutorial() {
        
        // White Background
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
        
        // Animate ipad
        let moveiPad = [SKTexture(imageNamed: "iPadSprite_frame1"),
                        SKTexture(imageNamed: "iPadSprite_frame2"),
                        SKTexture(imageNamed: "iPadSprite_frame1"),
                        SKTexture(imageNamed: "iPadSprite_frame3")]
        tutorialiPad.run(.repeatForever(.animate(with: moveiPad, timePerFrame: 0.3)))
        
        tipTitleLabel.fontColor = .white
        // Position
        tutorialiPad.position = CGPoint(x: CGFloat.zero, y: CGFloat.zero)
        tutorialArrow.position = CGPoint(x: CGFloat.zero + 20, y: -280)
        // Add scene
        cameraNode?.addChild(tutorialiPad)
        //cameraNode?.addChild(tutorialArrow)
        
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
        //tutorialLabel.run(sequenceImages)
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
    
    func customFont(fontName: String){
            if let url = Bundle.main.url(forResource: fontName, withExtension: "ttf"){
                CTFontManagerRegisterFontsForURL(url as CFURL, CTFontManagerScope.process, nil)
            }
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
