
import SpriteKit

class BottleNode: SKSpriteNode {
    
    init(_ bottle: Bottle) {
        
        let texture = SKTexture(imageNamed: bottle.Sprite!)
        super.init(texture: texture, color: .clear, size: texture.size())
        self.zPosition = 3
        
//        self.physicsBody = SKPhysicsBody(texture: self.texture!, alphaThreshold: 0.7, size: CGSize(width: 170, height: 278))
        
//        self.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 300, height: 310))
        self.physicsBody = SKPhysicsBody(texture: self.texture!, size: (self.texture?.size())!)
        self.xScale = CGFloat(bottle.XScale!.floatValue)
        self.yScale = CGFloat(bottle.YScale!.floatValue)
        self.physicsBody?.allowsRotation = true
        self.physicsBody?.angularDamping = 0.25
        self.physicsBody?.mass = CGFloat(bottle.Mass!.doubleValue)
        self.physicsBody?.restitution = CGFloat(bottle.Restitution!.doubleValue)
        
        self.physicsBody?.isDynamic = true
        self.physicsBody?.categoryBitMask = BitMaskCategory.bottle.rawValue
        self.physicsBody?.collisionBitMask = BitMaskCategory.arrow.rawValue
        self.physicsBody?.contactTestBitMask = BitMaskCategory.arrow.rawValue
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
