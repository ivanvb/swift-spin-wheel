import Foundation

class WheelGameVM: ObservableObject{
    @Published private var model: WheelGame
    private (set) var currentNumber: Int = -1 {
        willSet{
            let ONE_SPIN = 360
            let minAngle = currentAngle + (ONE_SPIN * 3)
            let maxAngle = currentAngle + (ONE_SPIN * 8)
            currentAngle += Int.random(in: (minAngle...maxAngle))
        }
    }
    private var currentAngle: Int = 0
    
    init(){
        model = WheelGame(totalNumbers: 8, losingNumbers: [1])
    }
    
    public func spinTheWheel(){
        if(!model.hasLost){
            currentNumber = model.spinWheel()
        }
    }
    
    var hasLost: Bool {
        return model.hasLost
    }
    
    var score: Int {
        return model.score
    }
}
