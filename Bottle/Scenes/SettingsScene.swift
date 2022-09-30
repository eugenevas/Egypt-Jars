
import SpriteKit

class SettingsScene: ParentScene {
    
    var isMusic: Bool!
    var isSound: Bool!
    
    var clickSound = SKAction()
    
    var backButtonNode = SKSpriteNode()
    
    override func didMove(to view: SKView) {
        
        
        //Подгрузили значения, которые по дефолту равно true
        isMusic = gameSettings.isMusic
        isSound = gameSettings.isSound
        
        clickSound = SKAction.playSoundFileNamed(GAME_SOUND_CLICK, waitForCompletion: false)
        
        let background = SKSpriteNode(imageNamed: "bg")
        background.anchorPoint = .zero
        background.size = view.frame.size
        background.zPosition = -1
        self.addChild(background)
        
        let backgroundNameForMusic = isMusic == true ? "music" : "nomusic"
        let music = ButtonWrapper(titled: nil, backgroundName: backgroundNameForMusic)
        music.position = CGPoint(x: self.frame.midX - 80, y: self.frame.midY)
        music.name = "music"
        music.setScale(0.5)
        music.zPosition = 1
        music.label.isHidden = true
        addChild(music)
        
        
        let backgroundNameForSound = isSound == true ? "sound" : "nosound"
        let sound = ButtonWrapper(titled: nil, backgroundName: backgroundNameForSound)
        sound.position = CGPoint(x: self.frame.midX + 80, y: self.frame.midY)
        sound.name = "sound"
        sound.zPosition = 1
        sound.setScale(0.5)
        sound.label.isHidden = true
        addChild(sound)
        
        
        let optionsHeader = SKSpriteNode(imageNamed: "settings_header")
        optionsHeader.position = CGPoint(x: self.frame.midX, y: self.frame.midY + 200)
        optionsHeader.setScale(0.4)
        optionsHeader.zPosition = 1
        self.addChild(optionsHeader)
        
        
        backButtonNode = ButtonNode(imageNode: "back",
                                    position: CGPoint(x: self.frame.midX * 0.2, y: self.frame.height - 60),
                                    zPosition: 1,
                                    xScale: 1, yScale: 1)
        addChild(backButtonNode)
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let location = touches.first!.location(in: self)
        let node = self.atPoint(location)
        
        if node.name == "music" {
            playSoundFX(clickSound)
            //isMusic = true, присваиваем новое значение false
            isMusic = !isMusic
            update(node: node as! SKSpriteNode, property: isMusic)
            
        } else if node.name == "sound" {
            playSoundFX(clickSound)
            isSound = !isSound
            update(node: node as! SKSpriteNode, property: isSound)
        }
        
    }
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            
            if backButtonNode.contains(location) {
                //Сохраняем настройки когда выходим из экрана
                gameSettings.isSound = isSound
                gameSettings.isMusic = isMusic
                gameSettings.saveGameSettings()
                
                if gameSettings.isSound {
                    playSoundFX(clickSound)
                }
                changeToSceneBy(nameScene: "MenuScene", userData: NSMutableDictionary.init())
            }
        }
    }
    
    func update(node: SKSpriteNode, property: Bool) {
        if let name = node.name {
            node.texture = property ? SKTexture(imageNamed: name) : SKTexture(imageNamed: "no" + name)
        }
        
    }
}

