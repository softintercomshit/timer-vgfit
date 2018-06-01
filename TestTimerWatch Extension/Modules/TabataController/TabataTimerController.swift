import WatchKit
import Foundation
import HealthKit

class TabataTimerController: WKInterfaceController, TimerObjectDelegate {
    
    var timerObject: TimerObject?
    var session = WatchWorkoutSession()
    var tabataCircleValuesArray: [Dictionary<String, Int>]?
    var tabataIntervalsArray: [NSNumber]?
    var valuesForTimer: [NSNumber]?
    var valueForRoundsIntervals: [Double]?
    var valueCountDownArrayContent: [Double]?
    var cyclesTotalTime: Int?
    var tabataCircleType: Int?
    var currentIndex: Int = 0
    var roundsTimeInterval: Double = 0
    var rounds: Int = 0
    var cycles: Int = 0
    
    var prepareValue = 0
    var roundsValue = 0
    var cyclesValue = 0
    var workValue = 0
    var restValue = 0
    var restBCValue = 0
    
    var doubleRoundsIndex = 0.00
    var prepareTimeValue = 0
    var restBCTimeValue = 0
    
    var boolResetState = false
    var boolRoundsState = false
    
    @IBOutlet var roundsValueLabel: WKInterfaceLabel!
    @IBOutlet var cyclesValueLabel: WKInterfaceLabel!
    
    static let kCircleTypeKey = "TabataCircleType"
    static let kTimeValue = "timeValue"
    let notificationName = Notification.Name("AppDidBecomeActive")
    
    private enum TabataIndexName: Int {
        case prepareIndex=0, workIndex, restIndex, roundsIndex, cyclesIndex, restBetweenCyclesIndex
    }
    
    public enum TabataCircleType: Int {
        case prepare=0, work, rest, restBetweenCycles
    }
    var circleType: TabataCircleType?
    var tabataScene: CircleScene?
    var roundsScene: CircleScene?
    var cyclesScene: CircleScene?
    override init() {
        self.tabataCircleType = 0
        
    }
    @IBOutlet var cyclesSpKitScene: WKInterfaceSKScene!
    @IBOutlet var roundsSpKitScene: WKInterfaceSKScene!
    @IBOutlet var tabataSpKitScene: WKInterfaceSKScene!
    @IBOutlet var timeLabel: WKInterfaceLabel!
    @IBOutlet var titleLabel: WKInterfaceLabel!
    @IBOutlet var upNextLabel: WKInterfaceLabel!
    @IBOutlet var totalTimeLabel: WKInterfaceLabel!
    @IBOutlet var playButton: WKInterfaceButton!
    @IBOutlet var resetButton: WKInterfaceButton!
    
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        HealthKitSetupAssistant().authorizeHealthKit { (authorized, error) in
            guard authorized else {
                let baseMessage = "HealthKit Authorization Failed"
                
                if let error = error {
                    print("\(baseMessage). Reason: \(error.localizedDescription)")
                }else {
                    print(baseMessage)
                }
                return
            }
            print("HealthKit Successfully Authorized.")
        }
        
        tabataIntervalsArray = (context as! [NSNumber])
        print("Intervals Array: \(String(describing: tabataIntervalsArray))")
        
        tabataScene =  CircleScene(size: contentFrame.size)
        cyclesScene = CircleScene(size: contentFrame.size)
        roundsScene = CircleScene(size: contentFrame.size)
        
        tabataSpKitScene.presentScene(tabataScene)
        roundsSpKitScene.presentScene(roundsScene)
        cyclesSpKitScene.presentScene(cyclesScene)
        setupTimeObject()
        
