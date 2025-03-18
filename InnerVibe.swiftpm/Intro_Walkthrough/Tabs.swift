import SwiftUI

struct Tab : Identifiable{
    var id = UUID().uuidString
    var title : String
    var subTitle : String
    var description : String 
    var image : String 
    var color : Color
}

var tabs : [Tab] = [
    Tab(title : "Welcome to Inner Vibe",subTitle: "",description: "Your Personal Yoga Guide",image:"pic1",color : Color(#colorLiteral(red: 0.6990447640419006, green: 0.8877881169319153, blue: 0.7461894154548645, alpha: 1.0))),
    Tab(title : "Real-Time Asana Detection",subTitle: "",description: "Master Your Asana",image:"pic2",color : Color(#colorLiteral(red: 0.21414047479629517, green: 0.8193358182907104, blue: 0.851566731929779, alpha: 1.0))),
    Tab(title : "Pranayama Breathing Guidance",subTitle: "",description: "Perfect Your Breathing",image:"pic3",color : Color(#colorLiteral(red: 0.4445013403892517, green: 0.4795498847961426, blue: 0.7112546563148499, alpha: 1.0))),
    Tab(title : "Personalized Practice",subTitle: "",description: "Track Your Progress",image:"pic4",color : Color(#colorLiteral(red: 0.23307684063911438, green: 0.22320860624313354, blue: 0.6104438304901123, alpha: 1.0))),
]
