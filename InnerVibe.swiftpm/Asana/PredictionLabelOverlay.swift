import SwiftUI

struct PredictionLabelOverlay : View{
    
    @ScaledMetric private var size: CGFloat = 80
    
    var label : String
    var showIcon : Bool = true
    
    @State var isTimerRunning = false
    
    @State var timerCount = 0.0
    
    @State var timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    
    @Binding var currentAsana : String
    
    @State var bestTime = 0.0
    
    var body : some View {

        if label.isEmpty{
//            var x = print(timerCount)
            EmptyView()
                .onAppear{
                     bestTime = UserDefaults.standard.double(forKey: currentAsana)   
                }
            
            
        }else if label == currentAsana{
            
            TimerView(isTimerRunning: $isTimerRunning,timeCount : $timerCount,timer : $timer)
            .onAppear{
                timer = Timer.publish(every : 0.1,on : .main,in : .common).autoconnect()
                isTimerRunning = true
            }
            .onDisappear{
                self.timer.upstream.connect().cancel()
                if timerCount > bestTime{
                    UserDefaults.standard.set(timerCount,forKey : currentAsana)
                    bestTime = UserDefaults.standard.double(forKey: currentAsana) 
                }
                timerCount = 0.0
                isTimerRunning = false
            }
            VStack{
                
//                if bestTime > 0.0{
//                    RoundedRectangle(cornerRadius: 10.0,style: .continuous)
//                        .fill(Color.red)
//                        .frame(width:size,height:size)
//                        .padding()
//                        .overlay{
//                            VStack{
//                                Text("Best Time")
//                                Text(String(format : "%.1f",self.bestTime) + "s" )
//                                
//                            }
//                            .foregroundColor(.white)
//                        }
//                }
//                RoundedRectangle(cornerRadius: 10.0,style: .continuous)
//                    .fill(Color.red)
//                    .frame(width:size,height:size)
//                    .padding()
//                    .overlay{
//                        VStack{
//                            if showIcon{
//                                iconView()
//                            }
//                            Text(label)
//                        }
//                        .foregroundColor(.white)
//                    }
                
                
                
                if bestTime > 0.0{
                    VStack(spacing : 10){
                        Text("Best Time : " + String(format : "%.1f",self.bestTime) + "s")
                            .font(.system(size : 35))    
                            .fontWeight(.semibold)
                        
                    }
                    .multilineTextAlignment(.center)
                    .padding()
                    .foregroundStyle(.primary)
                    .background(content : {
                        RoundedRectangle(cornerRadius : 14)
                            .fill(.ultraThinMaterial)
                    })
                }
                
                VStack(spacing : 10){
                    Text("Prediction : " + label)
                        .font(.system(size : 35))
                        .fontWeight(.semibold)
                }
                .multilineTextAlignment(.center)
                .padding()
                .foregroundStyle(.primary)
                .background(content : {
                    RoundedRectangle(cornerRadius : 14)
                        .fill(.ultraThinMaterial)
                })
                
            }
        }
    }
    
//    private func iconView() -> some View{
//        //        Group {
//        Image(systemName: "sun.min")
//        //        }
//    }
}
