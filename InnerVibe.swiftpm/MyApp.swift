import SwiftUI

@main
struct MyApp: App {
    @StateObject var appModel = AppModel()
    @StateObject var soundClassifierAppModel = SoundClassifierAppModel()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appModel)
                .environmentObject(soundClassifierAppModel)
        }
    }
}
