import WatchKit

class RoundsNextUpDataModel: NSObject {

    var upNextString: String?
    
    override init() {
        upNextString = ""
    }
    
    func roundsTitle(circleType:RoundsTimerController.RoundsCircleType.RawValue) -> String {
        var title: String
        switch circleType {
        case RoundsTimerController.RoundsCircleType.prepareRounds.rawValue:
            title = "Prepare"
            break
        case RoundsTimerController.RoundsCircleType.workRounds.rawValue:
            title = "Work"
            break
        case RoundsTimerController.RoundsCircleType.restRounds.rawValue:
            title = "Rest"
            break
        default:
            title = "Prepare"
        }
        return title
    }
    
    func setRoundsUpNextNames(upNextString: String, roundsCircleType: RoundsTimerController.RoundsCircleType.RawValue) {
        self.upNextString = String(format: "%@:%@", roundsTitle(circleType: roundsCircleType), upNextString)
    }
    
    
}
