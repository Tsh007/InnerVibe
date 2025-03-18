import SwiftUI

struct problemView : View{
    
    @EnvironmentObject var appModel : AppModel
    
    @Binding var currentAsana : String
    
    var body: some View {
        PredictionView(currentAsana: $currentAsana)
            .environmentObject(appModel)    
    }
}
