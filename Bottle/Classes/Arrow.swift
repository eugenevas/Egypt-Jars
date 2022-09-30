
import SpriteKit
import GameplayKit

class Arrow: SKSpriteNode {
    
//    static func createArrow(at point: CGPoint) -> Arrow {
//        let arrow = Arrow(imageNamed: "arrow")
//        arrow.setScale(0.8)
//        arrow.position = point
//        arrow.zPosition = 5
//        arrow.isUserInteractionEnabled = true
//        arrow.name = "coin"
//        arrow.run(move(from: arrow.position))
//
//        arrow.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 270, height: 20))
//        arrow.physicsBody?.isDynamic = true
//        arrow.physicsBody?.categoryBitMask = BitMaskCategory.coin.rawValue
//        arrow.physicsBody?.collisionBitMask = BitMaskCategory.none.rawValue
//        arrow.physicsBody?.contactTestBitMask = BitMaskCategory.bottle.rawValue
//
//        return arrow
//    }
//
//    static func move(from point: CGPoint) -> SKAction {
//        let movePoint = CGPoint(x: -300, y: point.y)
//        let moveDistance = point.x + 300
//        let movementSpeed: CGFloat = 60.0
//        let duration = moveDistance / movementSpeed
//        return SKAction.move(to: movePoint, duration: TimeInterval(duration))
//    }
    
    
    static func createArrow(at point: CGPoint?) -> Arrow {

        let arrow = Arrow(imageNamed: "arrow")
        arrow.setScale(randomScaleFactor)
        arrow.zPosition = 7
        arrow.setScale(0.4)
        arrow.name = "sprite"
        arrow.position = point ?? randomPoint()
        arrow.run(move(from: arrow.position))

        arrow.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 135, height: 10))
        
        arrow.physicsBody?.isDynamic = false
        arrow.physicsBody?.categoryBitMask = BitMaskCategory.arrow.rawValue
        arrow.physicsBody?.collisionBitMask = BitMaskCategory.bottle.rawValue
        arrow.physicsBody?.contactTestBitMask = BitMaskCategory.bottle.rawValue

        return arrow
    }

    static var randomScaleFactor: CGFloat {
        let distribution = GKRandomDistribution(lowestValue: 5, highestValue: 7)
        let randomNumber = CGFloat(distribution.nextInt()) / 10
        return randomNumber
    }

    static func move(from point: CGPoint) -> SKAction {
        let movePoint = CGPoint(x: -100, y: point.y)  //-300
        let moveDistance = point.x + 100              //300
        let movementSpeed: CGFloat = 500.0
        let duration = moveDistance / movementSpeed
        return SKAction.move(to: movePoint, duration: TimeInterval(duration))
    }

    static func randomPoint() -> CGPoint {
        let screen = UIScreen.main.bounds
        
        let distribution = GKRandomDistribution(lowestValue: Int(screen.size.height * 0.1), highestValue: Int(screen.size.height * 0.9))

        let y = CGFloat(distribution.nextInt())
        let x = CGFloat(GKRandomSource.sharedRandom().nextInt(upperBound: Int(screen.size.width)))

        return CGPoint(x: x, y: y)
    }

}
