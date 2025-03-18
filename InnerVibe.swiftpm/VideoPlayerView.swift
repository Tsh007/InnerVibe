import SwiftUI

import AVKit

struct VideoPlayerView : View{
    
    let videoName : String
    
    @State var player : AVPlayer
    
    init(_ name : String){
        videoName = name
        
        player = AVPlayer(url: Bundle.main.url(forResource: videoName, withExtension: "mp4")!)
    }
    
    
    var body: some View {
        VideoPlayer(player: player)
            .onAppear {
                NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: nil, queue: .main) { _ in
                    player.seek(to: .zero)
                    player.play()
                }
                player.play()
            }
        
    }
}

//#Preview(body: { 
//    VideoPlayerView("VrikshasanaVideo")
//})

extension AVPlayerViewController {
    override open func viewDidLoad() {
        super.viewDidLoad()
        self.showsPlaybackControls = false

    }
}
