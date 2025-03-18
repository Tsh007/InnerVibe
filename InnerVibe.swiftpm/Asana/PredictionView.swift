import SwiftUI

struct PredictionView: View {
    
    @EnvironmentObject var appModel : AppModel
    
    @Binding var currentAsana : String
    
    var body : some View{
        VStack{
            ZStack{
                CameraView()
                    .environmentObject(appModel)
                    .onChange(of : appModel.predictionLabel){ _ in
                        updateYourMove(with : appModel.predictionLabel)
                    }
                    .overlay(alignment : .bottom){
                        VStack{
                            PredictionLabelOverlay(label : appModel.predictionLabel,currentAsana: $currentAsana)
                                .frame(maxWidth : .infinity,alignment : .trailing)
                        }
                    }
            }
        }
    }
    private func updateYourMove(with predictionLabel : String){
        guard !predictionLabel.isEmpty else{
            return 
        }
    }
}
