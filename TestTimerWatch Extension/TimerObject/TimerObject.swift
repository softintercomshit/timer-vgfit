import WatchKit
import AVFoundation
import UIKit

@objc protocol TimerObjectDelegate {
    @objc optional func timer( timerObject: TimerObject, totalTimeString: String, currentTimeString: String, iterationCompleted: Bool, needToPlaySound:Bool, timerFinished:Bool, roundsFinished: Bool)
    @objc optional func timer( timerObject: TimerObject, totalTimeString: String, currentTimeString: String, iterationCompleted: Bool, needToPlaySound:Bool, timerFinished:Bool)
    @objc optional func timer( timerObject: TimerObject, isPrepare: Bool, lapCompleted:Bool, timeString: String)
    @objc optional func timer( timerObject: TimerObject, totalTime: TimeInterval, currentTime: TimeInterval, currentTimeCycles: TimeInterval, totalTimeCycles: TimeInterval)
    @objc optional func timer( timerObject: TimerObject, roundsCurrentTime: TimeInterval, roundsTotalTime: TimeInterval)
    @objc optional func timer( timerObject: TimerObject, lapTime: TimeInterval, totalTime: TimeInterval, isPrepare: Bool)
}

class TimerObject: NSObject {
    
    enum TimerFormat: Int {
        case MinSec=0, MilisecondsOneDigit, MilisecondsTwoDigits
    }
    private enum TimerMode: Int {
        case CountDown, CountUp
    }
    private enum TimerType: Int {
        case Tabata, Rounds, Stopwatch
    }
    
    let kTotalTimeIndex = 0
    let kCurrentTimeIndex = 1
    
    var timerFormat: TimerFormat?
    var delegate: TimerObjectDelegate?
    var resetAfterEnding: Bool?
    var isRunning: Bool = false
    
    var _elapsedTime: TimeInterval = 0.00
    
    var prepareTimeValue = 0
    var restBetweenCyclesTimeValue = 0
    

    var currentProgressMinSecRounds: Double = 0.00
    var totalTimerInterval: TimeInterval = 0.00
    private var _timerMode: TimerMode?
    private var _timerType: TimerType?
    private var _timerIntervalsArray: [NSNumber]?
    private var _valuesRoundsArray: [Double]?
    private var _tabataIntervalsArray: [NSNumber]?
    private var timer: Timer?
    
    private var timerFormatIntervalValue: TimeInterval = 0.00
    private var _prepareTime: TimeInterval = 0.00
    private var stoppedInterval: TimeInterval = 0.00
    private var needToPlaySoundLastValue: TimeInterval = 0.00
    private var currentArrayIndex: Int = 0
    private var currentArrayRoundsIndex: Int = 0
    private var _lapTime: Int = 0
    private var lastLapTimeValue: Int = 0
    private var lastLapRoundsTimeValue: Int = 0
    
    private var iterationCompleted: Bool?
    private var timerFinished: Bool?
    private var roundsFinished: Bool?
    private var isPrepareTime: Bool = false
    private var fireTime: NSDate?
    private var totalTimeString: String?
    private var currentTimeFormatString: String?
    private var initTimeInterval: TimeInterval?
    private var currentTimerInterval: Int?
    private var state: Bool?
    
    //    @available(*, unavailable)
    override init() {
        super.init()
    }
    
