import SwiftUI
import Combine
import Observation
import SoundAnalysis
import AVFoundation

struct PranayamClassifier: View {

    
    @EnvironmentObject var soundClassifierAppModel : SoundClassifierAppModel
    
    @State var lastTime : Double = 0
    
    @State var detectionStarted = false
    
    @State var identifiedSound : (identifier : String, confidence : String)?
    
    @State var detectionCancellable : AnyCancellable? = nil
    
    @State var currentInhaleTime = 0.0
    @Binding var inhaleTime : Double
    
    @State var currentExhaleTime = 0.0
    @Binding var exhaleTime : Double
    
    @State var currentHoldTime = 0.0
    @Binding var holdTime : Double?
    
    @State var currentSustainTime = 0.0
    @Binding var sustainTime : Double?
    
    @State private var phase: BreathPhase = .inhale
    @State private var timer : Timer?
    
    @State var reps : Int = 0    
    
    enum BreathPhase {
        case inhale, hold, exhale, sustain, done
    }

    var body: some View {
        
        VStack{
            Text("Reps : \(reps)")
                .font(.system(size: 26))
        }
        .multilineTextAlignment(.center)
        .padding()
        .foregroundStyle(.secondary)
        .background(content : {
            RoundedRectangle(cornerRadius : 14)
                .fill(.ultraThinMaterial)
        })
        
        VStack{
            if identifiedSound != nil{
                switch phase {
                case .inhale:
                    Text("Inhale " + "\(Int(inhaleTime - currentInhaleTime))s")
                        .font(.system(size : 26))
                case .hold:
                    if let hTime = holdTime{
                        Text("Hold " + "\(Int(hTime - currentHoldTime))s")
                            .font(.system(size : 26))
                    }
                case .exhale:
                    Text("Exhale " + "\(Int(exhaleTime - currentExhaleTime))s")
                        .font(.system(size : 26))
                case .sustain:
                    if let sTime = sustainTime{
                        Text("Sustain " + "\(Int(sTime - currentSustainTime))s")
                            .font(.system(size : 26))
                    }
                case .done:
                    EmptyView()
                }
            }
        }
        .multilineTextAlignment(.center)
        .padding()
        .foregroundStyle(.secondary)
        .background(content : {
            RoundedRectangle(cornerRadius : 14)
                .fill(.ultraThinMaterial)
        })
        
        VStack{
            Spacer()
            
            if !detectionStarted{
                
                HStack{
                    Spacer()
                    
                    
                    VStack(spacing:7){
                        Image(systemName: "nose")
                            .resizable()
                            .frame(width: 30,height: 30)
                        HStack{
                            Image(systemName: "arrow.up")
                                .resizable()
                                .frame(width: 10,height: 10)
                            Image(systemName: "arrow.up")
                                .resizable()
                                .frame(width: 10,height: 10)
                        }
                        
                        Text("Inhale")
                        Text("\(Int(inhaleTime))s")
                    }
                    
                    Spacer()
                    
                    if let hTime = holdTime{
                        VStack(spacing:7){
                            Image(systemName: "nose")
                                .resizable()
                                .frame(width: 30,height: 30)
                                .padding(.bottom,18)
                            
                            Text("Hold")
                            Text("\(Int(hTime))s")
                        }
                        Spacer()
                    }
                    
                    
                    VStack(spacing:7){
                        Image(systemName: "nose")
                            .resizable()
                            .frame(width: 30,height: 30)
                        HStack{
                            Image(systemName: "arrow.down")
                                .resizable()
                                .frame(width: 10,height: 10)
                            Image(systemName: "arrow.down")
                                .resizable()
                                .frame(width: 10,height: 10)
                        }
                        
                        Text("Exhale")
                        Text("\(Int(exhaleTime))s")
                    }
                    .padding([.bottom,.top],10)
                    Spacer()
                    
                    if let sTime = sustainTime{
                        VStack(spacing:7){
                            Image(systemName: "nose")
                                .resizable()
                                .frame(width: 30,height: 30)
                                .padding(.bottom,18)
                            
                            Text("Hold")
                            Text("\(Int(sTime))s")
                        }
                        
                        Spacer()
                    }
                }
                .overlay{
                    RoundedRectangle(cornerRadius: 10)
                        .opacity(0.1)
                }
                .padding([.leading,.trailing],20)
                
                ContentUnavailableView("No sound Detected", systemImage: "waveform.badge.magnifyingglass",description: Text("Tap the play button to start detecting"))
            }else if let predictedSound = identifiedSound{
                VStack(spacing : 10){
                    Text("Prediction : " + predictedSound.0)
                        .font(.system(size : 26))
                    Text("\(predictedSound.1) confidence")
                        .font(.system(size : 16))
                }
                .multilineTextAlignment(.center)
                .padding()
                .foregroundStyle(.secondary)
                .background(content : {
                    RoundedRectangle(cornerRadius : 14)
                        .fill(.ultraThinMaterial)
                })
                .padding(.bottom,30)
            }else {
                ProgressView("Classifying sound.....")
            }
            
            Spacer()
            
            HStack(spacing : 0){
                Spacer()
                
                if phase == .inhale{
                    SliderView(currentTime: $currentInhaleTime, width: 250,maxTime: inhaleTime)
                        .rotationEffect(.degrees(-30.0), anchor: .topLeading)
                }
//                    .onAppear{ startInhaleTimer() }
                
                if holdTime != nil && phase == .hold{
                    SliderView(currentTime: $currentHoldTime,width: 250,maxTime: holdTime!)
                        .offset(x:-25,y : -130)
                }
                
                if phase == .exhale{
                    SliderView(currentTime: $currentExhaleTime,width: 250,maxTime: exhaleTime)
                        .rotationEffect(.degrees(30.0),anchor: .topLeading)
                        .offset(x:-25,y : -130)
                }
                
                if sustainTime != nil && phase == .sustain{
                    SliderView(currentTime: $currentSustainTime,width : 250,maxTime : sustainTime!)
                        .offset(x:-70,y: -9)
                }
                Spacer()
            }
            
            
            Spacer()
            
            Button(action : {
                withAnimation {
                    detectionStarted.toggle()
                    
                }
                
                if detectionStarted == true{
                    print("starting")
                    startDetection()
                    startInhaleTimer()
                }else{
                    stopDetection()
                    timer?.invalidate()
                    currentInhaleTime = 0.0
                    currentExhaleTime = 0.0
                    currentHoldTime = 0.0
                    currentSustainTime = 0.0
                    reps = 0
                }
//                detectionStarted ? startDetection() : stopDetection()
            },label : {
                Image(systemName: detectionStarted ? "stop.fill" : "play.fill")
                    .font(.system(size: 50))
                    .padding(30)
                    .background(detectionStarted ? .gray.opacity(0.7) : .blue)
                    .foregroundStyle(.white)
                    .clipShape(Circle())
                    .shadow(color: .gray, radius: 5)
                    .contentTransition(.symbolEffect(.replace))
            })        
        }
        .padding()
        .environmentObject(soundClassifierAppModel)
        .onDisappear{
            stopDetection()
            timer?.invalidate()
            currentInhaleTime = 0.0
            currentExhaleTime = 0.0
            currentHoldTime = 0.0
            currentSustainTime = 0.0
            reps = 0
        }
    }
        
    
    
