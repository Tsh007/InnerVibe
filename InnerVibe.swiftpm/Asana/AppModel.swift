import SwiftUI

import Vision
import CoreML

final class AppModel : ObservableObject{
    
    @Published var poseWindow : [MLMultiArray?] = [] 
//    {
//        didSet{
//            if poseWindow.count > predictionWindowSize{
//                poseWindow = Array(poseWindow.suffix(predictionWindowSize))
//            }
//        }
//    }
    
    let predictionWindowSize = 150
    
    let windowStride = 10
    
    @MainActor
    func addPoseToWindow(_ pose : MLMultiArray?) async{
        if let pose = pose{
            poseWindow.append(pose)
        }
        
        if poseWindow.count > predictionWindowSize{
//            poseWindow.removeFirst(windowStride)
            poseWindow = Array(poseWindow.suffix(150))
        }
        
        if poseWindow.count == predictionWindowSize{
            await makePredictionWithWindow()
        }
    }
    
    @MainActor
    private func makePredictionWithWindow() async{
        
        guard let mlModel = camera.currentMLModel else {
            await resetPrediction()
            return
        }
        
        let filledWindow = poseWindow.compactMap { $0 }
        
        let mergedWindow = MLMultiArray(concatenating: filledWindow, axis: 0, dataType: .float)
        

        Task{     
            do {
                let input = BodyPoseInput(poses: mergedWindow)
                guard let output = try mlModel.predict(poses: input) else { return }
                await updatePredictions(output: output)
            }catch{
                print("Error performing request: \(error)")
            }
        }
        
//        poseWindow.removeFirst(windowStride)
        
        //        let mergedWindow = mergedWindow {
        //            let actionPrediction = actionClassifier.predictActionFromWindow(mergedWindow)
        //            
        //            //handle output
        //            handlePrediction(actionPrediction)
        //        }
    }
    //----------------------------------------------------------------------------------------------------------------------------------------
    
    static let defaultMLModelName = "myMLModel.mlmodel"
    
    let camera = MLCamera()
    
    let predictionTime = Timer.publish(every : 0.02,on:.main,in:.common).autoconnect()
    
    @Published var currentMLModel : BodyPoseMLModel? {
        didSet {
            guard let model = currentMLModel else {return}
            camera.mlDelegate?.updateMLModel(with: model)
        }
    }
    
    @Published var defaultMLModel : BodyPoseMLModel?
    
    @Published var availableBodyPoseMLModels = Set<BodyPoseMLModel>()
    
    @Published var nodePoints : [CGPoint] = []
    
    @Published var isBodyInFrame : Bool = false
    
    @Published var predictionProbability = PredictionMetrics()
    
    @Published var canPredict : Bool = false
    
    @Published var predictionLabel : String = ""
    
    @Published var isGatheringObservations : Bool = true
    
    @Published var viewfinderImage : Image?
    
    @Published var shouldPauseCamera : Bool = false{
        didSet{
            if shouldPauseCamera{
                camera.stop()
                isGatheringObservations = false
            }else{
                Task{
                    await camera.start()
                }
            }
        }
    }
    
    private var bodyPoseMLModelURLs : [URL] {
        let urls = availableBodyPoseMLModels.map {$0.url}
        return urls
    }
    
    init(){
        camera.mlDelegate = self
        setDefaultMLModel()
        Task{
            await handleCameraPreviews()
        }
    }
    
    private func handleCameraPreviews() async{
        let imageStream = camera.previewStream.map{$0.image}
        for await image in imageStream{
            Task{@MainActor in
                self.viewfinderImage = image    
            }
        }
    }
    
    private func setDefaultMLModel(){
        Task{
            guard let mlModel = await BodyPoseMLModel.getDefaultMLModel() else {return}
            Task{ @MainActor in
                self.defaultMLModel = mlModel
                self.currentMLModel = mlModel
                self.availableBodyPoseMLModels.insert(mlModel)
            }
        }
    }
}


extension AppModel : MLDelegate {
    
    func updateMLModel(with model : NSObject){
        guard let mlModel = model as? BodyPoseMLModel else {return}
        camera.currentMLModel = mlModel
    }
    
    
    func gatherObservations(pixelBuffer: CVImageBuffer) async {
        guard canPredict else { return }
        
        Task { @MainActor in
            canPredict = false
        }
        
//        guard let mlModel = camera.currentMLModel else {
//            await resetPrediction()
//            return
//        }
        
        Task {
            let imageRequestHandler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, orientation: .up)
            do {
                try imageRequestHandler.perform([camera.bodyPoseRequest])
                guard let observation = camera.bodyPoseRequest.results?.first else {
                    await resetPrediction()
                    return
                }
                
                Task { @MainActor in
                    isBodyInFrame = true
                    isGatheringObservations = true
                }
                
                
                let poseMultiArray = try observation.keypointsMultiArray()
                
                await addPoseToWindow(poseMultiArray)
                
//                let input = BodyPoseInput(poses: poseMultiArray)
//                
//                guard let output = try mlModel.predict(poses: input) else {return}
//                await updatePredictions(output: output)
                
                let jointPoints = try gatherBodyPosePoints(from: observation)
                await updateNodes(points: jointPoints)
            } catch {
                print("Error performing request: \(error)")
            }
        }
        
    }
    
    private func gatherBodyPosePoints(from observation: VNHumanBodyPoseObservation) throws -> [CGPoint] {
        let allPointsDict = try observation.recognizedPoints(.all)
        var allPoints: [VNRecognizedPoint] = Array(allPointsDict.values)
        allPoints = allPoints.filter { $0.confidence > 0.5 }
        let points: [CGPoint] = allPoints.map { $0.location }
        return points
    }
    
    @MainActor
    private func updateNodes(points: [CGPoint]) {
        self.nodePoints = points
    }
    
    @MainActor
    private func updatePredictions(output: BodyPoseOutput) {
        predictionLabel = output.label.capitalized
        predictionProbability.getNewPredictions(from: output.labelProbabilities)
    }
    
    @MainActor
    private func resetPrediction() {
//        poseWindow.removeAll()
        nodePoints = []
        predictionLabel = ""
        predictionProbability = PredictionMetrics()
        isBodyInFrame = false
    }
}

fileprivate extension CIImage {
    var image : Image? {
        let ciContext = CIContext()
        guard let cgImage = ciContext.createCGImage(self, from: self.extent) else {return nil}
        return Image(decorative: cgImage,scale : 1,orientation: .up)
    }
}

extension AppModel : @unchecked Sendable {}

extension Image : @unchecked Sendable {}