    //    func initWithCountDownTimerModeAndTimerFormat(timerFormat: TimerFormat, timerIntervalsArray: [NSNumber], valuesRoundsArray: [Double], tabataIntervalsArray: [NSNumber]) -> TimerObject{
    func initWithCountDownTimerModeAndTimerFormat(timerFormat: TimerFormat, timerIntervalsArray: [NSNumber], tabataIntervalsArray: [NSNumber], valuesRoundsArray: [Double]) -> TimerObject{
        _timerIntervalsArray = timerIntervalsArray
        _valuesRoundsArray = valuesRoundsArray
        _tabataIntervalsArray = tabataIntervalsArray
        _timerMode = .CountDown
        _timerType = .Tabata
        //        _prepareTime = TimeInterval(tabataIntervalsArray[0])
        self.timerFormat = timerFormat
        timerFormatIntervalValue = 0.001
        //        print("array: \(timerIntervalsArray)")
        if !timerIntervalsArray.isEmpty {
            let numberSum = timerIntervalsArray.reduce(0, { x, y in
                x + y
            })
            print(numberSum)
            totalTimerInterval = (numberSum as? TimeInterval)!
        }
        return self
    }
    
    func initWithRoundsCountDownTimerModeAndTimerFormat(timerFormat: TimerFormat, timerIntervalsArray: [NSNumber]) -> TimerObject {
        _timerIntervalsArray = timerIntervalsArray
        _timerMode = .CountDown
        _timerType = .Rounds
        self.timerFormat = timerFormat
        timerFormatIntervalValue = 0.001
        if !timerIntervalsArray.isEmpty {
            let numberSum = timerIntervalsArray.reduce(0, { x, y in
                x + y
            })
            print(numberSum)
            totalTimerInterval = (numberSum as? TimeInterval)!
        }
        return self
    }
    
    func setPrepareTimeValue(timeValue: Int) {
        prepareTimeValue = timeValue
    }
    
    func setRestBetweeenCycles(timeValue: Int) {
        restBetweenCyclesTimeValue = timeValue
    }
    
    func initWithCountUpTimerModeAndTimerFormat(timerFormat: TimerFormat, timerIntervalsArray: [NSNumber] , prepareTime:Int, lapTime:Int) -> TimerObject{
        _lapTime = lapTime
        _prepareTime = TimeInterval(prepareTime)
        _timerMode = .CountUp
        _timerIntervalsArray = timerIntervalsArray
        self.timerFormat = timerFormat
        timerFormatIntervalValue = 0.001
        return self
    }
    
