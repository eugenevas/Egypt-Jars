
import SpriteKit

class GameModes: ParentScene {
    
//    var playButtonNode = SKSpriteNode()
    var backButtonNode = SKSpriteNode()
    var endlessButtonNode = SKSpriteNode()
    var historyButtonNode = SKSpriteNode()
    

    var tableNode = SKSpriteNode()
    var bottleNode = SKSpriteNode()

    
    var bottles = [Bottle]()
    var selectedBottleIndex = 0
    var totalBottles = 0
    var isShopButton = false

    var clickSound = SKAction()


    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "bg")
        background.anchorPoint = .zero
        background.size = view.frame.size
        background.zPosition = 0
        self.addChild(background)

        //Loading bottles from Items.plist
        bottles = BottleController.readItems()
        totalBottles = bottles.count

        clickSound = SKAction.playSoundFileNamed(GAME_SOUND_CLICK, waitForCompletion: false)

        setupUI()
    }


    func setupUI() {
        // MARK: -Buttons
        //Play button
//        playButtonNode = ButtonNode(imageNode: "play",
//                                    position: CGPoint(x: self.frame.midX, y: self.frame.midY + 90),
//                                    zPosition: 1,
//                                    xScale: 1.2, yScale: 1.2)
//        addChild(playButtonNode)
        
        historyButtonNode = ButtonNode(imageNode: "history",
                                      position: CGPoint(x: self.frame.midX, y: self.frame.midY + 90),
                                      zPosition: 1,
                                      xScale: 0.7, yScale: 0.7)
        addChild(historyButtonNode)

        endlessButtonNode = ButtonNode(imageNode: "play",
                                      position: CGPoint(x: self.frame.midX, y: self.frame.midY - 30),
                                      zPosition: 1,
                                      xScale: 0.7, yScale: 0.7)
        addChild(endlessButtonNode)
        
        
        
//        let historyButtonNode = ButtonNodeOne(imageNamed: "history", buttonAction: historyButtonPressed)
//        historyButtonNode.position = CGPoint(x: self.frame.midX, y: self.frame.midY + 90)
//        historyButtonNode.name = "history"
//        historyButtonNode.setScale(0.7)
//        historyButtonNode.zPosition = 1
//        addChild(historyButtonNode)
//
//        let endlessButtonNode = ButtonNodeOne(imageNamed: "play", buttonAction: endlessButtonPressed)
//        endlessButtonNode.position = CGPoint(x: self.frame.midX, y: self.frame.midY - 30)
//        endlessButtonNode.name = "endless"
//        endlessButtonNode.setScale(0.7)
//        endlessButtonNode.zPosition = 1
//        addChild(endlessButtonNode)
        
        
        backButtonNode = ButtonNode(imageNode: "back",
                                    position: CGPoint(x: self.frame.minX + backButtonNode.size.width + 40, y: self.frame.maxY - backButtonNode.size.height - 50),
                                    zPosition: 3,
                                    xScale: 1, yScale: 1)
        self.addChild(backButtonNode)

        
        


        //Table
        tableNode = ButtonNode(imageNode: "table",
                               position: CGPoint(x: self.frame.midX - 5, y: self.frame.minY + 12), //y: self.frame.minY + 55
                               zPosition: 1,
                               xScale: 0.45, yScale: 0.45)
        addChild(tableNode)
        


        selectedBottleIndex = BottleController.getSaveBottleIndex()
        let selectedBottle = bottles[selectedBottleIndex]

        bottleNode = SKSpriteNode(imageNamed: selectedBottle.Sprite!)
        bottleNode.position = CGPoint(x: self.frame.midX, y: self.frame.minY + bottleNode.size.height/2 + 50) //CGPoint(x: self.frame.midX, y: self.frame.midY - 250)
        bottleNode.zPosition = 3
        addChild(bottleNode)


        //Update selected bottle
        self.updateSelectedBottle(selectedBottle)
    }
    
    
    func endlessButtonPressed() {
//        presentGameScene(with: .endless)
        startGame(with: .endless)
    }
    
    func historyButtonPressed() {
//        presentGameScene(with: .history)
        startGame(with: .history)
    }

    func presentGameScene(with gameMode: GameMode) {
    let gameScene = GameScene(size: self.size)
        gameScene.scaleMode = self.scaleMode
        gameScene.gameMode = gameMode
        let transition = SKTransition.crossFade(withDuration: 1.0)
        self.view?.presentScene(gameScene, transition: transition)
    }
    
    
    func updateSelectedBottle(_ bottle: Bottle) {
        //Unlock flips
        
        bottleNode.texture = SKTexture(imageNamed: bottle.Sprite!)
       
        bottleNode.size = CGSize(width: (bottleNode.texture?.size().width)! * CGFloat(bottle.XScale!.floatValue),
                                 height: (bottleNode.texture?.size().height)! * CGFloat(bottle.YScale!.floatValue))

        bottleNode.position = CGPoint(x: self.frame.midX,
                                      y: self.frame.minY + bottleNode.size.height/2 + 120)
    }


    // MARK: -touchesBegan
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {

            let location = touch.location(in: self)
//            let node = self.atPoint(location)
            
            //Transiiton to game scene
            if historyButtonNode.contains(location) {
                
                if gameSettings.isSound {
                    playSoundFX(clickSound)
                }
                self.startGame(with: .history)
            }
            
            if endlessButtonNode.contains(location) {
                
                if gameSettings.isSound {
                    playSoundFX(clickSound)
                }
                
                self.startGame(with: .endless)
            }
        }
    }


    func updateByIndex(_ index: Int) {
        let bottle = bottles[index]

        selectedBottleIndex = index

        self.updateSelectedBottle(bottle)
        BottleController.saveSelectedBottle(selectedBottleIndex)
    }
    

    // MARK: -Старт игры
    func startGame(with gameMode: GameMode) {
        //Not shop button, then start game
        if !isShopButton {
            //Передаём выбранную бутылку
            let userData: NSMutableDictionary = ["bottle": bottles[selectedBottleIndex]]
            let gameScene = GameScene(size: self.size)
            gameScene.gameMode = gameMode
            self.changeToSceneBy(nameScene: "GameScene", userData: userData)
            
        } else {
            //show shop
            print("shop")
        }
    }
    
    
    
    
    func changeToSettings(nameScene: String) {
        let scene = (nameScene == "SettingsScene") ? SettingsScene(size: self.size) : MenuScene(size: self.size)
        
        let transition = SKTransition.fade(withDuration: 1)
        scene.scaleMode = .aspectFill
        scene.userData = userData
        
        if gameSettings.isSound {
            playSoundFX(clickSound)
        }
        
        self.view?.presentScene(scene, transition: transition)
    }
}


