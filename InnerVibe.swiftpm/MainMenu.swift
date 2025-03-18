import SwiftUI


struct MainMenu : View{
    
    @State var titles = [
        "Clean your mind from",
        "Unique experience",
        "The ultimate app"
    ]
    
    @State var subTitles = [
        "Negativity - Stress - Anxiety",
        "Prepare your mind for sweet dreams",
        "Healthy mind - better sleep - well being"
    ]
    
    @State var currentIndex = 2
    @State var animatedText = ""
    @State var subTitleAnimation : Bool = false
    @State var endAnimation = false
    @State var animationTimer: Timer?
    
    
    //
    @State var showAsanaView = false
    @State var showPranayamView = false
    @EnvironmentObject var appModel : AppModel
    @EnvironmentObject var soundClassifierAppModel : SoundClassifierAppModel
    
    var body: some View{
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
                        Text(animatedText)
                            .font(.largeTitle.bold())
                            .transition(.opacity)

                    }
                    .offset(y: endAnimation ? -100 : 0)
                    .opacity(endAnimation ? 0 : 1)
                    
                    Text(subTitles[currentIndex])
                        .opacity(0.7)
                        .offset(y : !subTitleAnimation ? 80 : 0)
                        .offset(y : endAnimation ? -100 : 0)
                        .opacity(endAnimation ? 0 : 1)
                    
                    VariousButtons(isSystem: true, text: "Asana") { 
                        showAsanaView.toggle()
                    }
                    .padding(.top)
                    VariousButtons(isSystem: false, text: "Pranayam") { 
                        showPranayamView.toggle()
                    }
                    
                }
                .foregroundStyle(Color.white)
                .padding()
                .frame(maxWidth: .infinity,maxHeight:.infinity,alignment: .bottom)
            }
            .onAppear(perform : {
//                currentIndex = 0
                resetAnimation()
                restartAnimation()
            })
            .onDisappear{
                stopAnimation()
            }

            .navigationDestination(isPresented: $showAsanaView) { 
                AsanaView()
            }
            .navigationDestination(isPresented: $showPranayamView){ 
                PranayamView()
            }
            .environmentObject(appModel)
            .environmentObject(soundClassifierAppModel)
        
    }

    
    func resetAnimation(){
        animatedText = ""
        subTitleAnimation = false
        endAnimation = false
        stopAnimation()
    }
    
    func stopAnimation(){
        animationTimer?.invalidate()
        animationTimer = nil
    }
    
    func restartAnimation(){
        stopAnimation()
        
        let title = titles[currentIndex]
        var index = 0
        animatedText = ""
        
        animationTimer = Timer.scheduledTimer(withTimeInterval : 0.07,repeats: true){ timer in
            
            if index<title.count{
                animatedText.append(title[title.index(title.startIndex,offsetBy: index)])
                index += 1
            }else{
                timer.invalidate()
                animationTimer = nil
                
                withAnimation(.easeInOut(duration : 0.5)){
                    subTitleAnimation.toggle()
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                    withAnimation(.easeInOut(duration: 1)) {
                        endAnimation.toggle()
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        currentIndex = (currentIndex + 1) % titles.count
                        restartAnimation() 
                    }
                }
            }
            
            
        }
        
    }
}


struct VariousButtons : View{
    
//    var image : String
    var isSystem : Bool
    var text: String
    var onClick : ()->()
    
    var body : some View{
        
        HStack{
            Text(text)
                .font(.title3)
                .fontWeight(.semibold)
                .frame(maxWidth: .infinity,alignment: .center)
            
        }
        .foregroundStyle(Color(isSystem ? .black : .white))
        .padding(.vertical,15)
        .padding(.horizontal,40)
        .background(
            .white.opacity(isSystem ? 1 : 0.1)
            ,in: RoundedRectangle(cornerRadius: 10)
        )
        .onTapGesture{
            onClick()
        }
    }
}
