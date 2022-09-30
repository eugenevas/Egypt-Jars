
import SpriteKit
import UIKit

enum GameMode {
    case history
    case endless
    case none
}

class GameScene: SimpleScene {
    
    var gameMode: GameMode = .none
    
    lazy var countdownLabel: SKLabelNode = {
        var label = SKLabelNode(fontNamed: "Futura-Bold")
        label.fontSize = 80
        label.fontColor = #colorLiteral(red: 0.9409231544, green: 0.7746657729, blue: 0.1266352236, alpha: 1)
        label.zPosition = 3
        label.text = "\(counterStartValue)"
        
        return label
    }()
    
    var counter = 0
    var counterTimer = Timer()
    var counterStartValue = 5
    var isCountOver = false
    
    var coinsEmitter: SKEmitterNode?
    
    var levelLabelNode: SKLabelNode!
    var scoreLabelNode = SKLabelNode()
    var highscoreLabelNode = SKLabelNode()
    var backButtonNode = SKSpriteNode()
    var resetButtonNode = SKSpriteNode()
    var buttonNode = SKSpriteNode()
    var tutorialNode = SKSpriteNode()
    var bottleNode = SKSpriteNode()
    
    
    
    var didSwipe = false
    var start = CGPoint.zero
    var startTime = TimeInterval()
    
    var level = 0 {
        didSet {
            
            if levelLabelNode == nil {
                createLevel()
            }
            
            levelLabelNode.text = "Level: \(level)"
        }
    }
    
    
    var currentScore = 0 {
        
        didSet {
            
            if gameMode == .history {
                switch currentScore {
                case 1:
                    winGame()
                default:
                    break
                }
                
                switch level {
                case 2:
//                    createGood()
                    if gameSettings.isSound {
                        playSoundFX(clickSound)
                    }
               
                
                default:
                    break
                }
            }
    }
        
    }
    
    
    
    var backgroundMusic: SKAudioNode!
    
    var clickSound = SKAction()
    var failSound = SKAction()
    var winSound = SKAction()
    
    override func didMove(to view: SKView) {
        //Setting the scene
        gameSettings.loadGameSettings()
        
        if gameSettings.isMusic && backgroundMusic == nil {
            if let musicURL = Bundle.main.url(forResource: "backgroundMusic", withExtension: "mp3") {
                backgroundMusic = SKAudioNode(url: musicURL)
                addChild(backgroundMusic)
            }
        }
        
        self.physicsBody?.restitution = 0
       
        let background = SKSpriteNode(imageNamed: "bg")
        background.anchorPoint = .zero
        background.size = view.frame.size
        background.zPosition = 0
        self.addChild(background)
        
        
        let coin = SKSpriteNode(imageNamed: "coin")
        coin.anchorPoint = .zero
        coin.zPosition = 5
        coin.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
//        addChild(coin)
        
        self.setupUINodes()
        self.setupGameNodes()
        
        clickSound = SKAction.playSoundFileNamed(GAME_SOUND_CLICK, waitForCompletion: false)
        failSound = SKAction.playSoundFileNamed(GAME_SOUND_FAIL, waitForCompletion: false)
        winSound = SKAction.playSoundFileNamed(GAME_SOUND_SUCCESS, waitForCompletion: false)
    }
    
    
    //Создание лейблов
    func setupUINodes() {
        //Score label node
        scoreLabelNode = LabelNode(text: "0", fontSize: 140,
                                   position: CGPoint(x: self.frame.midX, y: self.frame.midY + 190),
                                   zPosition: 3, fontColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1))!
        self.addChild(scoreLabelNode)
        
        
        
        
        
        //Back button
        backButtonNode = ButtonNode(imageNode: "back",
                                    position: CGPoint(x: self.frame.minX + backButtonNode.size.width + 40, y: self.frame.maxY - backButtonNode.size.height - 50),
                                    zPosition: 3,
                                    xScale: 1, yScale: 1)
        self.addChild(backButtonNode)
        
