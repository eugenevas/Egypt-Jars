

import SpriteKit

extension SKPhysicsBody {
    var category: BitMaskCategory {
        get {
            return BitMaskCategory(rawValue: self.categoryBitMask)
        }
        
        set(newValue) {
            self.categoryBitMask = newValue.rawValue
        }
    }
}

struct BitMaskCategory: OptionSet {
    let rawValue: UInt32
    
    static let none   = BitMaskCategory(rawValue: 0 << 0)
    static let bottle = BitMaskCategory(rawValue: 1 << 0)   //1    //player
    static let arrow  = BitMaskCategory(rawValue: 1 << 1)   //2
    static let table  = BitMaskCategory(rawValue: 1 << 3)   //8    //ground
    
    static let all    = BitMaskCategory(rawValue: UInt32.max)
}
