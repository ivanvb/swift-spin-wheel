import SwiftUI

struct GameWheel: View {
    var numbers: Int = 6
    
    var body: some View {
        ZStack{
            Circle()
                .stroke(.blue, lineWidth: 5)
            ForEach(1...numbers, id: \.self) { number in
                CircleLabel(label: String(number), position: number - 1, total: numbers)
            }
        }
    }
    
    func CircleLabel(label: String, position: Int, total: Int) -> some View{
        let angle: Double = 360 / Double(total) * Double(position);
        let sliceSize: Double = Double(360 / Double(numbers))
        
        return ZStack{
            VStack{
                Text(label)
                Spacer()
            }
            .padding(10)
            .rotationEffect(Angle.degrees(angle))
            
            WheelSegment(
                startAngle: Angle.degrees(0),
                endAngle: Angle.degrees(Double(position + 1) * sliceSize),
                clockwise: true
            )
            .stroke(.blue, lineWidth: 2)
            .rotationEffect(Angle.degrees((sliceSize / 2 + 90) * -1))
        }
    }
}

struct GameWheel_Previews: PreviewProvider {
    static var previews: some View {
        GameWheel()
            .frame(width: 250, height: 250, alignment: .center)
    }
}