    private func formattedDetectionResult(_ result : SNClassificationResult) -> (identifier : String,confidence : String)? {
        
        guard let classification = result.classifications.first else {return nil}
        
        if lastTime == 0{
            lastTime = result.timeRange.start.seconds
        }
        
        let formattedTime = String(format: "%.2f", result.timeRange.start.seconds - lastTime)
        
        print("Analysis result for audio at time : \(formattedTime)")
        
        let displayName = classification.identifier.replacingOccurrences(of: "_", with: " ").capitalized
        let confidence = classification.confidence
        let confidencePercentString = String(format: "%.2f%%",confidence*100.0)
        
        print("\(displayName) : \(confidencePercentString) confidence. \n")
        
        return (displayName,confidencePercentString)
    }
    
    func startDetection() {
        
        let classificationSubject = PassthroughSubject<SNClassificationResult,Error>()
        
//        print("reached here")
        detectionCancellable = classificationSubject
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in detectionStarted = false}, receiveValue: { result in
                print(result)
                identifiedSound = formattedDetectionResult(result)
//                print(identifiedSound)
            })
        
        print(detectionStarted)
        soundClassifierAppModel.startSoundClassification(subject: classificationSubject)
    }
    
    func stopDetection(){
        lastTime = 0
        identifiedSound = nil
        soundClassifierAppModel.stopSoundClassification()
    }
    
    func startInhaleTimer() {
        phase = .inhale
        currentInhaleTime = 0.0
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
            if currentInhaleTime < inhaleTime {
                currentInhaleTime += 0.1
            } else {
                timer.invalidate()
                
                if holdTime != nil{
                    startHoldTimer()
                }else{
                    startExhaleTimer()
                }
                
            }
        }
    }
    
    
    func startHoldTimer() {
        phase = .hold
        currentHoldTime = 0.0
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
            if currentHoldTime < holdTime ?? 0.0 {
                currentHoldTime += 0.1
            } else {
                timer.invalidate()
                startExhaleTimer()
            }
        }
    }
    
    func startExhaleTimer() {
        phase = .exhale
        currentExhaleTime = 0.0
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
            if currentExhaleTime < exhaleTime {
                currentExhaleTime += 0.1
            } else {
                timer.invalidate()
//                phase = .done
//                stopDetection()
//                detectionStarted.toggle()
                
                if sustainTime == nil{
                    currentInhaleTime = 0.0
                    currentHoldTime = 0.0
                    currentExhaleTime = 0.0
                    currentSustainTime = 0.0
                    reps+=1
                    phase = .inhale
                    startInhaleTimer()
                }else{
                    startSustainTime()
                }
            }
        }
    }
    
    func startSustainTime(){
        phase = .sustain
        currentSustainTime = 0.0
        timer?.invalidate()
        
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
            if currentSustainTime < sustainTime ?? 0.0 {
                currentSustainTime += 0.1
            } else {
                timer.invalidate()
                //                phase = .done
                //                stopDetection()
                //                detectionStarted.toggle()
                currentInhaleTime = 0.0
                currentHoldTime = 0.0
                currentExhaleTime = 0.0
                currentSustainTime = 0.0
                reps+=1
                phase = .inhale
                startInhaleTimer()
            }
        }
    }
    

}


//#Preview(body: { 
//    PranayamClassifier(inhaleTime: .constant(3.0), exhaleTime: .constant(3.0), holdTime: .constant(3.0), sustainTime: .constant(3.0))
//        .environmentObject(SoundClassifierAppModel())
//})
