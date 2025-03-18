import SwiftUI

struct DetailAsanaView: View {
    
    @State var current : String = "benefit"
    @State var selectedTab : String
    @Namespace var animation: Namespace.ID
    @Binding var currentAsana : String
    @State var startPractice = false
    
    @EnvironmentObject var appModel : AppModel
    
    var body: some View {
        
        ScrollView{
            
            HStack(spacing: 0){
                TabBarButton(current: $current, selectedTab: "step",animation: _animation,title: "Steps")
                TabBarButton(current: $current, selectedTab: "benefit",animation: _animation,title: "Benefits")
                TabBarButton(current: $current, selectedTab: "precautions",animation: _animation,title: "Precautions")
            }
            
            
            if current == "step"{
                Image(detailsAsana[currentAsana]!.image)
                    .resizable()
                    .frame(width : 250 ,height: 250)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.gray,lineWidth: 4))
                    .shadow(radius : 10)
                
                Text(currentAsana)
                    .font(.largeTitle)
                    .fontWeight(.black)
                    .padding(.bottom,10)
                
                VStack(alignment: .leading,spacing : 5){
                    
                    Text(detailsAsana[currentAsana]!.description)
                        .fontWeight(.semibold)
                        
                    Text("Steps to do " + currentAsana)
                        .padding(.top,40)
                        .padding(.bottom,10)
                        .font(.title)
                        .fontWeight(.heavy)
                    
                    ForEach(detailsAsana[currentAsana]!.steps , id : \.self){ i in
                        Text(i)
                            .padding(.bottom,10)
                            .fontWeight(.semibold)
                    }
                }
                .frame(maxWidth : .infinity,alignment : .leading)
                .padding(.bottom,20)
                .padding([.leading,.trailing],10)
                
                
                VideoPlayerView(detailsAsana[currentAsana]!.videoName)
                    .frame(width: 400,height:400)
                    .clipShape(RoundedRectangle(cornerRadius:10))
                
                
                VariousButtons(isSystem: true, text: "Start Practice") { 
                    startPractice.toggle()
                }
                .padding(.top)
                .padding([.leading,.trailing],30)
                
            }else if current == "benefit"{
                
                
                VStack(alignment : .leading){
                    Text("Benefits of " + currentAsana)
                        .font(.title)
                        .fontWeight(.black)
                        .padding(.bottom,10)
                    
                    ForEach(detailsAsana[currentAsana]!.benefits , id : \.self){ i in
                        Text(" • " + i)
                            .padding(.bottom,10)
                            .fontWeight(.semibold)
                    }
                }
                .padding([.leading,.trailing],10)
                .frame(maxWidth : .infinity,alignment : .leading)
                
                
                
            }else if current == "precautions"{
                VStack(alignment : .leading){
                    Text("Precautions of " + currentAsana)
                        .font(.title)
                        .fontWeight(.black)
                        .padding(.bottom,10)
                    
                    ForEach(detailsAsana[currentAsana]!.precautions , id : \.self){ i in
                        Text(" • " + i)
                            .padding(.bottom,10)
                            .fontWeight(.semibold)
                    }
                }
                .padding([.leading,.trailing],10)
                .frame(maxWidth : .infinity,alignment : .leading)
            }
            
            Spacer()
            
        }
        .frame(maxWidth : .infinity,maxHeight : .infinity)
        .navigationTitle(currentAsana)
        .navigationDestination(isPresented: $startPractice) { 
            problemView(currentAsana: $currentAsana)
                .environmentObject(appModel)
        }
        
    }
}


struct RoundedCorner: Shape {
    
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}


import SwiftUI

struct TabBarButton: View {
    @Binding var current: String
    var selectedTab: String
    @Namespace var animation: Namespace.ID
    var title: String
    
    var body: some View {
        Button(action:{
            withAnimation{current=selectedTab}
            
        }){
            VStack(spacing: 5){
                
                Text(title)
                    .font(.title3)
                    .foregroundStyle(current == selectedTab ? Color.white: Color.gray.opacity(0.9))
                    .frame(height:30)
                    .padding()
                
                
                ZStack{
                    Rectangle()
                        .fill(Color.clear)
                        .frame(height: 4)
                    
                    if current == selectedTab{
                        Rectangle()
                            .fill(Color.gray)
                            .frame(height:4)
                            .matchedGeometryEffect(id: "Tab", in: animation)
                    }
                }
            }
        }
    }
}
