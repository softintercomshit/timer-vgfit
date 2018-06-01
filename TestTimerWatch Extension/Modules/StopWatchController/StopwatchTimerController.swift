import WatchKit
import Foundation


class StopwatchTimerController: WKInterfaceController, TimerObjectDelegate {
    
    var stopwatchTimerObject: TimerObject?
    var stopwatchCircleValuesArray: [Dictionary<String, Int>]?
    var stopwatchIntervalsArray: [NSNumber]?
    var valuesForTimer: [NSNumber]?
    var valueForStopwatchIntervals: [Double]?
    var stopwatchCircleType: Int?
    var currentIndex: Int = 0
    var stopwatchTimeInterval: Double = 0
    
    var prepareSValue = 0
    var roundsValue = 0
    
    static let kStopwatchCircleTypeKey = "StopwatchCircleType"
    static let kStopwatchTimeValue = "stopwatchTimeValue"
    
    private enum StopwatchIndexName: Int {
        case prepareStopwatchIndex=0, timeLapIndex
    }
    
    public enum StopwatchCircleType: Int {
        case prepareStopwatch=0, timeLapStopwatch
    }
    
    var boolResetState = false
    
    var circleStopwatchType: StopwatchCircleType?
    var stopwatchCircleScene: CircleScene?
    
    override init() {
        self.stopwatchCircleType = 0
    }
    
    @IBOutlet var stopwatchTimeLabel: WKInterfaceLabel!
    @IBOutlet var stopwatchTitleLabel: WKInterfaceLabel!
    @IBOutlet var nextUpStopwatchLabel: WKInterfaceLabel!
    @IBOutlet var stopwatchPlayButton: WKInterfaceButton!
    @IBOutlet var stopwatchResetButton: WKInterfaceButton!
    
    @IBOutlet var stopwatchSpriteKitScene: WKInterfaceSKScene!
    
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        stopwatchIntervalsArray = (context as! [NSNumber])
        setupStopwatchTimerObject()
        
        stopwatchCircleScene = CircleScene(size: contentFrame.size)
        stopwatchSpriteKitScene.presentScene(stopwatchCircleScene)
        
