
import SpriteKit

class SimpleScene: SKScene {
    
    let gameSettings = GameSettings()
    
    //Переход на сцену по имени сцены
    func changeToSceneBy(nameScene: String, userData: NSMutableDictionary) {   // userData: NSMutableDictionary
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