    // MARK: Public Methods
    func start() {
        timer = Timer.scheduledTimer(timeInterval: timerFormatIntervalValue, target: self, selector:#selector(updateTimer) , userInfo: nil, repeats: true)
        timer?.fire()
        fireTime = NSDate()
        isRunning = true
    }
    
    func playPause() {
        if (isRunning) {
            timer?.invalidate()
            stoppedInterval += NSDate().timeIntervalSince((fireTime! as Date))
            //            print(stoppedInterval)
            isRunning = false
        }else{
            timer = Timer.scheduledTimer(timeInterval: 0.001, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
            fireTime = NSDate()
            timer?.fire()
            isRunning = true
        }
    }
    
    func reset() {
        resetWithCallBack(callback: true)
    }
    
    func requestInitialValues() {
        var initialTimerInterval: TimeInterval = 0
        if _prepareTime != 0 {
            initialTimerInterval = _prepareTime
            print(initialTimerInterval)
        }
        initTimeInterval = initialTimerInterval
    }
    
    func requestCurrentValues() {
        self.timerFormat == .MinSec ? sendCallbackDelegate(elapsedTime: stoppedInterval) : sendCallbackDelegate(elapsedTime: stoppedInterval + 0.99)
    }
    
    func requestCurrentStopwatchValues() {
        sendCallbackDelegate(elapsedTime: stoppedInterval - _prepareTime)
    }
    
    // MARK: Private functions
    func resetWithCallBack(callback: Bool) {
        timer?.invalidate()
        fireTime = nil
        stoppedInterval = 0
        isRunning = false
        if _timerMode == .CountDown {
            currentArrayIndex = 0
            currentArrayRoundsIndex = 0
        }
        lastLapTimeValue = 0
        lastLapRoundsTimeValue = 0
        if callback {
            requestInitialValues()
        }
    }
    
    func updateTimer() {
//        let elapsedTime = NSDate().timeIntervalSince(fireTime! as Date) + stoppedInterval
        _elapsedTime = NSDate().timeIntervalSince(fireTime! as Date) + stoppedInterval
        if _timerMode == .CountDown {
            if _elapsedTime >= totalTimerInterval {
                iterationCompleted = true
                timer?.invalidate()
                isRunning = false
                if self.resetAfterEnding! {
                    resetWithCallBack(callback: true)
                    start()
                }else{
                    currentArrayIndex = 0
                    currentArrayRoundsIndex = 0
                    requestInitialValues()
                    return
                }
            }
            
            
            if _elapsedTime >= currentTimeInterval() {
                iterationCompleted = true
                currentArrayIndex += 1
            }else{
                iterationCompleted = false
            }
            
            // MARK: Use this only in tabata and rounds timer
            if _timerType == .Tabata {
                if _elapsedTime >= currentRoundsTimeInterval() {
                    currentArrayRoundsIndex += 1
                    roundsFinished = true
                }else{
                    roundsFinished = false
                }
                //                print("value: \(elapsedTime - totalTimerInterval)")
            }
            if _timerType == .Tabata || _timerType == .Rounds {
                if _elapsedTime - totalTimerInterval >= -0.18 {
                    timerFinished = true
                }else{
                    timerFinished = false
                }
            }
            
            //            print("elapsed time value \(elapsedTime)")
            self.timerFormat == .MinSec ? sendCallbackDelegate(elapsedTime: _elapsedTime) : sendCallbackDelegate(elapsedTime: _elapsedTime + 1)
            
        }else{
            if _prepareTime > 0 {
                let remainingPrepareTime = _elapsedTime - _prepareTime
                if remainingPrepareTime <= 0 {
                    isPrepareTime = true
                }else{
                    isPrepareTime = false
                }
                sendCallbackDelegate(elapsedTime: remainingPrepareTime)
            }else{
                sendCallbackDelegate(elapsedTime: _elapsedTime)
            }
        }
    }
    
    func currentTimeInterval() -> TimeInterval {
        var tmpIntervalsArray  = _timerIntervalsArray
        if let subRange = Range(NSRange(location: currentArrayIndex + 1, length: (_timerIntervalsArray?.count)! - currentArrayIndex - 1)){
            tmpIntervalsArray?.removeSubrange(subRange)
        }
        let currentTimerIntervals = tmpIntervalsArray?.reduce(0, { x, y in x + y }) as! TimeInterval
        return currentTimerIntervals
    }
    
    // MARK: - doar tabata
    func currentRoundsTimeInterval() -> TimeInterval {
        var roundsIntervalsArray = _valuesRoundsArray
        if let subRange = Range(NSRange(location: currentArrayRoundsIndex + 1, length: (_valuesRoundsArray?.count)! - currentArrayRoundsIndex - 1)){
            roundsIntervalsArray?.removeSubrange(subRange)
        }
        let currentTimerIntervals = roundsIntervalsArray?.reduce(0, { x, y in x + y })
        return currentTimerIntervals!
    }
    
    
    func timeFormatArray(timerInterval:TimeInterval) -> [String] {
        let totalTimeMinutes = labs(Int(totalTimerInterval + 1 - timerInterval)/60)
        var totalTimeSeconds = 0
        if totalTimeSeconds > 59 {
            totalTimeSeconds = labs(Int(totalTimerInterval + 1 - timerInterval) % 60)
        }else{
            totalTimeSeconds = labs(Int(totalTimerInterval - timerInterval) % 60)
        }
        
        let currentTimeMinutes = labs(Int(currentTimeInterval() - timerInterval)/60)
        let currentTimeSeconds = labs(Int(currentTimeInterval() - timerInterval + 1 ) % 60)
        //        print("curent time seconds \(currentTimeSeconds)")
        var miliseconds = fabs((timerInterval - timerInterval) * (self.timerFormat == TimerFormat.MilisecondsOneDigit ? 10 : 100))
        
        if _timerMode == TimerMode.CountDown && miliseconds > 0 {
            miliseconds = (self.timerFormat == .MilisecondsOneDigit ? 9 : 99) - miliseconds
        }
        
        switch self.timerFormat {
        case .MinSec?:
            totalTimeString = String(format: "%.2ld:%.2ld", totalTimeMinutes, totalTimeSeconds)
            currentTimeFormatString = String(format: "%.2ld:%.2ld", currentTimeMinutes, currentTimeSeconds)
            break
        case .MilisecondsOneDigit?:
            totalTimeString = String(format: "%.1ld:%.2ld.%.1ld", totalTimeMinutes, totalTimeSeconds, miliseconds)
            currentTimeFormatString = String(format: "%.1ld:%.2ld.%.1ld", currentTimeMinutes, currentTimeSeconds, miliseconds)
            break
        case .MilisecondsTwoDigits?:
            totalTimeString = String(format: "%.2ld:%.2ld.%.2ld", totalTimeMinutes, totalTimeSeconds, miliseconds)
            currentTimeFormatString = String(format: "%.2ld:%.2ld.%.2ld", currentTimeMinutes, currentTimeSeconds, miliseconds)
            break
        case .none:
            totalTimeString = String(format: "%.2ld:%.2ld", totalTimeMinutes, totalTimeSeconds)
            currentTimeFormatString = String(format: "%.2ld:%.2ld", currentTimeMinutes, currentTimeSeconds)
            break
        }
        return [totalTimeString!, currentTimeFormatString!]
    }
    
    
    func sendCallbackDelegate(elapsedTime:TimeInterval) {
        
        if _timerMode == .CountUp {
            let timeFormatArrays:[String] = timeFormatArray(timerInterval:elapsedTime)
            if _lapTime > 0 {
                var lapCompleted = false
                print(lastLapTimeValue)
                print("elapsed time \(elapsedTime)")
                if lastLapTimeValue + _lapTime == Int(elapsedTime) && !isPrepareTime  {
                    lastLapTimeValue = Int(elapsedTime)
                    lapCompleted = true
                }
                delegate?.timer!(timerObject: self, isPrepare: isPrepareTime, lapCompleted: lapCompleted, timeString: timeFormatArrays[kTotalTimeIndex])
                if !isPrepareTime {
                    delegate?.timer!(timerObject: self, lapTime: elapsedTime - Double(lastLapTimeValue), totalTime: TimeInterval(_lapTime), isPrepare: isPrepareTime)
                }else {
                    delegate?.timer!(timerObject: self, lapTime: elapsedTime - _prepareTime, totalTime: TimeInterval(_prepareTime), isPrepare: isPrepareTime)
                    
                }
            }else{
                delegate?.timer!(timerObject: self, isPrepare: true, lapCompleted: false, timeString: timeFormatArrays[kTotalTimeIndex])
            }
        }else{
            let timeFormatArrays:[String] = timeFormatArray(timerInterval:elapsedTime)
            //            print("time format array\(timeFormatArrays)")
            var needToPlaySound = false
            if self.timerFormat == .MinSec {
                currentTimerInterval = Int(currentTimeInterval() - elapsedTime)
            }else{
                currentTimerInterval = Int(currentTimeInterval() - elapsedTime + 1)
            }
            
            
            let condition1 = currentTimerInterval! - 2 == 0
            let condition2 = currentTimerInterval! - 1 == 0
            let condition3 = currentTimerInterval! == 0
            
            if ((condition1 || condition2 || condition3) && Int(needToPlaySoundLastValue) != currentTimerInterval && isRunning == true ) {
                needToPlaySoundLastValue = TimeInterval(currentTimerInterval!)
                needToPlaySound = true
            }
            
            if _timerType == .Tabata {
                
                delegate?.timer!(timerObject: self, totalTimeString: timeFormatArrays[kTotalTimeIndex], currentTimeString: timeFormatArrays[kCurrentTimeIndex], iterationCompleted: iterationCompleted!, needToPlaySound: needToPlaySound, timerFinished:timerFinished!, roundsFinished: roundsFinished!)
                
            }
            if _timerType == .Rounds {
                delegate?.timer!(timerObject: self, totalTimeString: timeFormatArrays[kTotalTimeIndex], currentTimeString: timeFormatArrays[kCurrentTimeIndex], iterationCompleted: iterationCompleted!, needToPlaySound: needToPlaySound, timerFinished: timerFinished!)
            }
            
            
            
            let totCurrentMinSeconds = fabs(elapsedTime - currentTimeInterval())
            let totCurrentMiliseconds = fabs(elapsedTime - 1 - currentTimeInterval())
            
            
            let currentProgressMiliseconds = fabs(Double(_timerIntervalsArray![currentArrayIndex]) - totCurrentMiliseconds)
            let currentProgressMinSec = fabs(Double(_timerIntervalsArray![currentArrayIndex]) - totCurrentMinSeconds)
            
            if timerFinished != true {
                
                if _timerType == .Tabata {
                    //                // total time rounds array
                    let totCurrentMinSecRounds = fabs(elapsedTime - currentRoundsTimeInterval())
                    currentProgressMinSecRounds = fabs(Double(_valuesRoundsArray![currentArrayRoundsIndex] - totCurrentMinSecRounds))
                }
                
                if _timerType == .Rounds {
                    //            DispatchQueue.once(token: "TimerPrepare", block: {
                    if prepareTimeValue > 0 && currentArrayIndex <= (_timerIntervalsArray?.count)! - 1 {
                        delegate?.timer!(timerObject: self, totalTime: Double(_timerIntervalsArray![currentArrayIndex]), currentTime: self.timerFormat == .MinSec ? currentProgressMinSec : currentProgressMiliseconds, currentTimeCycles: elapsedTime - Double(_timerIntervalsArray![0]), totalTimeCycles: totalTimerInterval - Double(_timerIntervalsArray![0]))
                    }else {
                        delegate?.timer!(timerObject: self, totalTime: Double(_timerIntervalsArray![currentArrayIndex]), currentTime: self.timerFormat == .MinSec ? currentProgressMinSec : currentProgressMiliseconds, currentTimeCycles: elapsedTime, totalTimeCycles: totalTimerInterval)
                    }
                }
                
                if _timerType == .Tabata {
                    if prepareTimeValue > 0 && currentArrayIndex <= (_timerIntervalsArray?.count)! - 1 {
                        
                        delegate?.timer!(timerObject: self, totalTime: Double(_timerIntervalsArray![currentArrayIndex]), currentTime: self.timerFormat == .MinSec ? currentProgressMinSec : currentProgressMiliseconds, currentTimeCycles: elapsedTime - Double(_timerIntervalsArray![0]), totalTimeCycles: totalTimerInterval - Double(_timerIntervalsArray![0]))
                        delegate?.timer!(timerObject: self, roundsCurrentTime: currentProgressMinSecRounds, roundsTotalTime: _valuesRoundsArray![currentArrayRoundsIndex])
                        
                    }
                    else {
                        delegate?.timer!(timerObject: self, totalTime: Double(_timerIntervalsArray![currentArrayIndex]), currentTime: self.timerFormat == .MinSec ? currentProgressMinSec : currentProgressMiliseconds, currentTimeCycles: elapsedTime, totalTimeCycles: totalTimerInterval)
                        delegate?.timer!(timerObject: self, roundsCurrentTime: currentProgressMinSecRounds, roundsTotalTime: _valuesRoundsArray![currentArrayRoundsIndex])
                        
                    }
                }
            }
        }
    }
}

func + (lhs: NSNumber, rhs: NSNumber) -> NSNumber {
    return NSNumber(value: lhs.floatValue + rhs.floatValue)
    
}