        DispatchQueue.main.async {
            self.stopwatchCircleScene?.showStopwatchCircle(at: CGPoint(x: self.contentFrame.midX, y: self.contentFrame.midY - 20), diameter: self.contentFrame.width)
            self.stopwatchCircleScene?.setColor(color: UIColor.colorStopwatch(stopwatchCircleType: self.stopwatchCircleType!))
        }
        setTitle("Stopwatch")
    }
    
    override func willActivate() {
        super.willActivate()
    }
    
    override func didDeactivate() {
        super.didDeactivate()
        if !(boolResetState) && !(WKExtension.shared().applicationState == WKApplicationState.background){
            resetStopwatchTimer()
//            HealthKitBackgroundManager.shared.endBackgroundMode()
        }
    }
    
    func timer(timerObject: TimerObject, isPrepare: Bool, lapCompleted: Bool, timeString: String) {
        
        stopwatchTimeLabel.setText(timeString)
        stopwatchTitleLabel.setText(titleTimer())
        stopwatchTimeLabel.setTextColor(UIColor.colorStopwatch(stopwatchCircleType: stopwatchCircleType!))
        stopwatchTitleLabel.setTextColor(UIColor.colorStopwatch(stopwatchCircleType: stopwatchCircleType!))
        stopwatchCircleScene?.setColor(color: UIColor.colorStopwatch(stopwatchCircleType: stopwatchCircleType!))
        stopwatchPlayButton.setTitleWithColor(title: "PLAY", color: textLabelColor())
        if currentIndex + 1 < (stopwatchCircleValuesArray?.count)! {
            let itemModel = stopwatchCircleValuesArray![currentIndex + 1]
            let circleType = itemModel[StopwatchTimerController.kStopwatchCircleTypeKey]
            let stopwatchNextUpDataModel = StopwatchNextUpDataModel()
            let numberValue = itemModel[StopwatchTimerController.kStopwatchTimeValue]! as NSNumber
            
            stopwatchNextUpDataModel.setStopwatchUpNextNames(upNextString: numberValue.timeFormatString, stopwatchCircleType: circleType! as StopwatchTimerController.StopwatchCircleType.RawValue)
            nextUpStopwatchLabel.setText(stopwatchNextUpDataModel.upNextString)
        }
        if !isPrepare {
            stopwatchCircleType = stopwatchCircleValuesArray![StopwatchCircleType.timeLapStopwatch.rawValue][StopwatchTimerController.kStopwatchCircleTypeKey]
            stopwatchCircleScene?.setColor(color: UIColor.colorStopwatch(stopwatchCircleType: stopwatchCircleType!))
        }
        if lapCompleted {
            WKInterfaceDevice.current().play(.notification)
        }
    }
    
    func timer(timerObject: TimerObject, lapTime: TimeInterval, totalTime: TimeInterval, isPrepare: Bool) {
        DispatchQueue.main.async {
            self.stopwatchCircleScene?.setStopwatchDuration(duration: lapTime/totalTime)
        }
    }
    
    @IBAction func stopwatchPlayButtonAction() {
        
        if(stopwatchTimerObject?.isRunning)! {
            stopwatchPlayButton.setTitleWithColor(title: "RESUME", color: textLabelColor())
        }else{
            stopwatchPlayButton.setTitleWithColor(title: "PLAY", color: textLabelColor())
        }
        stopwatchTimerObject?.playPause()
    }
    
    @IBAction func stopwatchResetButtonAction() {
        if (stopwatchTimerObject?.isRunning)! {
            boolResetState = true
            let handler = { self.resetStopwatchTimer() }
            let action1 = WKAlertAction(title: "Yes", style: .default, handler:handler)
            let action2 = WKAlertAction(title: "Cancel", style: .destructive) {}
            presentAlert(withTitle: "", message: "Do you want to reset the timer?", preferredStyle: .actionSheet, actions: [action1, action2])
        }
    }
    
    // MARK: Other functions
    
    func setupStopwatchTimer() {
        stopwatchCircleValuesArray = []
        valuesForTimer = []
        valueForStopwatchIntervals = []
        var dictionary = [String:Int]()
        if Int(stopwatchIntervalsArray![StopwatchIndexName.prepareStopwatchIndex.rawValue]) > 0 {
            valuesForTimer?.append(stopwatchIntervalsArray![StopwatchIndexName.prepareStopwatchIndex.rawValue])
            dictionary = [StopwatchTimerController.kStopwatchCircleTypeKey: StopwatchCircleType.prepareStopwatch.rawValue, StopwatchTimerController.kStopwatchTimeValue: Int(stopwatchIntervalsArray![StopwatchIndexName.prepareStopwatchIndex.rawValue])]
            stopwatchCircleValuesArray?.append(dictionary)
        } else {
            valuesForTimer?.append(stopwatchIntervalsArray![StopwatchIndexName.timeLapIndex.rawValue])
            let number = 0
            dictionary = [StopwatchTimerController.kStopwatchCircleTypeKey: StopwatchCircleType.prepareStopwatch.rawValue, StopwatchTimerController.kStopwatchTimeValue: number]
            stopwatchCircleValuesArray?.append(dictionary)
        }
        
        valuesForTimer?.append(stopwatchIntervalsArray![StopwatchIndexName.timeLapIndex.rawValue])
        dictionary = [StopwatchTimerController.kStopwatchCircleTypeKey: StopwatchCircleType.timeLapStopwatch.rawValue, StopwatchTimerController.kStopwatchTimeValue: Int(stopwatchIntervalsArray![StopwatchIndexName.timeLapIndex.rawValue])]
        stopwatchCircleValuesArray?.append(dictionary)
    }
    
    func setupStopwatchTimerObject() {
        self.setupStopwatchTimer()
        
        
        stopwatchTimerObject = TimerObject().initWithCountUpTimerModeAndTimerFormat(timerFormat: .MinSec, timerIntervalsArray: valuesForTimer!, prepareTime: Int(stopwatchIntervalsArray![StopwatchCircleType.prepareStopwatch.rawValue]), lapTime: Int(stopwatchIntervalsArray![StopwatchCircleType.timeLapStopwatch.rawValue]))
        
        if Int(stopwatchIntervalsArray![StopwatchCircleType.prepareStopwatch.rawValue]) == 0 {
            //circle total time
            stopwatchCircleType = stopwatchCircleValuesArray![StopwatchCircleType.timeLapStopwatch.rawValue][StopwatchTimerController.kStopwatchCircleTypeKey]
        }else {
            //circle total time
            stopwatchCircleType = stopwatchCircleValuesArray![StopwatchCircleType.prepareStopwatch.rawValue][StopwatchTimerController.kStopwatchCircleTypeKey]
        }
        stopwatchCircleScene?.setColor(color: textLabelColor())
        stopwatchTitleLabel.setText(titleTimer())
        setupTimeLabelText()
        stopwatchTimeLabel.setTextColor(UIColor.colorStopwatch(stopwatchCircleType: stopwatchCircleType!))
        stopwatchTitleLabel.setTextColor(UIColor.colorStopwatch(stopwatchCircleType: stopwatchCircleType!))
        stopwatchPlayButton.setTitleWithColor(title: "PLAY", color: textLabelColor())
        stopwatchTimerObject?.delegate = self
        stopwatchTimerObject?.requestInitialValues()
        HealthKitBackgroundManager.shared.activateBackgroundMode()
    }
    
    
    func resetStopwatchTimer() {
        DispatchQueue.main.async {
            HealthKitBackgroundManager.shared.pauseBackgroundMode()
            self.currentIndex = 0
            self.stopwatchTimerObject?.reset()
            self.stopwatchSpriteKitScene.presentScene(nil)
            self.stopwatchCircleScene?.setStopwatchDuration(duration: 0)
            self.stopwatchSpriteKitScene.presentScene(self.stopwatchCircleScene)
            self.setupStopwatchTimerObject()
        }
    }
    
    func titleTimer() -> String {
        let title:String
        switch stopwatchCircleType {
        case StopwatchCircleType.prepareStopwatch.rawValue?:
            title = "Prepare"
            break
        case StopwatchCircleType.timeLapStopwatch.rawValue?:
            title = "Time lap"
            break
        default:
            title = "Prepare"
            break
        }
        return title
    }
    
    func setupTimeLabelText() {
        if Int(stopwatchIntervalsArray![StopwatchCircleType.prepareStopwatch.rawValue]) == 0 {
            let item = stopwatchCircleValuesArray![StopwatchCircleType.prepareStopwatch.rawValue]
            let numberValue = item[StopwatchTimerController.kStopwatchTimeValue]! as NSNumber
            stopwatchTimeLabel.setText(numberValue.timeFormatString)
        }else {
            let item = stopwatchCircleValuesArray![StopwatchCircleType.prepareStopwatch.rawValue]
            let numberValue = item[StopwatchTimerController.kStopwatchTimeValue]! as NSNumber
            stopwatchTimeLabel.setText(numberValue.timeFormatString)
        }
    }
    
    func textLabelColor() -> UIColor {
        let color:UIColor
        switch stopwatchCircleType {
        case StopwatchCircleType.prepareStopwatch.rawValue?:
            color = UIColor(red: 255/255, green: 230/255, blue: 32/255, alpha: 1)
            break
        case StopwatchCircleType.timeLapStopwatch.rawValue?:
            color = UIColor(red: 4/255, green: 222/255, blue: 113/255, alpha: 1)
            break
        default:
            color = UIColor(red: 255/255, green: 230/255, blue: 32/255, alpha: 1)
            break
        }
        return color
    }
}
