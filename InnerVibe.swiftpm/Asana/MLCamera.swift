import SwiftUI
import Vision

final class MLCamera : Camera{
    lazy var bodyPoseRequest : VNDetectHumanBodyPoseRequest = {
        let request = VNDetectHumanBodyPoseRequest()
        return request
    }()
    
    var currentMLModel : BodyPoseMLModel?
}
