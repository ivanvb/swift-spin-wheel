import SwiftUI

struct WheelGameView: View {
    @ObservedObject var game: WheelGameVM
    @State var angle: Double = 0
    @State var animating = false

    private struct Constants {
        static let duration: CGFloat = 0.5
        
        static let minRotationLaps: Int = 3
        static let maxRotationLaps: Int = 12
        static let wheelOffsetPercentage: Double = 5 / 100
        
        static let wheelSize: CGFloat = 250
        static let spinButtonSize: CGFloat = 80
        static let spinButtonOffset: CGFloat = 15
        static let spinButtonTextOffset: CGFloat = 30
        static let bottomBarHeight: CGFloat = 100
        static let bottomBarOffset: CGFloat = 30
    }
    
    private var wheelSegmentSize: Double {
        return Double(360 / Double(game.totalNumbers))
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .bottom){
                VStack{
                    Text("Score: \(game.score)")
                    Text("Result: \(game.currentNumber)")
                    Text("Lost: \(game.hasLost ? "Lost" : "Not lost")")
                    Spacer()
                }.frame(width: geometry.size.width)
                
                ZStack{
                    GameWheel(numbers: game.totalNumbers)
                        .rotationEffect(Angle.degrees(angle * -1))
                    Button(action: {
                        game.spinTheWheel()
                    }){
                        ZStack{
                            Circle()
                                .fill(.red)
                                .frame(width: Constants.spinButtonSize, height: Constants.spinButtonSize)
                            Text("Spin!")
                                .padding(.bottom, Constants.spinButtonTextOffset)
                                .foregroundColor(.white)
                            
                        }
                    }
                    .disabled(animating)
                }
                .frame(width: Constants.wheelSize, height: Constants.wheelSize)
                .position(x: geometry.size.width / 2, y: geometry.size.height - Constants.spinButtonOffset)
                
                Rectangle()
                    .background(.ultraThinMaterial)
                    .frame(height: Constants.bottomBarHeight, alignment: .bottom)
                    .position(x: geometry.size.width/2, y: geometry.size.height + Constants.bottomBarOffset)
                
                
            }.onChange(of: game.currentNumber, perform: calculateSpinAgle)
        }
    }
    
    func calculateSpinAgle(selectedNumber: Int){
        let sliceSize: Double = 360 / Double(game.totalNumbers)
        let centerAngle: Double = (sliceSize * Double(selectedNumber - 1)).truncatingRemainder(dividingBy: 360);
        print(sliceSize, centerAngle)
        
        let minOffset: Double = (centerAngle - sliceSize / 2) * (1 + Constants.wheelOffsetPercentage)
        let maxOffset: Double = (centerAngle + sliceSize / 2) * (1 - Constants.wheelOffsetPercentage)
        
        let totalSpins = Int.random(in: (Constants.minRotationLaps...Constants.maxRotationLaps));
        let offset = Double.random(in: (minOffset...maxOffset));
            
        let wheelSpinning = 360 * Double(totalSpins)
        let finalAngle: Double = wheelSpinning + offset

        withAnimation(Animation.easeOut(duration: Constants.duration)){
            angle = finalAngle
            DispatchQueue.main.asyncAfter(deadline: .now() + Constants.duration) {
                        animating = false
                        angle = finalAngle - wheelSpinning
            }
        }
    }
}

struct WheelGameView_Previews: PreviewProvider {
    static let game: WheelGameVM = WheelGameVM()
    static var previews: some View {
        WheelGameView(game: game)
    }
}
