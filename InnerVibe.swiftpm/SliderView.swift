import SwiftUI

struct SliderView : View {

    @Binding var currentTime : Double
    
    let width : CGFloat?

    var maxTime : Double
    
    var body : some View{
        
            Slider(value: $currentTime,in:1...maxTime)
            //                .padding()
                .disabled(true)
                .animation(.linear,value : currentTime)
                .frame(width : width)
                .tint(Color.green)
    }
}
