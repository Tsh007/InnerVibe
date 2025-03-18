import SwiftUI

struct IntroScreen:View{
    
    @State var currentIndex = 0
    
    @State var showVar : Bool = false
    
    @EnvironmentObject var appModel : AppModel
    @EnvironmentObject var soundClassifierAppModel : SoundClassifierAppModel
    
    var body : some View{
        NavigationStack{
            ZStack{
                HomeCopy(currentIndex : $currentIndex,skip: $showVar)
                    .ignoresSafeArea()
                
                HStack(spacing : 10){
                    ForEach(tabs.indices,id:\.self){ index in
                        Circle()
                            .fill(.white)
                            .frame(width: 8,height: 8)
                            .opacity(currentIndex == index ? 1:0.3)
                            .scaleEffect(currentIndex == index ? 1.1 : 0.8)
                    }    
                }
                .frame(maxWidth: .infinity,maxHeight : .infinity,alignment: .bottomLeading)
                .padding(25)
                
                Button("Skip"){
                    showVar.toggle()
                }
                .font(.system(size:18,weight:.bold))
                .foregroundStyle(Color.white)
                .frame(maxWidth: .infinity,maxHeight : .infinity,alignment: .topTrailing)
                .padding()
                
            }
            .navigationDestination(isPresented: $showVar) { 
                MainMenu()
                .navigationBarBackButtonHidden(true)
            }
            
        }
        .environmentObject(appModel)
        .environmentObject(soundClassifierAppModel)
        
    }
}
