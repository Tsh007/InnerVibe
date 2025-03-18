import SwiftUI

struct ContentView: View {
    @EnvironmentObject var appModel : AppModel
    @EnvironmentObject var soundClassifierAppModel : SoundClassifierAppModel
    var body: some View {
        IntroScreen()
            .environmentObject(appModel)
            .environmentObject(soundClassifierAppModel)
    }
}
