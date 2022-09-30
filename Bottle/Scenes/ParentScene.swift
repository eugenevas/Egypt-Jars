
import SpriteKit

class ParentScene: SKScene {
    
    let gameSettings = GameSettings()
    let sceneManager = SceneManager.shared
    var backScene: SKScene?
    
    func setHeader(withName name: String?, andBackground backgroundName: String) {
        let header = ButtonWrapper(titled: name, backgroundName: backgroundName)
        header.position = CGPoint(x: self.frame.midX, y: self.frame.midY + 200)
        self.addChild(header)
    }
    
    override init(size: CGSize) {
        super.init(size: size)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func changeToSceneBy(nameScene: String, userData: NSMutableDictionary) {   //, userData: NSMutableDictionary
        let scene = (nameScene == "GameScene") ? GameScene(size: self.size) : MenuScene(size: self.size)
        
        let transition = SKTransition.fade(withDuration: 1)
        scene.scaleMode = .aspectFill
        scene.userData = userData
        
        self.view?.presentScene(scene, transition: transition)
    }
    
    func playSoundFX(_ action: SKAction) {
        self.run(action)
    }
}

