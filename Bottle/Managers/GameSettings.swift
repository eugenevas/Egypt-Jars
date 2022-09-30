
import UIKit

class GameSettings: NSObject {
    
    let ud = UserDefaults.standard
    
    var isMusic = false //true - по дефолту музыка включена
    var isSound = true
    
    let musicKey = "music"
    let soundKey = "sound"
    
    var highscore: [Int] = []
    var currentScore = 0
    let highscoreKey = "highscore"
    
    override init() {
        super.init()
        
        loadGameSettings()
        loadScores()
    }
    
    func saveScores() {
        highscore.append(currentScore)
        
        //$0 > $1 - каждый левый элемент больше правого
        //.prefix(3) - массив из трёх элементов
        highscore = Array(highscore.sorted { $0 > $1 }.prefix(3))
        
        ud.set(highscore, forKey: highscoreKey)
        ud.synchronize()
    }
    
    func loadScores() {
        guard ud.value(forKey: highscoreKey) != nil else { return }
        highscore = ud.array(forKey: highscoreKey) as! [Int]
    }
    
    //Сохранить данные
    func saveGameSettings() {
        ud.set(isMusic, forKey: musicKey)
        ud.set(isSound, forKey: soundKey)
    }
    
    //Загрузить данные
    func loadGameSettings() {
        guard ud.value(forKey: musicKey) != nil && ud.value(forKey: soundKey) != nil else { return }
        isMusic = ud.bool(forKey: musicKey)
        isSound = ud.bool(forKey: soundKey)
    }
    
    
}

