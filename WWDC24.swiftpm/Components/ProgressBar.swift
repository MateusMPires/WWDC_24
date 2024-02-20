//Progress bar

import SpriteKit

class ProgressBar: SKNode {
    // Circular nodes
    private let backgroundNode: SKShapeNode = SKShapeNode(circleOfRadius: 120)
    private let circularBar: SKShapeNode = SKShapeNode(circleOfRadius: 0)
    
    // progress values
    private let maxValue: CGFloat = 5
    private let width: CGFloat = 12
    var completeProgress: Bool = false
    var progress: CGFloat  {
        didSet {
            // start animation
            if progress == 1 {
                updateProgress()
            }
            // reset animation
            if progress == 0 {
                restartProgress()
            }
            
            if self.progress >= 5 {
                self.completeProgress.toggle()
            }
        }
    }
    
    override init() {
        // inicializing progress
        progress = 0
        super.init()
        setUpProgressBar()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpProgressBar() {
        // background config
        backgroundNode.lineWidth = width
        backgroundNode.alpha = 0.5
        // add background as a chield of circular bar to avoid the alpha configuration on circularBar
        circularBar.addChild(backgroundNode)
        // circular progres config
        circularBar.lineWidth = 12
        circularBar.strokeColor = SKColor.green
        circularBar.alpha = 1
        addChild(circularBar)
    }
    
    private func updateProgress() {
        let startAngle = -Double.pi / 2
        let endAngle = (Double.pi * 2 * 9) / maxValue - Double.pi / 2
        // update progress value with animation
        let animationUpdate = SKAction.customAction(withDuration: 5) { node, elapsedTime in
            let percent = elapsedTime / CGFloat(5)
            if let circularNode = node as? SKShapeNode {
                circularNode.path = UIBezierPath(
                    arcCenter: CGPoint.zero,
                    radius: 120,
                    startAngle: CGFloat(startAngle),
                    endAngle: CGFloat(startAngle + percent * (endAngle - startAngle)),
                    clockwise: true
                ).cgPath
            }
            
        }
        // Run block only when animation is complete
        let runEndAnimation = SKAction.run {
            // 6 is the animation time. If the progress runs for 6 seconds then activate this function
            if self.progress >= 5 {
                self.completeProgress.toggle()
                print("a")
            }
        }
        let sequenceUpdate = SKAction.sequence([animationUpdate, runEndAnimation])
        // Apply animation update
        circularBar.run(sequenceUpdate, withKey: "animate")
    }
    // change the progress to 0
    private func restartProgress(){
        circularBar.path = UIBezierPath(
            arcCenter: CGPoint.zero,
            radius: 90,
            startAngle: CGFloat(0),
            endAngle: CGFloat(0),
            clockwise: true
        ).cgPath
        circularBar.removeAllActions()
    }
}

