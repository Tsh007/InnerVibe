import SwiftUI
import Combine

struct TimerView : View {
    
    @Binding var isTimerRunning : Bool
    @Binding var timeCount : Double
    @Binding var timer : Publishers.Autoconnect<Timer.TimerPublisher>
        
    var body : some View {
        VStack{
//            Text(String(format : "%.1f",self.timeCount) + "s")
//                .font(.system(size:60))
//                .bold()
//                .frame(width : 150,height : 150)
//                .background(Circle().fill(Color.white).shadow(radius:10))
//                .onReceive(self.timer){ time in
//                    if isTimerRunning{
//                        timeCount += 0.1 
//                    }
//                }
//                .foregroundStyle(Color.black)
            
            VStack(spacing : 10){
                Text(String(format : "%.1f",self.timeCount) + "s")
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
            .onReceive(self.timer){ time in
                if isTimerRunning{
                    timeCount += 0.1 
                }
            }
            
        }
    }
}
