import SwiftUI

struct WheelGameView: View {
    @ObservedObject var game: WheelGameVM
    @State var angle: Double = 0.0
    @State var animating = false
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .bottom){
                VStack{
                    Text("Score: \(game.score)")
                    Text("Result: \(game.currentNumber)")
                    Text("Lost: \(game.hasLost ? "Lost" : "Not lost")")
                    Spacer()
                    Text("Spinner!")
                        .rotationEffect(Angle.degrees(angle))
                    
                }.frame(width: geometry.size.width)
                ZStack{
                    GameWheel(numbers: 8)
                    Button(action: {
                        game.spinTheWheel()
                        //                            withAnimation(Animation.easeOut(duration: DrawingConstants.duration )){
                        //                                angle = 360.0
                        //                                animating = true
                        //                                DispatchQueue.main.asyncAfter(deadline: .now() + DrawingConstants.duration) {
                        //                                    animating = false
                        //                                    angle = 0
                        //                                }
                        //                            }
                    }){
                        ZStack{
                            Circle()
                                .fill(.red)
                                .frame(width: 80, height: 80)
                            Text("Spin!")
                                .padding(.bottom, 30)
                                .foregroundColor(.white)
                            
                        }
                    }
                    .disabled(animating)
                }
                .frame(width: 250, height: 250)
                .position(x: geometry.size.width / 2, y: geometry.size.height - 15)
                Rectangle()
                    .background(.ultraThinMaterial)
                    .frame(height: 100, alignment: .bottom)
                    .position(x: geometry.size.width/2, y: geometry.size.height + 30)
            }
        }
    }
    
    struct DrawingConstants {
        static var duration: CGFloat = 0.5
    }
}

struct WheelGameView_Previews: PreviewProvider {
    static let game: WheelGameVM = WheelGameVM()
    static var previews: some View {
        WheelGameView(game: game)
    }
}