        //Reset button
//        resetButtonNode = ButtonNode(imageNode: "reset",
//                                     position: CGPoint(x: self.frame.maxX - resetButtonNode.size.width - 40, y: self.frame.maxY - resetButtonNode.size.height - 40),
//                                     zPosition: 3,
//                                     xScale: 1, yScale: 1)
//        self.addChild(resetButtonNode)
        
        
        setupTimer()
    }
    
    // MARK: - Создание стола и бутылки
    func setupGameNodes() {
        //Table node
        let tableNode = SKSpriteNode(imageNamed: "table")
        
        let offsetX = tableNode.frame.size.width * tableNode.anchorPoint.x
        let offsetY = tableNode.frame.size.height * tableNode.anchorPoint.y
        
        let path = CGMutablePath()
        path.move(to: CGPoint(x: 0 - offsetX, y: 147 - offsetY))
        path.addLine(to: CGPoint(x: 120 - offsetX, y: 241 - offsetY))
        path.addLine(to: CGPoint(x: 156 - offsetX, y: 276 - offsetY))
        path.addLine(to: CGPoint(x: 187 - offsetX, y: 307 - offsetY))
        path.addLine(to: CGPoint(x: 234 - offsetX, y: 349 - offsetY))
        path.addLine(to: CGPoint(x: 248 - offsetX, y: 369 - offsetY))
        path.addLine(to: CGPoint(x: 283 - offsetX, y: 390 - offsetY))
        path.addLine(to: CGPoint(x: 305 - offsetX, y: 400 - offsetY))
        path.addLine(to: CGPoint(x: 277 - offsetX, y: 494 - offsetY))
        path.addLine(to: CGPoint(x: 499 - offsetX, y: 496 - offsetY))
        path.addLine(to: CGPoint(x: 479 - offsetX, y: 409 - offsetY))
        path.addLine(to: CGPoint(x: 505 - offsetX, y: 390 - offsetY))
        path.addLine(to: CGPoint(x: 552 - offsetX, y: 340 - offsetY))
        path.addLine(to: CGPoint(x: 610 - offsetX, y: 286 - offsetY))
        path.addLine(to: CGPoint(x: 664 - offsetX, y: 252 - offsetY))
        path.addLine(to: CGPoint(x: 689 - offsetX, y: 234 - offsetY))
        path.addLine(to: CGPoint(x: 715 - offsetX, y: 206 - offsetY))
        path.addLine(to: CGPoint(x: 734 - offsetX, y: 166 - offsetY))
        path.addLine(to: CGPoint(x: 746 - offsetX, y: 135 - offsetY))
        path.addLine(to: CGPoint(x: 748 - offsetX, y: 129 - offsetY))
        path.addLine(to: CGPoint(x: 747 - offsetX, y: 2 - offsetY))
        path.closeSubpath()
        tableNode.physicsBody = SKPhysicsBody(polygonFrom: path)
        
//        tableNode.physicsBody = SKPhysicsBody(rectangleOf: (tableNode.texture?.size())!)
        
        tableNode.physicsBody?.affectedByGravity = false
        tableNode.physicsBody?.isDynamic = false
        tableNode.physicsBody?.restitution = 0
        tableNode.xScale = 0.45
        tableNode.yScale = 0.45
        tableNode.zPosition = 2
        tableNode.position = CGPoint(x: self.frame.midX - 5, y: self.frame.minY + 12)  //CGPoint(x: self.frame.midX, y: 29)
        self.addChild(tableNode)
        
        // MARK: -selectedBottle
        //Считываем выбранную бутылку из меню
        let selectedBottle = self.userData?.object(forKey: "bottle")
        
        guard let bottle = selectedBottle as? Bottle else {
            return
        }

        bottleNode = BottleNode(bottle)
        
        bottleNode.name = "bottleContainer"
        bottleNode.zPosition = 1
        addChild(bottleNode)
        
        resetBottle()
    }
    
    // MARK: -Touches
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //Start recording touches
        if touches.count > 1 {
            return
        }
        
        let touch = touches.first
        let location = touch!.location(in: self)
        
        start = location
        startTime = touch!.timestamp
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
            
            if ((resetButtonNode.contains(location)) && didSwipe == true) {
                if gameSettings.isSound {
                    playSoundFX(clickSound)
                }
                self.changeToSceneBy(nameScene: "GameOverScene", userData: self.userData!)
                
                failedFlip()
            }
            
            
