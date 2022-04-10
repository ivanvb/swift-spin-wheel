import SwiftUI

struct WheelGameView: View {
    @ObservedObject var game: WheelGameVM
    @State var angle: Double = 0
    @State var animating = false
    @State var score: Int = 0
    @State var messageToUser: String = ""
    
    init(game: WheelGameVM){
        self.game = game
        self.score = game.score
    }
    
    private struct Constants {
        static let animationDuration: CGFloat = 1.5
        static let spinDuration: CGFloat = Constants.animationDuration * 0.8
        static let scoreIncreaseDuration: CGFloat = Constants.animationDuration * 0.2
        static let disabledButtonOpacity: CGFloat = 0.5
        static let resetGameDuration: CGFloat = 0.25
        
        static let minRotationLaps: Int = 2
        static let maxRotationLaps: Int = 4
        static let wheelOffsetPercentage: Double = 5 / 100
        
        static let wheelSize: CGFloat = 250
        static let spinButtonSize: CGFloat = 80
        static let spinButtonOffset: CGFloat = 15
        static let spinButtonTextOffset: CGFloat = 30
        static let bottomBarHeight: CGFloat = 100
        static let bottomBarOffset: CGFloat = 30
        static let minTextWheelSpacing: CGFloat =  Constants.wheelSize / 2 * 1.35
    }
    
    private var wheelSegmentSize: Double {
        return Double(360 / Double(game.totalNumbers))
    }
    
    private func computeRemaining(number: Int) -> Int{
        let result = round(Double(Int(number) % 360) / (360 / Double(game.totalNumbers) ))
        let clampedResult = max(Int((result + 1)) % (game.totalNumbers + 1), 1)
        
        return clampedResult
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .bottom){
                VStack{
                    HStack{
                        VStack(alignment: .leading){
                            NumberIncreaseText(prependText: "Score: " ,number: Double(score))
                            Text("High Score: \(game.highScore)")
                        }.font(Font.title2)
                        Spacer()
                    }.padding(.leading)
                    
                    Spacer()
                    Text(messageToUser)
                    NumberIncreaseText(number: angle, processingFunction: computeRemaining)
                        .font(.system(size: 104, weight: .bold, design: .default))
                    Button("Finish"){
                        game.takeCurrentScore()
                        messageToUser = "You scored"
                    }.disabled(score == 0)
                    Spacer(minLength: Constants.minTextWheelSpacing)
                }.frame(width: geometry.size.width)
                
                ZStack{
                    GameWheel(numbers: game.totalNumbers)
                        .rotationEffect(Angle.degrees(angle * -1))
                    
                    Button(action: {
                        game.hasLost ? resetGame() : game.spinTheWheel()
                    }){
                        ZStack{
                            Circle()
                                .fill(.red)
                                .frame(width: Constants.spinButtonSize, height: Constants.spinButtonSize)
                            Text(game.hasLost ? "Reset" : "Spin!")
                                .padding(.bottom, Constants.spinButtonTextOffset)
                                .foregroundColor(.white)
                            
                        }.opacity(animating ? Constants.disabledButtonOpacity : 1)
                    }
                    .disabled(animating)
                }
                .frame(width: Constants.wheelSize, height: Constants.wheelSize)
                .position(x: geometry.size.width / 2, y: geometry.size.height - Constants.spinButtonOffset)
                
                Rectangle()
                    .background(.ultraThinMaterial)
                    .frame(height: Constants.bottomBarHeight, alignment: .bottom)
                    .position(x: geometry.size.width/2, y: geometry.size.height + Constants.bottomBarOffset)
                
                
            }.onChange(of: game.turn, perform: { _ in
                if(game.turn != 0){
                    let chosenNumber = game.currentNumber
                    let (finalAngle, wheelSpinning) = calculateSpinAgle(selectedNumber: chosenNumber)
                    
                    withAnimation(Animation.easeOut(duration: Constants.spinDuration)){
                        angle = finalAngle
                        animating = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + Constants.spinDuration) {
                            angle = finalAngle - wheelSpinning
                            
                            withAnimation(Animation.easeOut(duration: Constants.scoreIncreaseDuration)){
                                score = game.score
                                animating = false
                                if(game.hasLost){
                                    messageToUser = "You Lost"
                                }
                            }
                        }
                    }
                } else {
                    withAnimation{
                        score = game.score
                    }
                }
            })
        }
    }
    
    func calculateSpinAgle(selectedNumber: Int) -> (Double, Double){
        let sliceSize: Double = 360 / Double(game.totalNumbers)
        let centerAngle: Double = (sliceSize * Double(selectedNumber - 1)).truncatingRemainder(dividingBy: 360);
        
        let minOffset: Double = (centerAngle - sliceSize / 2) * (1 + Constants.wheelOffsetPercentage)
        let maxOffset: Double = (centerAngle + sliceSize / 2) * (1 - Constants.wheelOffsetPercentage)
        
        let totalSpins = Int.random(in: (Constants.minRotationLaps...Constants.maxRotationLaps));
        let offset = Double.random(in: (minOffset...maxOffset));
        
        let wheelSpinning = 360 * Double(totalSpins)
        let finalAngle: Double = wheelSpinning + offset
        
        return (finalAngle, wheelSpinning)
    }
    
    func resetGame(){
        messageToUser = ""
        game.resetGame()
        withAnimation(Animation.easeOut(duration: Constants.resetGameDuration)){
            angle = 0
        }
    }
}

struct NumberIncreaseText: View, Animatable{
    var prependText: String? = ""
    var number: Double
    var processingFunction: ((Int) -> Int)?
    
    var animatableData: Double {
        get { number }
        set { number = newValue }
    }
    
    var calculatedNumber: Int {
        if (processingFunction != nil) {
            return processingFunction!(Int(animatableData))
        } else {
            return Int(animatableData)
        }
    }
    var body: some View {
        Text("\(prependText!)\(calculatedNumber)")
    }
}

struct WheelGameView_Previews: PreviewProvider {
    static let game: WheelGameVM = WheelGameVM()
    static var previews: some View {
        WheelGameView(game: game)
    }
}

