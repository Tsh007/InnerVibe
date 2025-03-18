import SwiftUI

struct AsanaView : View{
    @EnvironmentObject var appModel : AppModel
    
    @State var currentIndex = 2
    
    @State var showAsana = false
    
    @State var currentAsana = "Padmasana"
    
    @State var streak : Int = 0
    
    var body: some View {
        
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
                
                VariousButtons(isSystem: true, text: "Bhujangasana") { 
                    showAsana.toggle()
                    currentAsana = "Bhujangasana"
                }
                .padding(.top)
                
                VariousButtons(isSystem: true, text: "Padmasana") { 
                    showAsana.toggle()
                    currentAsana = "Padmasana"
                }
                .padding(.top)
                
                VariousButtons(isSystem: true, text: "Vajrasana") { 
                    showAsana.toggle()
                    currentAsana = "Vajrasana"
                }
                .padding(.top)
                
                VariousButtons(isSystem: true, text: "Sarvangasana") { 
                    showAsana.toggle()
                    currentAsana = "Sarvangasana"
                }
                .padding(.top)
                
                VariousButtons(isSystem: true, text: "Vrikshasana") { 
                    showAsana.toggle()
                    currentAsana = "Vrikshasana"
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
        .environmentObject(appModel)
        .navigationDestination(isPresented: $showAsana) { 
            DetailAsanaView(current: "step", selectedTab: "step", currentAsana: $currentAsana)
                .environmentObject(appModel)
        }
        

    }
}
