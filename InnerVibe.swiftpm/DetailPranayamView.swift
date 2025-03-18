import SwiftUI

struct DetailPranayamView : View{
    
    @EnvironmentObject var soundClassifierAppModel : SoundClassifierAppModel
    
    @Binding var currentPranayam : String
    
    @State var startPractice = false
    
    @Binding var inhaleTime : Double
    
    @Binding var exhaleTime : Double
    
    @Binding var holdTime : Double? 
    
    @Binding var sustainTime : Double? 
    
    var body : some View{
        
        ScrollView{
            
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
                    Text("\(Int(detailsPranayam[currentPranayam]!.inhaleTime))s")
                }
                
                Spacer()
                
                if let holdTime = detailsPranayam[currentPranayam]!.holdTime{
                    VStack(spacing:7){
                        Image(systemName: "nose")
                            .resizable()
                            .frame(width: 30,height: 30)
                            .padding(.bottom,18)
                        
                        Text("Hold")
                        Text("\(Int(holdTime))s")
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
                    Text("\(Int(detailsPranayam[currentPranayam]!.exhaleTime))s")
                }
                .padding([.bottom,.top],10)
                Spacer()
                
                if let sustainTime = detailsPranayam[currentPranayam]!.sustainTime{
                    VStack(spacing:7){
                        Image(systemName: "nose")
                            .resizable()
                            .frame(width: 30,height: 30)
                            .padding(.bottom,18)
                        
                        Text("Hold")
                        Text("\(Int(sustainTime))s")
                    }
                    
                    Spacer()
                }
            }
            .overlay{
                RoundedRectangle(cornerRadius: 10)
                    .opacity(0.1)
            }
            .padding([.leading,.trailing],20)
            
            
            
            VStack(alignment : .leading){
                Text("Instructions")
                    .font(.title)
                    .fontWeight(.semibold)
                    .padding([.top,.bottom,.leading],10)
                
                Divider()
                    .padding([.bottom,.leading,.trailing],10)
                
                ForEach(detailsPranayam[currentPranayam]!.instructions , id : \.self){ i in
                    Text(" • " + i)
                        .padding([.bottom,.leading],10)
                        .fontWeight(.semibold)
                }
            }
            .overlay{
                RoundedRectangle(cornerRadius: 10)
                    .opacity(0.1)
            }
            .padding([.leading,.trailing],20)
            .padding([.top,.bottom],10)
            
            
            VStack(alignment : .leading){
                Text("Key Benefits")
                    .font(.title)
                    .fontWeight(.semibold)
                    .padding([.top,.bottom,.leading],10)
                
                Divider()
                    .padding([.bottom,.leading,.trailing],10)
                
                ForEach(detailsPranayam[currentPranayam]!.benefits , id : \.self){ i in
                    Text(" • " + i)
                        .padding([.bottom,.leading],10)
                        .fontWeight(.semibold)
                }
            }
            .overlay{
                RoundedRectangle(cornerRadius: 10)
                    .opacity(0.1)
            }
            .padding([.leading,.trailing],20)
            .padding([.top,.bottom],10)
            
            
            VStack(alignment : .leading){
                Text("Tips")
                    .font(.title)
                    .fontWeight(.semibold)
                    .padding([.top,.bottom,.leading],10)
                
                Divider()
                    .padding([.bottom,.leading,.trailing],10)
                
                    Text(" • " + detailsPranayam[currentPranayam]!.tips)
                        .padding([.bottom,.leading],10)
                        .fontWeight(.semibold)
                
            }
            .overlay{
                RoundedRectangle(cornerRadius: 10)
                    .opacity(0.1)
            }
            .padding([.leading,.trailing],20)
            .padding([.top,.bottom],10)
            
            
            VStack(alignment : .leading){
                Text("Precautions")
                    .font(.title)
                    .fontWeight(.semibold)
                    .padding([.top,.bottom,.leading],10)
                
                Divider()
                    .padding([.bottom,.leading,.trailing],10)
                
                ForEach(detailsPranayam[currentPranayam]!.precautions , id : \.self){ i in
                    Text(" • " + i)
                        .padding([.bottom,.leading],10)
                        .fontWeight(.semibold)
                }
                
            }
            .overlay{
                RoundedRectangle(cornerRadius: 10)
                    .opacity(0.1)
            }
            .padding([.leading,.trailing],20)
            .padding([.top,.bottom],10)
            
            
            VariousButtons(isSystem: true, text: "Start Practice") { 
                startPractice.toggle()
            }
            .padding([.leading,.trailing],20)
        }
        .padding([.top,.bottom],20 )
        .navigationDestination(isPresented: $startPractice) { 
            PranayamClassifier(inhaleTime : $inhaleTime,exhaleTime : $exhaleTime,holdTime : $holdTime,sustainTime : $sustainTime)
                .environmentObject(soundClassifierAppModel)
        }
        
    }
}

