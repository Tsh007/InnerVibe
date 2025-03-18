import SwiftUI
import CoreML

struct CameraView : View{
    @EnvironmentObject var appModel : AppModel
    
    var showNodes : Bool = true
    
    private var showWarning : Bool {
        appModel.viewfinderImage != nil && appModel.currentMLModel != nil && appModel.isBodyInFrame
    }
    
    private var previewImageSize : CGSize{
        appModel.camera.previewImageSize
    }
    
    private var bodyJointPoints : [CGPoint]{
        appModel.nodePoints
    }
    
    var body : some View{
        ViewFinderView(image : $appModel.viewfinderImage)
            .overlay(alignment : .center){
                if showNodes{
                    BodyPoseNodeOverlay(size : previewImageSize,points : bodyJointPoints)
                }
            }
            .task{
                await appModel.camera.start()
            }
            .onReceive(appModel.predictionTime){ _ in
                guard appModel.currentMLModel != nil else {return}
                appModel.canPredict = true
            }
//            .onChange(of: appModel.viewfinderImage, { oldValue, newValue in
//                if let image = appModel.viewfinderImage{
//                    processImageForPose(image)
//                }
//            })
            .onDisappear{
                appModel.canPredict = false
            }
    }
    
//    private func processImageForPose(_ image : Image) {
//        
//        Task{
//            if let multiArray = detectPoseFromImage(image){
//                await appModel.addPoseToWindow(multiArray)
//            }
//        }
//        
//    }
//    
//    private func detectPoseFromImage(_ image : Image) -> MLMultiArray?{
//        return try? MLMultiArray(shape : [1,3,18],dataType : .float)
//    }
}
