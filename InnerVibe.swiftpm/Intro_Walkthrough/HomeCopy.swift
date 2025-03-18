import SwiftUI

struct HomeCopy : View{
    
    @State var dotState : DotStateCopy = .normal
    
    @State var dotScale : CGFloat = 1
    
    @State var dotRotation : Double = 0
    
    @State var isAnimating = false
    
    @Binding var currentIndex : Int
    
    @State var nextIndex : Int = 1
    
    @Binding var skip : Bool
    
    var body : some View {
        ZStack{
            //            Color(.orange)
            
            ZStack{
                (dotState == .normal ? tabs[currentIndex].color : tabs[nextIndex].color) 
                if(dotState == .normal){
                    MinimisedView()
                }else{
                    ExpandedView()
                }
                
            }
            .animation(.none,value: dotState)
            
            Rectangle()
                .fill(dotState != .normal ? tabs[currentIndex].color : tabs[nextIndex].color)
                .overlay(
                    
                    ZStack{
                        if(dotState != .normal){
                            MinimisedView()
                        }else{
                            ExpandedView()
                        }
                    }
                )
                .animation(.none,value:dotState)
                .mask(
                    GeometryReader{ proxy in 
                        
                        Circle()
                            .frame(width: 80 , height : 80)
                            .scaleEffect(dotScale)
                            .rotation3DEffect(.init(degrees: dotRotation),axis:(x:0,y:1,z:0),anchorZ:10,perspective:1)
                            .frame(maxWidth:.infinity,maxHeight:.infinity,alignment: .bottom)
//                            .offset(y: -60)
                            .offset(y: -(getSafeArea().bottom + 20))
                    }
                )
            
            Circle()
                .foregroundStyle(Color.black.opacity(0.01))
                .frame(width: 80 , height : 80)    
                .overlay(
                    Image(systemName: "chevron.right")
                        .font(.title)
                        .foregroundStyle(.white)
                        .opacity(dotRotation == -180 ? 0 : 1)
//                        .opacity(isAnimating ? 0 : 1)
//                        .animation(.easeInOut(duration : 0.4),value:isAnimating)
                        .animation(.easeOut,value:dotRotation)
                )
                .frame(maxWidth:.infinity, maxHeight:.infinity, alignment: .bottom)
                .onTapGesture(perform : {
                    
                    if getNextIndex() == 1{
                        skip = true
                    }
                    if isAnimating {return}
                    
                    isAnimating = true

                    withAnimation(.linear(duration : 1.5)){
                        dotRotation = -180
                        dotScale = 8
                    }
                        
                    DispatchQueue.main.asyncAfter(deadline: .now()+0.725){
                        withAnimation(.linear(duration : 0.7)){
                            dotState = .flipped
                        }
                    }   

                    DispatchQueue.main.asyncAfter(deadline : .now()+0.8){
                        withAnimation(.easeInOut(duration: 0.5)){
                            dotScale = 1
                        }
                    }                    
                    
                    DispatchQueue.main.asyncAfter(deadline : .now() + 1.4){
                        withAnimation(.easeInOut(duration: 0.3)){
                            dotRotation = 0
                            dotState = .normal
                            
                            currentIndex = nextIndex
                            nextIndex = getNextIndex()
                        }
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3){
                            isAnimating = false
                        }
                    }
                    
                })
                .offset(y: -(getSafeArea().bottom + 20))
            
        }
        .ignoresSafeArea()
    }
    
    @ViewBuilder
    func IntroView(tab : Tab) -> some View{
        VStack{
            Image(tab.image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(maxHeight: 600)
                .padding(40)
            
            VStack(alignment: .leading,spacing : 0){
                Text(tab.title)
                    .font(.system(size : 45))
                
                Text(tab.subTitle)
                    .font(.system(size:50,weight : .bold))
                
                Text(tab.description)
                    .fontWeight(.semibold)
                    .padding(.top)
//                    .frame(width: getRect().width-100,alignment: .leading)
                
            }
            .foregroundStyle(Color.white)
            .frame(maxWidth: .infinity , alignment : .leading)
            .padding(.leading,20)
            .padding([.trailing,.top])
        }
    }
    
    
    func getNextIndex() -> Int{
        let index = (nextIndex + 1) > (tabs.count - 1) ? 0 : (nextIndex + 1)
        return index
    }
    
    @ViewBuilder
    func ExpandedView() -> some View{
        IntroView(tab: tabs[nextIndex])
            .offset(y : -50)
    }
    
    @ViewBuilder
    func MinimisedView()-> some View{
        IntroView(tab: tabs[currentIndex])
            .offset(y : -50)
    }
}


enum DotStateCopy{
    case normal
    case flipped
}


extension View{
    func getRect()->CGRect{
        return UIScreen.main.bounds
    }
    
    func getSafeArea()->UIEdgeInsets{
        guard let screen = UIApplication.shared.connectedScenes.first as? UIWindowScene else{
            return .zero
        }
        
        guard let safeArea = screen.windows.first?.safeAreaInsets else{
            return .zero
        }
        
        return safeArea
    }
}
