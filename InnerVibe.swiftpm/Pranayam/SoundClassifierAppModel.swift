import SwiftUI
import SoundAnalysis
import Combine
import AVFoundation
import Observation

class SoundClassifierAppModel : ObservableObject{

    private var sessionQueue : DispatchQueue!
    
    static let defaultMLModelName = "SoundClassifier.mlmodel"
    
    ///////////////////////////////////////////////////////////////////////////
    @Published var defaultMLModel : SoundClassifierMLModel?
    
    private let buffferSize = 8192
    
    private var audioEngine : AVAudioEngine?
    private var inputBus : AVAudioNodeBus?
    private var inputFormat : AVAudioFormat?
    
    private var streamAnalyzer : SNAudioStreamAnalyzer?
    
    private var analysisQueue = DispatchQueue(label : "co.soundAnalyse.AnalysisQueue")
    
    private var retainedObserver : SNResultsObserving?
    private var subject : PassthroughSubject<SNClassificationResult,Error>?
    
    static let shared = SoundClassifierAppModel()
    
    private func setupAudioEngine(){
        print("setting up audio engine")
        
        audioEngine = AVAudioEngine()
        let inputBus = AVAudioNodeBus(0)
        self.inputBus = inputBus
        inputFormat = audioEngine?.inputNode.inputFormat(forBus: inputBus)
    }
    
    private func startAnalysis(_ requestAndObserver : (request : SNRequest, observer : SNResultsObserving)) throws {
        
        setupAudioEngine()
        
        print("reached analysis")
        guard let audioEngine = audioEngine,let inputBus = inputBus,let inputFormat = inputFormat else {return}
        print(inputFormat)
        print(1)
        let streamAnalyzer = SNAudioStreamAnalyzer(format : inputFormat)
        print(2)
        
        self.streamAnalyzer = streamAnalyzer
        
        try streamAnalyzer.add(requestAndObserver.request, withObserver: requestAndObserver.observer)
        
        retainedObserver = requestAndObserver.observer
        
        self.audioEngine?.inputNode.installTap(onBus: inputBus, bufferSize: UInt32(buffferSize), format: inputFormat, block: { buffer, time in
            self.analysisQueue.async {
                self.streamAnalyzer?.analyze(buffer, atAudioFramePosition: time.sampleTime)
            }
        })
        
        do {
            
            try audioEngine.start()
        }catch{
            print("Unable to start AVAudioEngine : \(error.localizedDescription)")
        }
    }
    
    
    func startSoundClassification(subject : PassthroughSubject<SNClassificationResult,Error>,inferenceWindowSize : Double? = nil,overlapFactor : Double? = nil){
        
        do{
            try AVAudioSession.sharedInstance().setCategory(.record, mode: .default, options: [])
            try AVAudioSession.sharedInstance().setActive(true, options: .notifyOthersOnDeactivation)
            
            let observer = ResultsObserver(subject: subject)
            
            guard let mlModel = defaultMLModel else {
                print("no default ml model found ")
                return
            }
            
            print("model detected")
            
            let request = try SNClassifySoundRequest(mlModel: mlModel.mlModel)
            
            if let inferenceWindowSize = inferenceWindowSize{
                request.windowDuration = CMTimeMakeWithSeconds(inferenceWindowSize, preferredTimescale: 48_000)
            }
            
            if let overlapFactor = overlapFactor{
                request.overlapFactor = overlapFactor
            }
            
            self.subject = subject
            
            if audioEngine?.isRunning == false{
                print("restarting audio engine")
                try audioEngine?.start()
            }
            
            try startAnalysis((request,observer))
            
        }catch{
            print("Unable to prepare request with sound classifier : \(error.localizedDescription)")
            
            subject.send(completion : .failure(error))
            self.subject = nil
        }
    }
    
    func stopSoundClassification(){
        autoreleasepool { 
            if let audioEngine = audioEngine{
                audioEngine.stop()
                audioEngine.inputNode.removeTap(onBus: 0)
            }
            
            if let streamAnalyzer = streamAnalyzer{
                streamAnalyzer.removeAllRequests()
            }
            
            streamAnalyzer = nil
            retainedObserver = nil
            audioEngine = nil
        }
    }
    ///////////////////////////////////////////////////////////////////////////    
    init(){
        sessionQueue = DispatchQueue(label : "session queue")
        print("init called")
        Task{@MainActor in
            let authorized = await checkAuthorization()
            
            guard authorized else{
                print("microphone access was not authorized.")
                return 
            }
        }
        
        setDefaultMLModel()
    }
    
    private func setDefaultMLModel(){
        Task{
            guard let mlModel = await SoundClassifierMLModel.getDefaultMLModel() else{return}
            Task{@MainActor in
                self.defaultMLModel = mlModel    
                print("model found")
            }
        }
    }
    
    private func checkAuthorization() async -> Bool {
        switch AVCaptureDevice.authorizationStatus(for: .audio){
        case .authorized:
            print("microphone access authorized.")
            return true
        case .notDetermined:
            print("microphone access not determined")
            sessionQueue.suspend() 
            let status = await AVCaptureDevice.requestAccess(for: .audio)
            sessionQueue.resume()
            return status
        case .denied:
            print("microphone access denied.")
            return false
        case .restricted:
            print("microphone library access restricted.")
            return false
        @unknown default:
            return false
        }
        
    }
}
