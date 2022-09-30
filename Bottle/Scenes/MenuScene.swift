
import SpriteKit

class MenuScene: SimpleScene {

    var playButtonNode = SKSpriteNode()
    var settingsButtonNode = SKSpriteNode()
    var leftButtonNode = SKSpriteNode()
    var rightButtonNode = SKSpriteNode()
    var flipsTagNode = SKSpriteNode()
    var unlockLabelNode = SKLabelNode()

    var tableNode = SKSpriteNode()
    var bottleNode = SKSpriteNode()

    var highscore = 0
    var totalFlips = 0
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

        //Get total flips
        highscore = UserDefaults.standard.integer(forKey: "localHighscore")
        totalFlips = UserDefaults.standard.integer(forKey: "flips")

        clickSound = SKAction.playSoundFileNamed(GAME_SOUND_CLICK, waitForCompletion: false)


        setupUI()
    }


    func setupUI() {
//        let logo = ButtonNode(imageNode: "logo",
//                              position: CGPoint(x: self.frame.midX, y: self.frame.maxY - 70),
//                              zPosition: 3,
//                              xScale: 2.0, yScale: 2.0)
//        self.addChild(logo)


        let bestScoreLabelNode = LabelNode(text: "Best result",
                                           fontSize: 24, position:
                                            CGPoint(x: self.frame.midX - 100, y: self.frame.maxY - 70),  //150
                                           zPosition: 3,
                                           fontColor: .white)!
        self.addChild(bestScoreLabelNode)


        let highScoreLabelNode = LabelNode(text: String(highscore),
                                           fontSize: 50,
                                           position: CGPoint(x: self.frame.midX - 100, y: self.frame.maxY - 120),  //200
                                           zPosition: 3,
                                           fontColor: .white)!
        self.addChild(highScoreLabelNode)
        
        let totalFlipsLabelNode = LabelNode(text: "Count of flips",
                                            fontSize: 24,
                                            position: CGPoint(x: self.frame.midX + 80, y: self.frame.maxY - 70), //150
                                            zPosition: 3,
                                            fontColor: .white)!
        self.addChild(totalFlipsLabelNode)


        let flipsLabelNode = LabelNode(text: String(totalFlips),
                                       fontSize: 50,
                                       position: CGPoint(x: self.frame.midX + 80, y: self.frame.maxY - 120),  //200
                                       zPosition: 3,
                                       fontColor: .white)!
        self.addChild(flipsLabelNode)


        // MARK: -Buttons
        //Play button
        playButtonNode = ButtonNode(imageNode: "play",
                                    position: CGPoint(x: self.frame.midX, y: self.frame.midY + 90),
                                    zPosition: 1,
                                    xScale: 1.2, yScale: 1.2)
        addChild(playButtonNode)
        
    
        
        settingsButtonNode = ButtonNode(imageNode: "settings",
                                        position: CGPoint(x: self.frame.midX, y: self.frame.midY + 20),
                                        zPosition: 1,
                                        xScale: 1.2, yScale: 1.2)
        addChild(settingsButtonNode)
        
        //Left button
        leftButtonNode = ButtonNode(imageNode: "left",
                                    position: CGPoint(x: self.frame.midX + leftButtonNode.size.width - 130, y: self.frame.minY - leftButtonNode.size.height + 160),
                                    zPosition: 1,
                                    xScale: 1.0, yScale: 1.0)
        self.changeButton(leftButtonNode, state: false)
        addChild(leftButtonNode)

        //Right button
        rightButtonNode = ButtonNode(imageNode: "right",
                                     position: CGPoint(x: self.frame.midX + rightButtonNode.size.width + 130, y: self.frame.minY - rightButtonNode.size.height + 160),
                                     zPosition: 1,
                                     xScale: 1.0, yScale: 1.0)
        self.changeButton(rightButtonNode, state: true)
        addChild(rightButtonNode)


        //Lock Node
        flipsTagNode = ButtonNode(imageNode: "lock",
                                  position: CGPoint(x: self.frame.midX + bottleNode.size.width * 0.3, y: self.frame.minY + bottleNode.size.height * 3),
                                  zPosition: 1,
                                  xScale: 1.5, yScale: 1.5)
        flipsTagNode.zPosition = 5
        addChild(flipsTagNode)

        //Unlock Label
        unlockLabelNode = LabelNode(text: "0",
                                    fontSize: 22,
                                    position: CGPoint(x: 0, y: unlockLabelNode.frame.size.height - 15),
                                    zPosition: 10,
                                    fontColor: .white)!
        flipsTagNode.addChild(unlockLabelNode)


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

        //Пульсирующая анимация замка
        self.pulseLockNode(flipsTagNode)
    }

    // MARK: -Change arrow opacity
    func changeButton(_ buttonNode: SKSpriteNode, state: Bool) {
        var buttonColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.2)

        if state {
            buttonColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        }

        buttonNode.color = buttonColor
        buttonNode.colorBlendFactor = 1
    }


    func updateSelectedBottle(_ bottle: Bottle) {
        //Unlock flips
        let unlockFlips = bottle.MinFlips!.intValue - highscore
        let unlocked = (unlockFlips <= 0)

        flipsTagNode.isHidden = unlocked
        unlockLabelNode.isHidden = unlocked


        bottleNode.texture = SKTexture(imageNamed: bottle.Sprite!)
        //если заблокировано, то показывать кнопку магазина
        playButtonNode.texture = SKTexture(imageNamed: (unlocked ? "play" : "shop"))

        isShopButton = !unlocked



        bottleNode.size = CGSize(width: (bottleNode.texture?.size().width)! * CGFloat(bottle.XScale!.floatValue),
                                 height: (bottleNode.texture?.size().height)! * CGFloat(bottle.YScale!.floatValue))

        bottleNode.position = CGPoint(x: self.frame.midX,
                                      y: self.frame.minY + bottleNode.size.height/2 + 120)

        flipsTagNode.position = CGPoint(x: self.frame.midX,
                                        y: self.frame.minY + bottleNode.size.height * 0.5 + 100)

        unlockLabelNode.text = "\(bottle.MinFlips?.intValue ?? 0)"
        unlockLabelNode.position = CGPoint(x: 0, y: unlockLabelNode.frame.size.height - 35)



        self.updateArrowsState()
    }

    func updateArrowsState() {
        self.changeButton(leftButtonNode, state: Bool(truncating: selectedBottleIndex as NSNumber))
        self.changeButton(rightButtonNode, state: selectedBottleIndex != totalBottles - 1)
    }

    // MARK: -touchesBegan
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {

            let location = touch.location(in: self)
//            let node = self.atPoint(location)
            
            //Transiiton to game scene
            if playButtonNode.contains(location) {
                
                if gameSettings.isSound {
                    playSoundFX(clickSound)
                }
                
                changeToModes(nameScene: "GameModes")  //GameModes
//                self.startGame()
            }
            
            
            
            if settingsButtonNode.contains(location) {
               changeToSettings(nameScene: "SettingsScene")
            }
            
//

            //Left button pressed
            if leftButtonNode.contains(location) {
                let prevIndex = selectedBottleIndex - 1
                if prevIndex >= 0 {
                    
                    if gameSettings.isSound {
                        playSoundFX(clickSound)
                    }
                    
                    self.updateByIndex(prevIndex)
                }
            }

            //Right button pressed
            if rightButtonNode.contains(location) {
                let nextIndex = selectedBottleIndex + 1
                if nextIndex < totalBottles {
                    
                    if gameSettings.isSound {
                        playSoundFX(clickSound)
                    }
                    
                    self.updateByIndex(nextIndex)
                }
            }
            
            
        }
    }


    func updateByIndex(_ index: Int) {
        let bottle = bottles[index]

        selectedBottleIndex = index

        self.updateSelectedBottle(bottle)
        BottleController.saveSelectedBottle(selectedBottleIndex)
    }

    //Пульсирующий замок
    func pulseLockNode(_ node: SKSpriteNode) {
        let scaleDownAction = SKAction.scale(to: 2.0, duration: 0.5)
        let scaleUpAction = SKAction.scale(to: 1.5, duration: 0.5)

        let seq = SKAction.sequence([scaleDownAction, scaleUpAction])
        node.run(SKAction.repeatForever(seq))
    }

    // MARK: -Старт игры
    func startGame() {
        //Not shop button, then start game
        if !isShopButton {
            //Передаём выбранную бутылку
            let userData: NSMutableDictionary = ["bottle": bottles[selectedBottleIndex]]
            self.changeToSceneBy(nameScene: "GameModes", userData: userData)
        } else {
            //show shop
            print("shop")

        }
    }
    
    func changeToModes(nameScene: String) {
        let scene = (nameScene == "GameModes") ? GameModes(size: self.size) : MenuScene(size: self.size)
        
        let transition = SKTransition.fade(withDuration: 1)
        scene.scaleMode = .aspectFill
        scene.userData = userData
        
        if gameSettings.isSound {
            playSoundFX(clickSound)
        }
        
        self.view?.presentScene(scene, transition: transition)
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

