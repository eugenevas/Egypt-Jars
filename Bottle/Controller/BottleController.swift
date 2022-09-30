
import Foundation

class BottleController {
    
    class func readItems() -> [Bottle] {
        
        var bottles = [Bottle]()
        
        
        if let path = Bundle.main.path(forResource: "Items", ofType: "plist"), let plistArray = NSArray(contentsOfFile: path) as? [[String: Any]] {
            
            for dic in plistArray {
                let bottle = Bottle(dic as NSDictionary)
                bottles.append(bottle)
                
            }
        }
        
        return bottles
    }
    
    class func saveSelectedBottle(_ index: Int) {
        //Save Index
        UserDefaults.standard.setValue(index, forKey: "selectedBottle")
        UserDefaults.standard.synchronize()
    }
    
    
    class func getSaveBottleIndex() -> Int {
        //Get saved index
        return UserDefaults.standard.integer(forKey: "selectedBottle")
    }
}
