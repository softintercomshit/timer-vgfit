import WatchKit

class NextUpDataModel: NSObject {

    var nextUpString: String?
    
    override init() {
        nextUpString = ""
    }
    
    func tabataTitle(circleType:TabataTimerController.TabataCircleType.RawValue) -> String {
        var title:String
        switch circleType {
        case TabataTimerController.TabataCircleType.prepare.rawValue:
            title = "Prepare"
            break
        case TabataTimerController.TabataCircleType.work.rawValue:
            title = "Work"
            break
        case TabataTimerController.TabataCircleType.rest.rawValue:
            title = "Rest"
            break
        case TabataTimerController.TabataCircleType.restBetweenCycles.rawValue:
            title = "Rest BC"
            break
        default:
            title = "Prepare"
        }
        return title
    }
    
    func setTabataNextUpNames(upNextString: String, tabataCircleType:TabataTimerController.TabataCircleType.RawValue) {
        self.nextUpString = String(format: "%@:%@",tabataTitle(circleType: tabataCircleType),upNextString)
//        print("next up \(String(describing: self.nextUpString))")
    }
}
