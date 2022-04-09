import SwiftUI

@main
struct WheelGameApp: App {
    private let game = WheelGameVM()
    
    var body: some Scene {
        WindowGroup {
            WheelGameView(game: game)
        }
    }
}
