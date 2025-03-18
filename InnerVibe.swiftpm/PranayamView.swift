import SwiftUI
import Combine

struct PranayamView : View {
    
    @EnvironmentObject var soundClassifierAppModel : SoundClassifierAppModel
    
    @State var currentIndex = 2
    
    @State var showPranayam = false
    
    @State var currentPranayam = "Agnisar"
    
    @State var inhaleTime = 3.0
    
    @State var exhaleTime = 5.0
    
    @State var holdTime : Double? = nil
    
    @State var sustainTime : Double? = nil
    
    @State var streak : Int = 0
    
    var body : some View{
        ZStack{
            GeometryReader{proxy in
                let size = proxy .size
                
                Color.black

                ForEach(1...3,id:\.self){index in
                    Image("img\(index)")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width : size.width,height : size.height)
                        .opacity(currentIndex == (index-1) ? 1 : 0)
                    
                }
                
                LinearGradient(colors : [
                    .clear,.black.opacity(0.5),.black
                ],startPoint: .top,endPoint: .bottom)
            }
            .ignoresSafeArea()
            
            VStack(spacing:20){
                
                HStack{
                    Spacer()
                    HStack{
                        Text("\(streak)")
                        Image(systemName: "flame")
                        .foregroundStyle(Color.orange)
                            
                    }
                    .multilineTextAlignment(.center)
                    .padding()
                    .foregroundStyle(Color.white)
                    
                    .background(
                        .white.opacity(0.1)
                        ,in: RoundedRectangle(cornerRadius: 10)
                    )
                }
                
                Spacer()
                
                VariousButtons(isSystem: true, text: "Agnisar Pranayama (Fire Breath)") { 
                    showPranayam.toggle()
                    currentPranayam = "Agnisar"
                    
                    inhaleTime = 3.0
                    exhaleTime = 5.0
                    holdTime = 12.0
                    sustainTime = nil
                }
                .padding(.top)
                
                VariousButtons(isSystem: true, text: "Bhastrika Pranayam (Bellows Breath)") { 
                    showPranayam.toggle()
                    currentPranayam = "Bhastrika"
                    
                    inhaleTime = 2.0
                    exhaleTime = 2.0
                    holdTime = nil
                    sustainTime = nil
                }
                .padding(.top)
                
                VariousButtons(isSystem: true, text: "Bhramari Pranayama (Bee Breath)") { 
                    showPranayam.toggle()
                    currentPranayam = "Bhramari"
                    
                    inhaleTime = 5.0
                    exhaleTime = 10.0
                    holdTime = nil
                    sustainTime = nil
                }
                .padding(.top)
                
                VariousButtons(isSystem: true, text: "Ujjayi Pranayama (Victorious Breath)") { 
                    showPranayam.toggle()
                    currentPranayam = "Ujjayi"
                    
                    inhaleTime = 5.0
                    exhaleTime = 8.0
                    holdTime = nil
                    sustainTime = nil
                }
                .padding(.top)
                
//                VariousButtons(isSystem: true, text: "Kapalbhati Pranayama (Skull Shining Breath)") { 
//                    showPranayam.toggle()
//                    currentPranayam = "Kapalbhati"
//                    
//                    inhaleTime = 1.0
//                    exhaleTime = 1.0
//                    holdTime = nil
//                    sustainTime = nil
//                }
//                .padding(.top)
                
                VariousButtons(isSystem: true, text: "Sahita Kumbhaka Pranayama (Constricted Breath Retention)") { 
                    showPranayam.toggle()
                    currentPranayam = "Sahita"
                    
                    inhaleTime = 4.0
                    exhaleTime = 15.0
                    holdTime = 6.0
                    sustainTime = 5.0
                }
                .padding(.top)
            }
            .foregroundStyle(Color.white)
            .padding()
            .frame(maxWidth: .infinity,maxHeight:.infinity,alignment: .bottom)
        }
        .onAppear{
            streak = UserDefaults.standard.integer(forKey: "Streak")
            
            UserDefaults.standard.set(streak,forKey: "Streak")
            guard let lastDate = UserDefaults.standard.object(forKey: "Date") as? Date else{
                //                print("no streak found and saved")
                UserDefaults.standard.set(Date(),forKey: "Date")
                return} 
            
            let calendar = Calendar.current
            
            if calendar.isDate(.now, inSameDayAs : lastDate){
                //streak remain same
            }else if let dayAfterLast = calendar.date(byAdding : .day,value : 1,to: lastDate) {
                if calendar.isDate(.now,inSameDayAs : dayAfterLast){
                    streak+=1
                    UserDefaults.standard.set(streak,forKey: "Streak")
                    //                    print("streak increased")
                }else{
                    streak = 0
                    UserDefaults.standard.set(streak,forKey: "Streak")
                    //                    print("streak broken")
                }
            }
            
            //            print("current date saved")
            UserDefaults.standard.set(Date(),forKey: "Date")
            
        }
        .environmentObject(soundClassifierAppModel)
        .navigationDestination(isPresented: $showPranayam) { 
//            PranayamClassifier(inhaleTime : $inhaleTime,exhaleTime : $exhaleTime,holdTime : $holdTime,sustainTime: $sustainTime)
//                .environmentObject(soundClassifierAppModel)
            
            DetailPranayamView(currentPranayam: $currentPranayam,inhaleTime: $inhaleTime,exhaleTime: $exhaleTime,holdTime: $holdTime,sustainTime: $sustainTime)

        }
    }
    
    
        
}