        DispatchQueue.main.async {
            
            self.tabataScene?.show(CircleType(rawValue: CircleType.tabata.rawValue)!, at: CGPoint(x: self.contentFrame.midX, y: self.contentFrame.midY - 20), diameter: self.contentFrame.width)
            self.roundsScene?.show(CircleType(rawValue: CircleType.rounds.rawValue)!, at: CGPoint(x: self.contentFrame.midX, y: self.contentFrame.midY - 20), diameter: self.contentFrame.width)
            self.cyclesScene?.show(CircleType(rawValue: CircleType.cycles.rawValue)!, at: CGPoint(x: self.contentFrame.midX, y: self.contentFrame.midY - 20), diameter: self.contentFrame.width)
            self.cyclesScene?.setColor(color: UIColor.CircleColor.cyclesColor)
            self.roundsScene?.setColor(color: UIColor.CircleColor.roundsColor)
            self.tabataScene?.setColor(color: self.textLabelColor())
        }
    }
    
    override func willActivate() {
        super.willActivate()
    }
    
    override func didDeactivate() {
        super.didDeactivate()
        if !(boolResetState) && !(WKExtension.shared().applicationState == WKApplicationState.background){
            resetTabataTimer()
            //            HealthKitBackgroundManager.shared.endBackgroundMode()
        }
    }
    
    //MARK: TimerObject protocol functions(stubs)
    
    func timer(timerObject: TimerObject, totalTimeString: String, currentTimeString: String, iterationCompleted: Bool, needToPlaySound: Bool, timerFinished: Bool, roundsFinished: Bool) {
        boolRoundsState = roundsFinished
        timeLabel.setText(currentTimeString)
        timeLabel.setTextColor(textLabelColor())
        titleLabel.setText(title())
        titleLabel.setTextColor(textLabelColor())
        tabataScene?.setColor(color: textLabelColor())
        totalTimeLabel.setText(totalTimeString)
        playButton.setTitleWithColor(title: "PLAY", color: textLabelColor())
        
        if currentIndex + 1 < (tabataCircleValuesArray?.count)! {
            setupUpNextTitle()
        }
        
        if iterationCompleted {
            
            //            print("Before: \(currentIndex)")
            
            
            //            WKInterfaceDevice.current().play(.notification)
            
            
            if let testArray = tabataCircleValuesArray, currentIndex < testArray.count  {
                
                currentIndex += 1
                tabataCircleType = tabataCircleValuesArray![currentIndex][TabataTimerController.kCircleTypeKey]
                //                print("After: \(currentIndex)")
                
                let bool1 = tabataCircleType == TabataCircleType.rest.rawValue
                let bool2 = tabataCircleType == TabataCircleType.work.rawValue && (restValue == 0)
                
                //                print("BOOL 1: \(bool1) BOOL 2: \(bool2) ")
                
                if (bool1 || bool2) {
                    roundsValue -= 1
                    print("rounds value: \(roundsValue)")
                    roundsValueLabel.setText("\(roundsValue)")
                }
                let bool3 = roundsFinished && tabataCircleType == TabataCircleType.restBetweenCycles.rawValue
                let bool4 = roundsFinished && restBCValue == 0
                if (bool3 || bool4)  {
                    roundsScene?.setDuration(duration: 0, count: 0)
                    cyclesValue -= 1
                    roundsValue = rounds
                    roundsValueLabel.setText("\(roundsValue)")
                    cyclesValueLabel.setText("\(cyclesValue)")
                }
            }
        }
        
        if timerFinished {
            DispatchQueue.main.async {
                self.session.end()
                guard let currentWorkout = self.session.completeWorkout else {
                    fatalError("Shouldn't be able to press the done button without a saved workout.")
                }
                
                WatchWorkoutDataStore.save(tabataWorkout: currentWorkout, duration: timerObject._elapsedTime) { (success, error) in
                    if success {
                        self.session.clear()
                    }else {
                        print("There was a problem saving your workout")
                    }
                }
                
                self.boolResetState = false
                self.currentIndex = 0
                timerObject.reset()
                self.tabataSpKitScene.presentScene(nil)
                self.roundsSpKitScene.presentScene(nil)
                self.cyclesSpKitScene.presentScene(nil)
                self.tabataSpKitScene.presentScene(self.tabataScene)
                self.roundsSpKitScene.presentScene(self.roundsScene)
                self.cyclesSpKitScene.presentScene(self.cyclesScene)
                self.tabataScene?.setDuration(duration: 0, count: 0)
                self.roundsScene?.setDuration(duration: 0, count: 0)
                self.cyclesScene?.setDuration(duration: 0, count: 0)
                
                
                //            WKInterfaceDevice.current().play(.stop)
                
                
                self.setupTimeObject()
                HealthKitBackgroundManager.shared.pauseBackgroundMode()
            }
            return
        }
    }
    
    func timer(timerObject: TimerObject, totalTime: TimeInterval, currentTime: TimeInterval, currentTimeCycles: TimeInterval, totalTimeCycles: TimeInterval) {
        
        DispatchQueue.main.async {
            self.tabataScene?.setDuration(duration: currentTime/totalTime, count: (self.tabataIntervalsArray?.count)!)
            if (self.tabataCircleType != TabataCircleType.prepare.rawValue) {
                self.cyclesScene?.setDuration(duration: currentTimeCycles / totalTimeCycles,  count: (self.tabataIntervalsArray?.count)!)
            }
        }
        //        roundsValueLabel.setText("\(roundsValue)")
        //        cyclesValueLabel.setText("\(cyclesValue)")
    }
    
    
    func timer(timerObject: TimerObject, roundsCurrentTime: TimeInterval, roundsTotalTime: TimeInterval) {
        
        DispatchQueue.main.async {
            if (self.tabataCircleType != TabataCircleType.prepare.rawValue && self.tabataCircleType != TabataCircleType.restBetweenCycles.rawValue) {
                self.roundsScene?.setDuration(duration: roundsCurrentTime / roundsTotalTime,  count: (self.tabataIntervalsArray?.count)!)
                //            roundsValueLabel.setText("\(abs(roundsValue))")
                
                //            print("diferrence =  \(fabs(roundsCurrentTime - roundsTotalTime) )")
            }
        }
    }
    
    @IBAction func playButtonAction() {
        DispatchQueue.main.async {
            if (self.timerObject?.isRunning)! {
                self.playButton.setTitleWithColor(title: "RESUME", color: self.textLabelColor())
                self.session.end()
            }else {
                self.playButton.setTitleWithColor(title: "PLAY", color: self.textLabelColor())
                self.session.start()
            }
            
            self.timerObject?.playPause()
            HealthKitBackgroundManager.shared.activateBackgroundMode()
        }
    }
    
    @IBAction func resetButtonAction() {
        DispatchQueue.main.async {
            if (self.tabataScene?.circleRing?.duration)! > 0 {
                //            session.end()
                self.boolResetState = true
                let handler = { self.resetTabataTimer() }
                let action1 = WKAlertAction(title: "Yes", style: .default, handler:handler)
                let action2 = WKAlertAction(title: "Cancel", style: .destructive) {}
                self.presentAlert(withTitle: "", message: "Do you want to reset the timer?", preferredStyle: .sideBySideButtonsAlert, actions: [action1, action2])
            }
        }
    }
    
    // MARK: Other functions
    
    func setupTimer() {
        tabataCircleValuesArray = []
        rounds = Int(tabataIntervalsArray![TabataIndexName.roundsIndex.rawValue])
        cycles = Int(tabataIntervalsArray![TabataIndexName.cyclesIndex.rawValue])
        
        prepareValue = tabataIntervalsArray![TabataIndexName.prepareIndex.rawValue].intValue
        roundsValue = tabataIntervalsArray![TabataIndexName.roundsIndex.rawValue].intValue
        cyclesValue = tabataIntervalsArray![TabataIndexName.cyclesIndex.rawValue].intValue
        workValue = tabataIntervalsArray![TabataIndexName.workIndex.rawValue].intValue
        restValue = tabataIntervalsArray![TabataIndexName.restIndex.rawValue].intValue
        restBCValue = tabataIntervalsArray![TabataIndexName.restBetweenCyclesIndex.rawValue].intValue
        
        roundsTimeInterval = Double((workValue + restValue) * roundsValue - ( (cyclesValue >= 1 && restBCValue > 0) ? restValue : 0))
        
        //        print("rounds interval value:\(roundsTimeInterval)")
        valuesForTimer = []
        valueForRoundsIntervals = []
        valueCountDownArrayContent = []
        //        var arrayCountDown = [Int]()
        var dictionary = [String:Int]()
        
        if Int(tabataIntervalsArray![TabataIndexName.prepareIndex.rawValue]) > 0 {
            prepareTimeValue = Int(tabataIntervalsArray![TabataIndexName.prepareIndex.rawValue])
            valuesForTimer?.append(tabataIntervalsArray![TabataIndexName.prepareIndex.rawValue])
            valueForRoundsIntervals?.append(Double(prepareValue))
            valueCountDownArrayContent?.append(Double(prepareValue))
            dictionary = [TabataTimerController.kCircleTypeKey: TabataCircleType.prepare.rawValue, TabataTimerController.kTimeValue: Int(tabataIntervalsArray![TabataIndexName.prepareIndex.rawValue])]
            tabataCircleValuesArray?.append(dictionary)
        }
        
        for x in 0..<cycles  {
            
            for y in 0..<rounds {
                
                let restBetweenCyclesTime = Int(tabataIntervalsArray![TabataIndexName.restBetweenCyclesIndex.rawValue])
                let restTime = Int(tabataIntervalsArray![TabataIndexName.restIndex.rawValue])
                
                // work
                
                valuesForTimer?.append(tabataIntervalsArray![TabataIndexName.workIndex.rawValue])
                dictionary = [TabataTimerController.kCircleTypeKey: TabataCircleType.work.rawValue, TabataTimerController.kTimeValue: Int(tabataIntervalsArray![TabataIndexName.workIndex.rawValue])]
                tabataCircleValuesArray?.append(dictionary)
                valueCountDownArrayContent?.append(Double(workValue + restValue))
                
                if y == rounds - 1 {
                    
                    valueForRoundsIntervals?.append(roundsTimeInterval)
                    
                    if x != cycles - 1 {
                        if restBetweenCyclesTime > 0 {
                            // rest between cycles
                            valueForRoundsIntervals?.append(Double(restBCValue))
                            //                             arrayCountDown.append(restBCValue)
                            valueCountDownArrayContent?.append(Double(restBCValue))
                            restBCTimeValue = Int(tabataIntervalsArray![TabataIndexName.restBetweenCyclesIndex.rawValue])
                            valuesForTimer?.append(tabataIntervalsArray![TabataIndexName.restBetweenCyclesIndex.rawValue])
                            dictionary = [TabataTimerController.kCircleTypeKey: TabataCircleType.restBetweenCycles.rawValue, TabataTimerController.kTimeValue: Int(tabataIntervalsArray![TabataIndexName.restBetweenCyclesIndex.rawValue])]
                            tabataCircleValuesArray?.append(dictionary)
                        }else if restTime > 0 {
                            // rest
                            //                            arrayCountDown.append(restValue)
                            valueCountDownArrayContent?.append(Double(restValue))
                            valuesForTimer?.append(tabataIntervalsArray![TabataIndexName.restIndex.rawValue])
                            dictionary = [TabataTimerController.kCircleTypeKey: TabataCircleType.rest.rawValue, TabataTimerController.kTimeValue: Int(tabataIntervalsArray![TabataIndexName.restIndex.rawValue])]
                            tabataCircleValuesArray?.append(dictionary)
                        }
                    }
                    
                    break
                }else {
                    if restTime > 0 {
                        // rest
                        //                          arrayCountDown.append(restValue)
                        //                        valueCountDownArrayContent?.append(Double(restValue))
                        valuesForTimer?.append(tabataIntervalsArray![TabataIndexName.restIndex.rawValue])
                        dictionary = [TabataTimerController.kCircleTypeKey: TabataCircleType.rest.rawValue, TabataTimerController.kTimeValue: Int(tabataIntervalsArray![TabataIndexName.restIndex.rawValue])]
                        tabataCircleValuesArray?.append(dictionary)
                    }
                }
            }
        }
    }
    
    func setupTimeObject() {
        setupTimer()
        tabataCircleType = tabataCircleValuesArray![currentIndex][TabataTimerController.kCircleTypeKey]
        titleLabel.setText(title())
        setupTextTimeLabel()
        setupUpNextTitle()
        playButton.setTitleWithColor(title: "PLAY", color: textLabelColor())
        cyclesScene?.setColor(color: UIColor.CircleColor.cyclesColor)
        roundsScene?.setColor(color: UIColor.CircleColor.roundsColor)
        tabataScene?.setColor(color: textLabelColor())
        setTitle(CircleType.tabata.simpleDescription)
        //        print("Values For Timer Array: \(valuesForTimer!)")
        
        timerObject = TimerObject().initWithCountDownTimerModeAndTimerFormat(timerFormat: .MinSec, timerIntervalsArray: valuesForTimer! , tabataIntervalsArray: tabataIntervalsArray!, valuesRoundsArray: valueForRoundsIntervals!)
        timerObject?.setPrepareTimeValue(timeValue: prepareTimeValue)
        timerObject?.setRestBetweeenCycles(timeValue: restBCTimeValue)
        //        timerObject?.setRoundsValue(roundsV: rounds)
        timerObject?.delegate = self
        timerObject?.resetAfterEnding = false
        timerObject?.requestInitialValues()
        let totalTimeValue = (timerObject?.totalTimerInterval)! as NSNumber
        totalTimeLabel.setText(totalTimeValue.timeFormatString)
        roundsValueLabel.setText("\(roundsValue)")
        cyclesValueLabel.setText("\(cyclesValue)")
        cyclesValueLabel.setTextColor(UIColor.CircleColor.cyclesColor)
        roundsValueLabel.setTextColor(UIColor.CircleColor.roundsColor)
        HealthKitBackgroundManager.shared.activateBackgroundMode()
    }
    
    
    func resetTabataTimer() {
        DispatchQueue.main.async {
            if (self.tabataScene?.circleRing?.duration)! > 0 {
                self.session.end()
                //            print(self.session.completeWorkout!)
                guard let currentWorkout = self.session.completeWorkout else {
                    fatalError("Shouldn't be able to press the done button without a saved workout.")
                }
                
                WatchWorkoutDataStore.save(tabataWorkout: currentWorkout, duration: (self.timerObject?._elapsedTime)!) { (success, error) in
                    if success {
                        self.session.clear()
                    }else {
                        print("There was a problem saving your workout")
                    }
                }
            }
            self.boolResetState = false
            self.timerObject?.reset()
            self.timerObject = nil
            self.currentIndex = 0
            self.tabataSpKitScene.presentScene(nil)
            self.roundsSpKitScene.presentScene(nil)
            self.cyclesSpKitScene.presentScene(nil)
            self.tabataScene?.setDuration(duration: 0, count: 0)
            self.roundsScene?.setDuration(duration: 0, count: 0)
            self.cyclesScene?.setDuration(duration: 0, count: 0)
            self.tabataSpKitScene.presentScene(self.tabataScene)
            self.roundsSpKitScene.presentScene(self.roundsScene)
            self.cyclesSpKitScene.presentScene(self.cyclesScene)
            self.setupTimeObject()
            HealthKitBackgroundManager.shared.pauseBackgroundMode()
        }
    }
    
    
    func setSecondsValue(secondsValue: NSNumber) {
        timeLabel.setText(secondsValue.timeFormatString)
    }
    
    
    func setupTextTimeLabel() {
        let item = tabataCircleValuesArray![currentIndex]
        let numberValue = item[TabataTimerController.kTimeValue]! as NSNumber
        timeLabel.setText(numberValue.timeFormatString)
        timeLabel.setTextColor(textLabelColor())
        titleLabel.setTextColor(textLabelColor())
    }
    
    
    func setupUpNextTitle() {
        if(cyclesValue > 1 || roundsValue > 1){
            let item = tabataCircleValuesArray![currentIndex + 1]
            let circleType = item[TabataTimerController.kCircleTypeKey]
            let nextUpDataModel = NextUpDataModel()
            let numberValue = item[TabataTimerController.kTimeValue]! as NSNumber
            nextUpDataModel.setTabataNextUpNames(upNextString:numberValue.timeFormatString, tabataCircleType: circleType!)
            upNextLabel.setText(nextUpDataModel.nextUpString)
        }
    }
    
    
    func title() -> String {
        let title:String
        switch tabataCircleType {
        case TabataCircleType.prepare.rawValue?:
            title = "Prepare"
            break
        case TabataCircleType.work.rawValue?:
            title = "Work"
            break
        case TabataCircleType.rest.rawValue?:
            title = "Rest"
            break
        case TabataCircleType.restBetweenCycles.rawValue?:
            title = "Rest BC"
            break
        default:
            title = "Prepare"
            break
        }
        return title
    }
    
    
    func textLabelColor() -> UIColor {
        let color:UIColor
        switch tabataCircleType {
        case TabataCircleType.prepare.rawValue?:
            color = UIColor(red: 255/255, green: 230/255, blue: 32/255, alpha: 1)
            break
        case TabataCircleType.work.rawValue?:
            color = UIColor(red: 4/255, green: 222/255, blue: 113/255, alpha: 1)
            break
        case TabataCircleType.rest.rawValue?:
            color = UIColor(red: 255/255, green: 59/255, blue: 48/255, alpha: 1)
            break
        case TabataCircleType.restBetweenCycles.rawValue?:
            color = UIColor(red: 255/255, green: 59/255, blue: 48/255, alpha: 1)
            break
        default:
            color = UIColor(red: 255/255, green: 230/255, blue: 32/255, alpha: 1)
            break
        }
        return color
    }
    
}


