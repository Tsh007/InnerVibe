import SwiftUI

struct ViewFinderView : View{
    @Binding var image : Image?
    
    var body : some View{
        GeometryReader{ geo in 
            if let image = image{
                image.resizable()
                    .scaledToFill()
                    .frame(width : geo.size.width,height: geo.size.height)
                    .clipped()
            }else{
                Rectangle().fill(.black)
            }
        }
    }
}