//            if tutorialNode.contains(location) {
//                tutorialNode.isHidden = true
//                UserDefaults.standard.set(true, forKey: "tutorialFinished")
//                UserDefaults.standard.synchronize()
//            }
        }
        
        //Bottle flipping logic
        if !didSwipe {
            //Скорость = расстояние/время
            //Расстояние = sqrt(x*x+y*y)
            //x = Хк - Хн
            let touch = touches.first
            let location = touch?.location(in: self) //Хк
            
            let x = ceil(location!.x - start.x)
            let y = ceil(location!.y - start.y)
            
            let distance = sqrt(x*x + y*y)
            let time = CGFloat(touch!.timestamp - startTime)
            
            if (distance >= GAME_SWIPE_MIN_DISTANCE && y > 0) {
                let speed = distance / time
                
                if speed >= GAME_SWIPE_MIN_SPEED {
                    //Add angular velocity and impulse
                    bottleNode.physicsBody?.angularVelocity = GAME_ANGULAR_VELOCITY
                    bottleNode.physicsBody?.applyImpulse(CGVector(dx: 0, dy: distance * GAME_DISTANCE_MULTIPLIER))
                    didSwipe = true
                }
            }
        }
    }
    
    // MARK: -Неудачный флип
    func failedFlip() {
        //Failed flips, reset score and bottle
        
        if gameSettings.isSound {
            self.playSoundFX(failSound)
        }
        
        self.updateScore()
        self.resetBottle()
        
//        successFlip()
        gameOver()
    }
    
    func resetBottle() {
        //Reset bottle after a failed or successful flip
        bottleNode.position = CGPoint(x: self.frame.midX, y: bottleNode.size.height) //bottleNode.size.height
        bottleNode.physicsBody?.angularVelocity = 0
        bottleNode.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        bottleNode.speed = 0
        bottleNode.zRotation = 0
        didSwipe = false
        
        if gameSettings.isSound {
            self.playSoundFX(clickSound)
        }
        
    }
    
    func gameOver() {
        let gameOverScene = GameOverScene(size: self.size)
        gameOverScene.userData = userData
        
        gameOverScene.scaleMode = .aspectFill
        let transition = SKTransition.crossFade(withDuration: 0.3)
        self.scene!.view?.presentScene(gameOverScene, transition: transition)
        
        physicsWorld.speed = 0
        isUserInteractionEnabled = false
    }
    
    
    func gameWin() {
        //Когда побит рекорд
        let winLabel = SKSpriteNode(imageNamed: "win")
        winLabel.position = CGPoint(x: self.frame.midX, y: self.frame.midY + 100)
        winLabel.setScale(0.3)
        winLabel.zPosition = 1
        self.addChild(winLabel)
        
        let fadeInAction = SKAction.fadeIn(withDuration: 0.3)
        let waitAction = SKAction.wait(forDuration: 1)
        let fadeOutAction = SKAction.fadeOut(withDuration: 0.3)
        let sequence = SKAction.sequence([fadeInAction, waitAction, fadeOutAction])
        winLabel.run(sequence)
    }
    
    
    func winGame() {
        
    }
    
    // MARK: - Создание лейбла уровня
    func createLevel() {
        levelLabelNode = SKLabelNode(text: "Level \(level)")
        levelLabelNode?.fontName = "Apple SD Gothic Neo Bold"
        levelLabelNode?.fontSize = 30
        levelLabelNode?.zPosition = 10
        levelLabelNode?.position = CGPoint(x: self.size.width * 0.5, y: self.size.height - 70)
        //        levelLabel.run(SKAction.fadeOut(withDuration: 5))
        addChild(levelLabelNode)
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        self.checkIfSuccessfulFlip()
    }
    
    func checkIfSuccessfulFlip() {
        if (bottleNode.position.x <= 0 || bottleNode.position.x >= self.frame.size.width || bottleNode.position.y <= 0) {
            self.failedFlip()
        }
        
        if (didSwipe && bottleNode.physicsBody!.isResting) {
            let bottleRotation = abs(Float(bottleNode.zRotation))
            
            if bottleRotation > 0 && bottleRotation < 0.05 {
                self.successFlip()
            } else {
                self.failedFlip()
            }
        }
    }
    
    // MARK: -Удачный флип
    func successFlip() {
        //Successfilly flipped, so update scores & reset bottles
        if gameSettings.isSound {
            self.playSoundFX(winSound)
        }
        
        self.updateFlips()
        
        currentScore += 1
        
        if currentScore % 2 == 0 {
            print("currentScore: \(currentScore)")
            startCounter()
            countdownLabel.alpha = 1
        }
        
//        countdownLabel.alpha = 1
//        startCounter()
        updateScore()
        resetBottle()
        
        addFallingCoins()
    }
    
    
    private func addFallingCoins() {
        coinsEmitter = SKEmitterNode(fileNamed: "Coins")
        if let coinsEmitter = coinsEmitter {
            coinsEmitter.setScale(4.0)
//            coinsEmitter.position = CGPoint(x: self.frame.midX, y: self.frame.maxY)
            coinsEmitter.position = CGPoint(x: bottleNode.size.width / 2 - 50, y: bottleNode.size.height + 70)
            coinsEmitter.zPosition = 5
            bottleNode.addChild(coinsEmitter)

//            let fadeInAction = SKAction.fadeIn(withDuration: 0.2)
//            let waitAction = SKAction.wait(forDuration: 5)
////            let fadeOutAction = SKAction.fadeOut(withDuration: 0.1)
//            let sequence = SKAction.sequence([fadeInAction, waitAction])
//            coinsEmitter.run(sequence)
            
            removeFallingCoins()
        }
    }
    
    private func removeFallingCoins() {
        coinsEmitter?.run(SKAction.wait(forDuration: 2.0), completion: { [unowned self] in
            self.coinsEmitter?.removeFromParent()
        })
    }
    
    func updateScore() {
        //Updating score based on flips and saving highscore
        scoreLabelNode.text = "\(currentScore)"
        
        let localHighscore = UserDefaults.standard.integer(forKey: "localHighscore")
        
        if currentScore > localHighscore {
            highscoreLabelNode.isHidden = false
            
            gameWin()
            
            let fadeAction = SKAction.fadeAlpha(to: 0, duration: 1.0)
            
            highscoreLabelNode.run(fadeAction, completion: {
                self.highscoreLabelNode.isHidden = true
            })
            
            UserDefaults.standard.set(currentScore, forKey: "localHighscore")
            UserDefaults.standard.synchronize()
        }
    }
    
    
    func updateFlips() {
        //Update total flips
        var flips = UserDefaults.standard.integer(forKey: "flips")
        
        flips += 1
        UserDefaults.standard.set(flips, forKey: "flips")
        UserDefaults.standard.synchronize()
    }
    
}

