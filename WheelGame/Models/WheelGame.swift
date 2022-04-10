import Foundation

struct WheelGame{
    private static let MAX_SCORE_KEY: String = "highScore"
    private (set) var score: Int = 0
    private (set) var totalNumbers: Int
    private var losingNumbers: Array<Int>
    private (set) var hasLost: Bool = false
    private (set) var highScore: Int = UserDefaults.standard.object(forKey: WheelGame.MAX_SCORE_KEY) as? Int ?? 0
    
    init(totalNumbers: Int, losingNumbers: Array<Int>){
        self.totalNumbers = max(6, totalNumbers)
        self.losingNumbers = losingNumbers.count > 0 ? losingNumbers : [1]
    }
    
    mutating func spinWheel() -> Int {
        let result = Int.random(in: (1...totalNumbers))
        updateScore(result)
        if(score == 0){
            hasLost = true
        }
        return result
    }
    
    private mutating func updateScore(_ result: Int){
        if(losingNumbers.contains(result)){
            score = 0
        } else {
            score += result
        }
    }
    
    mutating func resetGame(){
        score = 0
        hasLost = false
    }
    
    mutating func takeCurrentScore(){
        updateHighScore()
        score = 0
        hasLost = true
    }
    
    mutating private func updateHighScore(){
        if(score > highScore){
            UserDefaults.standard.set(score, forKey: WheelGame.MAX_SCORE_KEY)
            highScore = score
        }
    }
}
