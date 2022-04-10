import Foundation

struct WheelGame{
    private (set) var score: Int = 0 {
        didSet{
            if(oldValue > 0 && score == 0){
                hasLost = true
            }
        }
    }
    private (set) var totalNumbers: Int
    private var losingNumbers: Array<Int>
    private (set) var hasLost: Bool = false
    
    init(totalNumbers: Int, losingNumbers: Array<Int>){
        self.totalNumbers = max(6, totalNumbers)
        self.losingNumbers = losingNumbers.count > 0 ? losingNumbers : [1]
    }
    
    mutating func spinWheel() -> Int {
        let result = Int.random(in: (1...totalNumbers))
        updateScore(result)
        return result
    }
    
    private mutating func updateScore(_ result: Int){
        if(losingNumbers.contains(result)){
            score = 0
        } else {
            score += result
        }
    }
}