// MARK: -Таймер
extension GameScene {
    
    func setupTimer() {
        countdownLabel.position = CGPoint(x: self.frame.midX + 120, y: self.frame.minY + 150)
        countdownLabel.alpha = 0
        addChild(countdownLabel)
        
//        counter = counterStartValue
    }
    
//    Этот метод вызвать в методе, где считаются удачные флипы
    func startCounter() {
        isCountOver = false
        counter = counterStartValue
        countdownLabel.text = "\(counter)"
        counterTimer.invalidate()
        counterTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(decrementCounter), userInfo: nil, repeats: true)
    }
    
    @objc func decrementCounter() {
        if !isCountOver {
            counter -= 1
            countdownLabel.text = "\(counter)"
    
            if counter <= 0 {
                isCountOver = true
                countOver(won: false)
                spawnArrow()
    
//                let fadeInAction = SKAction.fadeIn(withDuration: 0.2)
                let waitAction = SKAction.wait(forDuration: 0.2)
                let fadeOutAction = SKAction.fadeOut(withDuration: 0.2)
                let sequence = SKAction.sequence([waitAction, fadeOutAction])
                countdownLabel.run(sequence)
            }
        }
    }
    
    func countOver(won: Bool) {
        print("Count over with status: \(won)")
    }
}


// MARK: -Стрела
extension GameScene {
    private func spawnArrow() {
    //        let spawnArrowAction = SKAction.run {
    //            let arrow = Arrow.createArrow(at: CGPoint(x: self.frame.size.width,
    //                                                      y: self.frame.size.height * 0.25))
    //            arrow.name = "arrow"
    //            arrow.isUserInteractionEnabled = false
    //            self.addChild(arrow)
    //        }
    //        let spawnArrowWait = SKAction.wait(forDuration: 5)
    //        let spawnArrowSequence = SKAction.sequence([spawnArrowAction, spawnArrowWait])
    //        let spawnArrowForever = SKAction.repeatForever(spawnArrowSequence)
    //
    //        run(spawnArrowForever)
        let arrow = Arrow.createArrow(at: CGPoint(x: self.frame.size.width,
                                                  y: self.frame.size.height * 0.25))
        arrow.name = "arrow"
        arrow.isUserInteractionEnabled = false
        self.addChild(arrow)
    }
    
    override func didSimulatePhysics() {
        enumerateChildNodes(withName: "arrow") { (node, stop) in
            if node.position.x < -100 {
                node.removeFromParent()
            }
        }
    }
}


// MARK: - Столкновения
extension GameScene: SKPhysicsContactDelegate {
    
//    func didBegin(_ contact: SKPhysicsContact) {
//
//        let contactCategory: BitMaskCategory = [contact.bodyA.category, contact.bodyB.category]
//
//        switch contactCategory {
//        case [.arrow, .bottle]:
//
//            if contact.bodyA.node?.name == "sprite" {
//                if contact.bodyA.node?.parent != nil {
//                    contact.bodyA.node?.removeFromParent()
//
//                    if gameSettings.isSound {
//                        self.run(SKAction.playSoundFileNamed("fail", waitForCompletion: false))
//                    }
//                    print("Collision Detected")
//                    gameOver()
//                }
//            } else {
//                if contact.bodyB.node?.parent != nil {
//                    contact.bodyB.node?.removeFromParent()
//
//                    if gameSettings.isSound {
//                        self.run(SKAction.playSoundFileNamed("fail", waitForCompletion: false))
//                    }
//                    print("Collision Detected")
//                    gameOver()
//                }
//            }
//
//
//        default:
//            preconditionFailure("Unable to detect collision category")
//        }
//
//    }
}
