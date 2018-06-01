
import WatchKit
import SpriteKit

class CircleScene: SKScene {

    var circleRing: SKRingNode?
    
    
    override func sceneDidLoad() {
        backgroundColor = .clear
    }
    
    func setDuration(duration: TimeInterval, count: Int) {
        circleRing?.duration = duration
        let valueUpEffect = SKTRingValueEffect(for: circleRing!, to: 1, duration: duration)
        
        
//        valueUpEffect.timingFunction = SKTTimingFunctionQuarticEaseIn
        let valueUpAction = SKAction.actionWithEffect(valueUpEffect)
        let sequence = SKAction.sequence([valueUpAction,
                                          SKAction.wait(forDuration: 1 / 60)])
        circleRing?.run(SKAction.repeat(sequence, count: count))
    }
    
    func setStopwatchDuration(duration: TimeInterval) {
        circleRing?.duration = duration
        let valueUpEffect = SKTRingValueEffect(for: circleRing!, to: 1, duration: duration)
        
//        valueUpEffect.timingFunction = SKTTimingFunctionQuarticEaseIn
        let valueUpAction = SKAction.actionWithEffect(valueUpEffect)
        let sequence = SKAction.sequence([valueUpAction,
                                          SKAction.wait(forDuration: 1 / 60)])
        circleRing?.run(SKAction.repeatForever(sequence))
    }
    
    func setColor(color : UIColor) {
        circleRing?.color = color
    }
    
    func show(_ circleType: CircleType, at position: CGPoint, diameter: CGFloat) {
        switch circleType {

        case .tabata:
            circleRing = SKRingNode(diameter: diameter)
            circleRing?.position = position
            addChild(circleRing!)

        case .rounds:
            circleRing = SKRingNode(diameter: diameter)
            circleRing?.position = position
            addChild(circleRing!)

        case .cycles:
            circleRing = SKRingNode(diameter: diameter)
            circleRing?.position = position
            addChild(circleRing!)
        }
    }
    
    func display(_ circleType: RoundCircleType, at position: CGPoint, diameter: CGFloat) {
        switch circleType {
            
        case .roundsCircle:
            circleRing = SKRingNode(diameter: diameter)
            circleRing?.position = position
            addChild(circleRing!)
            
        case .roundsCount:
            circleRing = SKRingNode(diameter: diameter)
            circleRing?.position = position
            addChild(circleRing!)
        }
    }
    
    func showStopwatchCircle(at position: CGPoint, diameter: CGFloat) {
        circleRing = SKRingNode(diameter: diameter)
        circleRing?.position = position
        addChild(circleRing!)
    }
    
    
    
    
    
}
