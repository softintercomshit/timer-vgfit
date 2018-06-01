import WatchKit

class StopwatchNextUpDataModel: NSObject {
    
    var upNextString: String?
    
    override init() {
        upNextString = ""
    }
    
    func stopwatchTitle(circleType:StopwatchTimerController.StopwatchCircleType.RawValue) -> String {
        var title: String
        switch circleType {
        case StopwatchTimerController.StopwatchCircleType.prepareStopwatch.rawValue:
            title = "Prepare"
            break
        case StopwatchTimerController.StopwatchCircleType.timeLapStopwatch.rawValue:
            title = "Time lap"
            break
        default:
            title = "Prepare"
        }
        return title
    }
    
    
    func setStopwatchUpNextNames(upNextString: String, stopwatchCircleType: StopwatchTimerController.StopwatchCircleType.RawValue) {
        self.upNextString = String(format: "%@:%@", stopwatchTitle(circleType: stopwatchCircleType), upNextString)
    }
    
    
}
