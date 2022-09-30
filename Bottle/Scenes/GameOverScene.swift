
import SpriteKit

class GameOverScene: ParentScene {
    
//    let sceneManager = SceneManager.shared
    
    var scoreLabelNode = SKLabelNode()
    var highscoreLabelNode = SKLabelNode()
    var highscore = 0
    var totalFlips = 0
    
    var bottleNode = SKSpriteNode()
    var gameOverNode = SKSpriteNode()
    
    var backButtonNode = SKSpriteNode()
    var resetButtonNode = SKSpriteNode()
    var clickSound = SKAction()
    var didSwipe = false
    
    var failSound = SKAction()
    var currentScore = 0
    
    
    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "bg")
        background.anchorPoint = .zero
        background.size = view.frame.size
        background.zPosition = 0
        self.addChild(background)
        
        highscore = UserDefaults.standard.integer(forKey: "localHighscore")
        totalFlips = UserDefaults.standard.integer(forKey: "flips")
        
        clickSound = SKAction.playSoundFileNamed(GAME_SOUND_CLICK, waitForCompletion: false)
        failSound = SKAction.playSoundFileNamed(GAME_SOUND_FAIL, waitForCompletion: false)
        
        setupUI()
    }

    

    func setupUI() {
        gameOverNode = ButtonNode(imageNode: "gameover",
                                  position: CGPoint(x: self.frame.midX, y: self.frame.midY + 200),
                                  zPosition: 3,
                                  xScale: 0.3, yScale: 0.3)
        addChild(gameOverNode)
        
        //Labels
        let bestScoreLabelNode = LabelNode(text: "Best result",
                                           fontSize: 20, position:
                                            CGPoint(x: self.frame.midX - 100, y: self.frame.midY + 50),
                                           zPosition: 3,
                                           fontColor: .white)!
        self.addChild(bestScoreLabelNode)


        let highScoreLabelNode = LabelNode(text: String(highscore),
                                           fontSize: 50,
                                           position: CGPoint(x: self.frame.midX - 100, y: self.frame.midY),
                                           zPosition: 3,
                                           fontColor: .white)!
        self.addChild(highScoreLabelNode)

        //        let bestScoreLabelNode = SKLabelNode(fontNamed: "Futura")
        //        bestScoreLabelNode.position = CGPoint(x: self.frame.midX - 120, y: self.frame.midY + 200)
        //        bestScoreLabelNode.text = "Best result"
        //        bestScoreLabelNode.fontSize = 24
        //        bestScoreLabelNode.fontColor = .white
        //        bestScoreLabelNode.zPosition = 3
        //        self.addChild(bestScoreLabelNode)
        
        let totalFlipsLabelNode = LabelNode(text: "Count of flips",
                                            fontSize: 20,
                                            position: CGPoint(x: self.frame.midX + 80, y: self.frame.midY + 50),
                                            zPosition: 3,
                                            fontColor: .white)!
        self.addChild(totalFlipsLabelNode)


        let flipsLabelNode = LabelNode(text: String(totalFlips),
                                       fontSize: 50,
                                       position: CGPoint(x: self.frame.midX + 80, y: self.frame.midY),
                                       zPosition: 3,
                                       fontColor: .white)!
        self.addChild(flipsLabelNode)
        
        
        //Buttons
        backButtonNode = ButtonNode(imageNode: "back",
                                    position: CGPoint(x: self.frame.midX, y: self.frame.midY - 150),
                                    zPosition: 1,
                                    xScale: 1.0, yScale: 1.0)
        addChild(backButtonNode)
        
        resetButtonNode = ButtonNode(imageNode: "reset",
                                     position: CGPoint(x: self.frame.midX, y: self.frame.midY - 80),
                                     zPosition: 1,
                                     xScale: 1.0, yScale: 1.0)
        resetButtonNode.name = "reset"
        addChild(resetButtonNode)
        
        
//        let resetTexture = SKTexture(imageNamed: "reset")
//        let reset = SKSpriteNode(texture: resetTexture)
//        reset.position = CGPoint(x: self.frame.midX, y: self.frame.midY - 100)
//        reset.name = "reset"
//        reset.setScale(1.0)
//        reset.zPosition = 1
//        self.addChild(reset)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        for touch in touches {
//
//            let location = touch.location(in: self)
////            let node = self.atPoint(location)
//
//            if backButtonNode.contains(location) {
//                playSoundFX(clickSound)
//                changeToSceneBy(nameScene: "MenuScene", userData: NSMutableDictionary.init())
//            }
//
//            if ((resetButtonNode.contains(location)) && didSwipe == true) {
//                if gameSettings.isSound {
//                    playSoundFX(clickSound)
//                }
//
//                changeToSceneBy(nameScene: "GameScene", userData: NSMutableDictionary.init())
//            }
//
////            if node.name == "reset" {
////                sceneManager.gameScene = nil  // приравниваем к nil, чтобы не появлялась ошибка в checkPlayer.position
////                let transition = SKTransition.crossFade(withDuration: 1.0)
////                let gameScene = GameScene(size: self.size)
////                gameScene.scaleMode = .aspectFill
////                self.scene?.view?.presentScene(gameScene, transition: transition)
////                playSoundFX(clickSound)
////            }
//
//        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
      for touch in touches {
        let location = touch.location(in: self)
        
        if backButtonNode.contains(location) {
            if gameSettings.isSound {
                playSoundFX(clickSound)
            }
            self.changeToSceneBy(nameScene: "MenuScene", userData: NSMutableDictionary.init())
        }
        
        if resetButtonNode.contains(location) {
            if gameSettings.isSound {
                playSoundFX(clickSound)
            }
            
            self.changeToSceneBy(nameScene: "GameScene", userData: self.userData!)
        }
    }
    
    func resetBottle() {
        //Reset bottle after a fail or successful flip
        bottleNode.position = CGPoint(x: self.frame.midX, y: bottleNode.size.height) // bottleNode.size.height
        bottleNode.physicsBody?.angularVelocity = 0
        bottleNode.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        bottleNode.speed = 0
        bottleNode.zRotation = 0
        didSwipe = false
    }
    
    
//    func failedFlip() {
//        //Failed flips, reset score and bottle
//        self.playSoundFX(failSound)
//        currentScore = 0
//
//        self.updateScore()
//        self.resetBottle()
//    }
    
    func updateScore() {
        //Updating score based on flips and saving highscore
        scoreLabelNode.text = "\(currentScore)"
        
        let localHighscore = UserDefaults.standard.integer(forKey: "localHighscore")
        
        if currentScore > localHighscore {
            highscoreLabelNode.isHidden = false
            
            let fadeAction = SKAction.fadeAlpha(to: 0, duration: 1.0)
            
            highscoreLabelNode.run(fadeAction, completion: {
                self.highscoreLabelNode.isHidden = true
            })
            
            UserDefaults.standard.set(currentScore, forKey: "localHighscore")
            UserDefaults.standard.synchronize()
        }
    }
    
    
    func changeToGame(nameScene: String) {
//        changeToSceneBy(nameScene: "GameScene", userData: NSMutableDictionary.init())
        
        let scene = (nameScene == "GameScene") ? GameScene(size: self.size) : MenuScene(size: self.size)
        
        let transition = SKTransition.fade(withDuration: 1)
        scene.scaleMode = .aspectFill
        scene.userData = userData
        
        self.view?.presentScene(scene, transition: transition)
    }
    

}

}
