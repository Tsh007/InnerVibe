import SwiftUI
import CreateML
import CoreML

class SoundClassifierMLModel : NSObject,Identifiable{
    let name : String
    let mlModel : MLModel
    let url : URL
    
    init(name : String,mlModel : MLModel,url : URL){
        self.name = name
        self.mlModel = mlModel
        self.url = url
    }
}

extension SoundClassifierMLModel {
    static func loadMLModel(from url : URL,as name : String) async throws -> SoundClassifierMLModel?{
        let compiledModeURL = try await MLModel.compileModel(at: url)
        let model = try MLModel(contentsOf: compiledModeURL)
        return SoundClassifierMLModel(name: name, mlModel: model, url: url)
    }
    
    static func getDefaultMLModel() async -> SoundClassifierMLModel?{
        guard let rpsModel = URL.soundDefaultMLModel else {return nil}
        do{
            return try await SoundClassifierMLModel.loadMLModel(from: rpsModel, as: SoundClassifierAppModel.defaultMLModelName)
        }catch{
            print("could not load default ML Model \(error.localizedDescription)")
            return nil
        }
    }
}
