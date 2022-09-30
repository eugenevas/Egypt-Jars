
import SpriteKit

class LabelNode: SKLabelNode {
    
    convenience init?(text: String, fontSize: CGFloat, position: CGPoint, zPosition: CGFloat, fontColor: UIColor) {
        
        self.init(fontNamed: UI_FONT)
        self.text = text
        self.fontSize = fontSize
        self.position = position
        self.zPosition = zPosition
        self.fontColor = fontColor
        
    }
}
