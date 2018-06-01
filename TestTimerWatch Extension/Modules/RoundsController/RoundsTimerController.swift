    import WatchKit
    import Foundation
    
    
    class RoundsTimerController: WKInterfaceController, TimerObjectDelegate {
        
        var timerObject: TimerObject?
        var roundsCircleValuesArray: [Dictionary<String, Int>]?
        var roundsIntervalsArray: [NSNumber]?
        var valuesForTimer: [NSNumber]?
        var valueForRoundsIntervals: [Double]?
        var roundsCircleType: Int?
        var currentIndex: Int = 0
        var roundsTimeInterval: Double = 0
        var rounds: Int = 0
        
        var prepareValue = 0
        var roundsValue = 0
        var workValue = 0
        var restValue = 0
        
        var doubleRoundsIndex = 0.00
        var prepareTimeValue = 0
        static let kRoundsCircleTypeKey = "RoundsCircleType"
        static let kRoundsTimeValue = "roundsTimeValue"
        
        private enum RoundsIndexName: Int {
            case prepareRoundsIndex=0, workRoundsIndex, restRoundsIndex, roundsIndex
        }
        
        public enum RoundsCircleType: Int {
            case prepareRounds=0, workRounds, restRounds
        }
        
        var circleRoundsType: RoundsCircleType?
        var roundsScene: CircleScene?
        var roundsCountScene: CircleScene?
        
        var boolResetState = false
        
        override init() {
            self.roundsCircleType = 0
            
        }
        
        @IBOutlet var roundsTimeLabel: WKInterfaceLabel!
        @IBOutlet var roundsTitleLabel: WKInterfaceLabel!
        @IBOutlet var nextUpRoundsLabel: WKInterfaceLabel!
        @IBOutlet var roundsTotalTimeLabel: WKInterfaceLabel!
        @IBOutlet var roundsPlayButton: WKInterfaceButton!
        @IBOutlet var roundsResetButton: WKInterfaceButton!
        
        @IBOutlet var roundsCSpKitScene: WKInterfaceSKScene!
        @IBOutlet var roundsCountSpKitScene: WKInterfaceSKScene!
        @IBOutlet var roundsValueLabel: WKInterfaceLabel!
        
        override func awake(withContext context: Any?) {
            super.awake(withContext: context)
            roundsIntervalsArray = (context as! [NSNumber])
            
            setupRoundsTimerObject()
            
            roundsScene =  CircleScene(size: contentFrame.size)
            roundsCountScene = CircleScene(size: contentFrame.size)
            roundsCSpKitScene.presentScene(roundsScene)
            roundsCountSpKitScene.presentScene(roundsCountScene)
            DispatchQueue.main.async {
                self.roundsScene?.display(RoundCircleType(rawValue: RoundCircleType.roundsCircle.rawValue)!, at: CGPoint(x: self.contentFrame.midX, y: self.contentFrame.midY - 20), diameter: self.contentFrame.width)
                self.roundsCountScene?.display(RoundCircleType(rawValue: RoundCircleType.roundsCount.rawValue)!, at: CGPoint(x: self.contentFrame.midX, y: self.contentFrame.midY - 20), diameter: self.contentFrame.width)
                self.roundsCountScene?.setColor(color: UIColor.CircleColor.roundsColor)
                self.roundsScene?.setColor(color: self.textLabelColor())
            }
            setTitle("Rounds")
        }
        
        override func willActivate() {
            super.willActivate()
        }
        
        override func didDeactivate() {
            super.didDeactivate()
            if !(boolResetState) && !(WKExtension.shared().applicationState == WKApplicationState.background){
                resetRoundsTimer()
//                HealthKitBackgroundManager.shared.endBackgroundMode()
            }
        }
        
        func timer(timerObject: TimerObject, totalTimeString: String, currentTimeString: String, iterationCompleted: Bool, needToPlaySound: Bool, timerFinished: Bool) {
            roundsTimeLabel.setText(currentTimeString)
            roundsTimeLabel.setTextColor(textLabelColor())
            roundsTitleLabel.setText(title())
            roundsTitleLabel.setTextColor(textLabelColor())
            roundsTotalTimeLabel.setText(totalTimeString)
            roundsScene?.setColor(color: textLabelColor())
            roundsPlayButton.setTitleWithColor(title: "PLAY", color: textLabelColor())
            if currentIndex + 1 < (roundsCircleValuesArray?.count)! {
                setupUpNextTitle()
            }
            
            if iterationCompleted {
                
                currentIndex += 1
                WKInterfaceDevice.current().play(.notification)
                if ((roundsCircleType == RoundsCircleType.restRounds.rawValue && restValue > 0) || (roundsCircleType == RoundsCircleType.workRounds.rawValue && rounds == 1) || (roundsCircleType == RoundsCircleType.workRounds.rawValue  && restValue == 0)) {
                    roundsValue -= 1
                    roundsValueLabel.setText("\(roundsValue)")
                }
                roundsCircleType = roundsCircleValuesArray![currentIndex][RoundsTimerController.kRoundsCircleTypeKey]
            }
            
            if timerFinished {
                boolResetState = false
                currentIndex = 0
                timerObject.reset()
                roundsCountSpKitScene.presentScene(nil)
                roundsCSpKitScene.presentScene(nil)
                
                roundsCSpKitScene.presentScene(roundsCountScene)
                roundsCountSpKitScene.presentScene(roundsScene)
                
                //                roundsScene?.setDuration(duration: 0, count: 0)
                //                roundsCountScene?.setDuration(duration: 0, count: 0)
                WKInterfaceDevice.current().play(.stop)
                setupRoundsTimerObject()
                HealthKitBackgroundManager.shared.pauseBackgroundMode()
                return
            }
        }
        
        func timer(timerObject: TimerObject, totalTime: TimeInterval, currentTime: TimeInterval, currentTimeCycles: TimeInterval, totalTimeCycles: TimeInterval) {
            DispatchQueue.main.async {
                self.roundsScene?.setDuration(duration: currentTime/totalTime, count: (self.roundsIntervalsArray?.count)!)
                
                if (self.roundsCircleType != RoundsCircleType.prepareRounds.rawValue) {
                    self.roundsCountScene?.setDuration(duration: currentTimeCycles/totalTimeCycles, count: (self.roundsIntervalsArray?.count)!)
                }
            }
        }
        
        // MARK: Button actions
        
        @IBAction func roundsPlayButtonAction() {
            if(timerObject?.isRunning)! {
                roundsPlayButton.setTitleWithColor(title: "RESUME", color: textLabelColor())
            }else{
                roundsPlayButton.setTitleWithColor(title: "PLAY", color: textLabelColor())
            }
            timerObject?.playPause()
            
        }
        
        @IBAction func roundsResetButtonAction() {
            if (roundsScene?.circleRing?.duration)! > 0 {
                boolResetState = true
                let handler = { self.resetRoundsTimer() }
                let action1 = WKAlertAction(title: "Yes", style: .default, handler:handler)
                let action2 = WKAlertAction(title: "Cancel", style: .destructive) {}
                
                presentAlert(withTitle: "", message: "Do you want to reset the timer?", preferredStyle: .sideBySideButtonsAlert, actions: [action1, action2])
            }
        }
        
        
        // MARK: Other functions
        
        func setupRoundsTimer() {
            roundsCircleValuesArray = []
            rounds = Int(roundsIntervalsArray![RoundsIndexName.roundsIndex.rawValue])
            
            roundsValue = roundsIntervalsArray![RoundsIndexName.roundsIndex.rawValue].intValue
            workValue = roundsIntervalsArray![RoundsIndexName.workRoundsIndex.rawValue].intValue
            restValue = roundsIntervalsArray![RoundsIndexName.restRoundsIndex.rawValue].intValue
            
            roundsTimeInterval = Double((workValue + restValue) * roundsValue - ((roundsValue > 1) ? restValue : 0))
            
            valuesForTimer = []
            valueForRoundsIntervals = []
            var dictionary = [String:Int]()
            
            if Int(roundsIntervalsArray![RoundsIndexName.prepareRoundsIndex.rawValue]) > 0 {
                valuesForTimer?.append(roundsIntervalsArray![RoundsIndexName.prepareRoundsIndex.rawValue])
                prepareTimeValue = Int(roundsIntervalsArray![RoundsIndexName.prepareRoundsIndex.rawValue])
                
                dictionary = [RoundsTimerController.kRoundsCircleTypeKey: RoundsCircleType.prepareRounds.rawValue, RoundsTimerController.kRoundsTimeValue: Int(roundsIntervalsArray![RoundsIndexName.prepareRoundsIndex.rawValue])]
                roundsCircleValuesArray?.append(dictionary)
            }
            
            for i in 0..<rounds {
                let restTime = Int(roundsIntervalsArray![RoundsIndexName.restRoundsIndex.rawValue])
                
                valuesForTimer?.append(roundsIntervalsArray![RoundsIndexName.workRoundsIndex.rawValue])
                dictionary = [RoundsTimerController.kRoundsCircleTypeKey: RoundsCircleType.workRounds.rawValue, RoundsTimerController.kRoundsTimeValue: Int(roundsIntervalsArray![RoundsIndexName.workRoundsIndex.rawValue])]
                
                roundsCircleValuesArray?.append(dictionary)
                
                if i != rounds - 1 {
                    if restTime > 0 {
                        valuesForTimer?.append(roundsIntervalsArray![RoundsIndexName.restRoundsIndex.rawValue])
                        dictionary = [RoundsTimerController.kRoundsCircleTypeKey: RoundsCircleType.restRounds.rawValue, RoundsTimerController.kRoundsTimeValue: Int(roundsIntervalsArray![RoundsIndexName.restRoundsIndex.rawValue])]
                        roundsCircleValuesArray?.append(dictionary)
                    }
                }
            }
            print("rounds time interval : \(roundsTimeInterval)")
            
            
        }
        
        func setupRoundsTimerObject() {
            setupRoundsTimer()
            roundsCircleType = roundsCircleValuesArray![currentIndex][RoundsTimerController.kRoundsCircleTypeKey]
            
            print("Fonts: \(UIFont.familyNames)")
            //        NSLog(@"Courier New family fonts: %@", [UIFont fontNamesForFamilyName:@"Courier New"]);
            
            roundsTitleLabel.setText(title())
            setupTimeLabelTitle()
            setupUpNextTitle()
            roundsPlayButton.setTitleWithColor(title: "PLAY", color: textLabelColor())
            roundsCountScene?.setColor(color: UIColor.CircleColor.roundsColor)
            roundsScene?.setColor(color: textLabelColor())
            roundsValueLabel.setTextColor(UIColor.CircleColor.roundsColor)
            
            timerObject = TimerObject().initWithRoundsCountDownTimerModeAndTimerFormat(timerFormat: .MinSec, timerIntervalsArray: valuesForTimer!)
            timerObject?.delegate = self
            timerObject?.resetAfterEnding = false
            timerObject?.requestInitialValues()
            timerObject?.setPrepareTimeValue(timeValue: prepareTimeValue)
            
            roundsValueLabel.setText("\(roundsValue)")
            
            let totalTimeValue = (timerObject?.totalTimerInterval)! as NSNumber
            
            
            let avenirNext = UIFont(name: "Avenir Next LT Pro", size: 12.0)!
            let fontAttrs = [NSFontAttributeName : avenirNext]
            let attString = NSMutableAttributedString(string: totalTimeValue.timeFormatString)
            attString.setAttributes([NSFontAttributeName: fontAttrs], range: NSMakeRange(0, attString.length))
            
            roundsTotalTimeLabel.setAttributedText(attString)
            HealthKitBackgroundManager.shared.activateBackgroundMode()
            
        }
        
        func resetRoundsTimer() {
            boolResetState = false
            timerObject?.reset()
            self.roundsCSpKitScene.presentScene(nil)
            self.roundsCountSpKitScene.presentScene(nil)
            roundsCountScene?.setDuration(duration: 0, count: 0)
            roundsScene?.setDuration(duration: 0, count: 0)
            self.roundsCSpKitScene.presentScene(roundsScene)
            self.roundsCountSpKitScene.presentScene(roundsCountScene)
            currentIndex = 0
            setupRoundsTimerObject()
            HealthKitBackgroundManager.shared.pauseBackgroundMode()
        }
        
        func title() -> String {
            let title:String
            switch roundsCircleType {
            case RoundsCircleType.prepareRounds.rawValue?:
                title = "Prepare"
                break
            case RoundsCircleType.workRounds.rawValue?:
                title = "Work"
                break
            case RoundsCircleType.restRounds.rawValue?:
                title = "Rest"
                break
            default:
                title = "Prepare"
                break
            }
            return title
        }
        
        
        func textLabelColor() -> UIColor {
            let color:UIColor
            switch roundsCircleType {
            case RoundsCircleType.prepareRounds.rawValue?:
                color = UIColor(red: 255/255, green: 230/255, blue: 32/255, alpha: 1)
                break
            case RoundsCircleType.workRounds.rawValue?:
                color = UIColor(red: 4/255, green: 222/255, blue: 113/255, alpha: 1)
                break
            case RoundsCircleType.restRounds.rawValue?:
                color = UIColor(red: 255/255, green: 59/255, blue: 48/255, alpha: 1)
                break
            default:
                color = UIColor(red: 255/255, green: 230/255, blue: 32/255, alpha: 1)
                break
            }
            return color
        }
        
        
        func setupTimeLabelTitle() {
            let item = roundsCircleValuesArray![currentIndex]
            let numberValue = item[RoundsTimerController.kRoundsTimeValue]! as NSNumber
            roundsTimeLabel.setText(numberValue.timeFormatString)
            roundsTimeLabel.setTextColor(textLabelColor())
            roundsTitleLabel.setTextColor(textLabelColor())
        }
        
        func setupUpNextTitle() {
            if(roundsValue > 1){
                let roundsNextUpDataModel = RoundsNextUpDataModel()
                let itemUpNext = roundsCircleValuesArray![currentIndex + 1]
                let circleType = itemUpNext[RoundsTimerController.kRoundsCircleTypeKey]
                let upNextValue = itemUpNext[RoundsTimerController.kRoundsTimeValue]! as NSNumber
                roundsNextUpDataModel.setRoundsUpNextNames(upNextString: upNextValue.timeFormatString, roundsCircleType: circleType!)
                nextUpRoundsLabel.setText(roundsNextUpDataModel.upNextString)
                roundsTimeLabel.setTextColor(textLabelColor())
            }
        }
    }
    
    extension WKInterfaceButton {
        func setTitleWithColor(title: String, color: UIColor) {
            let attString = NSMutableAttributedString(string: title)
            attString.setAttributes([NSForegroundColorAttributeName: color], range: NSMakeRange(0, attString.length))
            self.setAttributedTitle(attString)
        }
    }
