import SwiftUI
import CoreML
import CreateML
import Combine

final class BodyPoseMLModel : NSObject,Identifiable{
    let name : String
    let mlModel : MLModel
    let url : URL
    
    private var classLabels : [Any] {
        mlModel.modelDescription.classLabels ?? []
    }
    
    init(name : String,mlModel : MLModel,url : URL){
        self.name = name
        self.mlModel = mlModel
        self.url = url
    }
    
    func predict(poses : BodyPoseInput) throws -> BodyPoseOutput? {
        let features = try mlModel.prediction(from : poses)
        let output = BodyPoseOutput(features:features)
        return output
    }
}

class BodyPoseInput {
    var poses : MLMultiArray
    
    init(poses : MLMultiArray){
        self.poses = poses
    }
}

class BodyPoseOutput {
    let provider : MLFeatureProvider
    
    lazy var labelProbabilities : [String : Double] = {[unowned self] in 
        self.getOuputProbabilities()
    }()
    
    lazy var label : String = { [unowned self] in
        self.getOutputLabel()
    }()
    
    init(features : MLFeatureProvider){
        self.provider = features
    }
}

extension BodyPoseMLModel {
    static func loadMLModel(from url : URL,as name : String) async throws -> BodyPoseMLModel? {
        let compiledModeURL = try await MLModel.compileModel(at: url)
        let model = try MLModel(contentsOf: compiledModeURL)
        return BodyPoseMLModel(name : name,mlModel : model,url : url)
    }
    
    static func getDefaultMLModel() async -> BodyPoseMLModel?{
        guard let rpsModel = URL.defaultMLModel else {return nil}
        do{
            return try await BodyPoseMLModel.loadMLModel(from : rpsModel,as : AppModel.defaultMLModelName)
        }catch{
            print("could not load default ML Model\(error.localizedDescription)")
            return nil
        }
    }
    
    static func findExistingModel(exclude existingModelURLs : [URL] = []) async -> [BodyPoseMLModel]{
        guard let modelDirectory = URL.modelDirectory,
              modelDirectory.directoryExists else {return []}
        
        var models : [BodyPoseMLModel] = []
        
        do{
            let modelURLs = modelDirectory.directoryContentsOrderedByDate
            for url in modelURLs {
                guard !existingModelURLs.contains(url) else { continue }
                
                guard let model = try await getMLModel(from:url) else {continue}
                
                models.append(model)
            }
        }catch{
            print("error finding existing models \(error.localizedDescription)")
        }
        return models
    }
    
    static func getLastTrainedMLModel() async -> BodyPoseMLModel?{
        return await BodyPoseMLModel.findExistingModel().first
    }
    
    private static func getMLModel(from url : URL) async throws -> BodyPoseMLModel? {
        let name = url.lastPathComponent
        guard let bodyPoseMLModel = try await
                BodyPoseMLModel.loadMLModel(from : url,as : name) else {
            return nil
        }
        return bodyPoseMLModel
    }

}


extension BodyPoseInput : MLFeatureProvider {
    var featureNames : Set<String>{
        get {
            return ["poses"]
        }
    }
    
    func featureValue(for featureName : String) -> MLFeatureValue? {
        if featureName == "poses" {
            return MLFeatureValue(multiArray: poses)
        }
        return nil
    }
}
extension BodyPoseOutput : MLFeatureProvider {
    var featureNames: Set<String> {
        return self.provider.featureNames
    }
    
    func featureValue(for featureName: String) -> MLFeatureValue? {
        return self.provider.featureValue(for: featureName)
    }
}

extension BodyPoseOutput{
    func getOuputProbabilities() -> [String : Double] {
        return self.provider.featureValue(for: "labelProbabilities")?.dictionaryValue as? [String : Double] ?? [:]    
    }
    
    func getOutputLabel() -> String{
        return self.provider.featureValue(for : "label")?.stringValue ?? ""
    }
}

extension BodyPoseMLModel : @unchecked Sendable {}

extension BodyPoseOutput : @unchecked Sendable {}



