import Foundation

class WheelGameVM: ObservableObject{
    @Published private var model: WheelGame
    @Published private(set) var turn: Int = 0
    private (set) var currentNumber: Int = -1
    
    init(){
        model = WheelGame(totalNumbers: 8, losingNumbers: [1])
    }
    
    public func spinTheWheel(){
        if(!model.hasLost){
            currentNumber = model.spinWheel()
            turn += 1
        }
    }
    
    var hasLost: Bool {
        return model.hasLost
    }
    
    var score: Int {
        return model.score
    }
    
    var totalNumbers: Int {
        return model.totalNumbers
    }
    
    func resetGame(){
        model.resetGame()
        turn = 0
    }
}
