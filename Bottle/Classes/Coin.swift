//import SpriteKit
//import GameplayKit
//
//class Coin: SKSpriteNode, SKPhysicsContactDelegate {
//
//    static func createCoin(at point: CGPoint) -> Coin {
//        let coin = Coin(imageNamed: "coin")
//
//        coin.setScale(0.7)
//        coin.position = point
//        coin.zPosition = 5
//        coin.isUserInteractionEnabled = true
//        coin.name = "coin"
//        coin.run(move(from: coin.position))
//        
//        let offsetX = coin.size.width * coin.anchorPoint.x
//        let offsetY = coin.size.height * coin.anchorPoint.y
//
//        let path = CGMutablePath()
//        path.move(to: CGPoint(x: 7 - offsetX, y: 34 - offsetY))
//        path.addLine(to: CGPoint(x: 13 - offsetX, y: 37 - offsetY))
//        path.addLine(to: CGPoint(x: 20 - offsetX, y: 37 - offsetY))
//        path.addLine(to: CGPoint(x: 24 - offsetX, y: 35 - offsetY))
//        path.addLine(to: CGPoint(x: 30 - offsetX, y: 26 - offsetY))
//        path.addLine(to: CGPoint(x: 32 - offsetX, y: 21 - offsetY))
//        path.addLine(to: CGPoint(x: 32 - offsetX, y: 12 - offsetY))
//        path.addLine(to: CGPoint(x: 29 - offsetX, y: 5 - offsetY))
//        path.addLine(to: CGPoint(x: 25 - offsetX, y: 2 - offsetY))
//        path.addLine(to: CGPoint(x: 18 - offsetX, y: 0 - offsetY))
//        path.addLine(to: CGPoint(x: 12 - offsetX, y: 0 - offsetY))
//        path.addLine(to: CGPoint(x: 3 - offsetX, y: 6 - offsetY))
//        path.addLine(to: CGPoint(x: 0 - offsetX, y: 14 - offsetY))
//        path.addLine(to: CGPoint(x: 0 - offsetX, y: 26 - offsetY))
//        path.addLine(to: CGPoint(x: 5 - offsetX, y: 34 - offsetY))
//
//        path.closeSubpath()
//        coin.physicsBody = SKPhysicsBody(polygonFrom: path)
//
////        coin.physicsBody = SKPhysicsBody(circleOfRadius: 20)
//        coin.physicsBody?.isDynamic = true
//        coin.physicsBody?.categoryBitMask = BitMaskCategory.coin.rawValue
//        coin.physicsBody?.collisionBitMask = BitMaskCategory.none.rawValue
//        coin.physicsBody?.contactTestBitMask = BitMaskCategory.bottle.rawValue
//
//        return coin
//    }
//
//    static func move(from point: CGPoint) -> SKAction {
//        let movePoint = CGPoint(x: point.x, y: 300)  //-300
//        let moveDistance = point.y - 300               //+300
//        let movementSpeed: CGFloat = 20.0             //100
//        let duration = moveDistance / movementSpeed
//        return SKAction.move(to: movePoint, duration: TimeInterval(duration))
//    }
//
//    func startMovement() {
//        let moveForward = SKAction.moveTo(y: 900, duration: 1)
//        self.run(moveForward)
//    }
//
//}
