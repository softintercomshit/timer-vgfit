import Foundation
import WatchConnectivity

@available(iOS 9.0, *)
class ConnectivityHandler: NSObject, WCSessionDelegate {
    
    var session = WCSession.default()
    
    override init() {
        super.init()
        
        session.delegate = self
        session.activate()
        
        NSLog("%@", "Paired Watch: \(session.isPaired), Watch App Installed: \(session.isWatchAppInstalled)")
    }
    
    // MARK: - WCSessionDelegate
    
    @available(iOS 9.3, *)
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        NSLog("%@", "activationDidCompleteWith activationState:\(activationState) error:\(String(describing: error))")
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        NSLog("%@", "sessionDidBecomeInactive: \(session)")
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        NSLog("%@", "sessionDidDeactivate: \(session)")
    }
    
    func sessionWatchStateDidChange(_ session: WCSession) {
        NSLog("%@", "sessionWatchStateDidChange: \(session)")
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void) {
        NSLog("didReceiveMessage: %@", message)
        
//        let timeStampFromWatchOS = message[kLastCoreDataChangeKey] as! Double
       
        
//        let timeStampRoundsFromiOS = UserDefaults.standard.double(forKey: "workoutTimeStampRounds")
//        let timeStampStopwatchFromiOS = UserDefaults.standard.double(forKey: "workoutTimeStampStopwatch")
        
//        if (timeStampFromWatchOS != timeStampTabataFromiOS || timeStampFromWatchOS != timeStampRoundsFromiOS || timeStampFromWatchOS != timeStampStopwatchFromiOS || timeStampFromWatchOS == 0)  {
//            replyHandler(["tabataWorkouts" : AppleWatchClassesHandlers.getTabataWorkoutInfo((DatabaseManager.sharedInstance() as AnyObject).getTabataWorkouts()),
//                          "roundsWorkouts" : AppleWatchClassesHandlers.getRoundsWorkoutInfo((DatabaseManager.sharedInstance() as AnyObject).getRoundsWorkouts()),
//                          "stopwatchWorkouts" : AppleWatchClassesHandlers.getStopwatchWorkoutInfo((DatabaseManager.sharedInstance() as AnyObject).getStopwatchWorkouts())
//                ])
//        }
        if ((message["tabataWorkouts"]) != nil) {
//            let timeStampFromWatchOS = message["workoutTimeStamp"] as! Double
//            let timeStampTabataFromiOS = UserDefaults.standard.double(forKey: "workoutTimeStamp")
//            print("iOS: \(timeStampTabataFromiOS)")
//            print("watchOS: \(timeStampFromWatchOS)")
            
//            if (timeStampFromWatchOS != timeStampTabataFromiOS || timeStampFromWatchOS == 0) {
//                let lastCoreDataChange = NSNumber.init(value: UserDefaults.standard.double(forKey: "workoutTimeStamp"))
//                replyHandler(["workoutTimeStamp": lastCoreDataChange])
                replyHandler(["tabataWorkouts" : AppleWatchClassesHandlers.getTabataWorkoutInfo((DatabaseManager.sharedInstance() as AnyObject).getTabataWorkouts())])
//            }
           
        }else if((message["roundsWorkouts"]) != nil) {
            replyHandler(["roundsWorkouts" : AppleWatchClassesHandlers.getRoundsWorkoutInfo((DatabaseManager.sharedInstance() as AnyObject).getRoundsWorkouts())])
        }else if((message["stopwatchWorkouts"]) != nil) {
            replyHandler(["stopwatchWorkouts" : AppleWatchClassesHandlers.getStopwatchWorkoutInfo((DatabaseManager.sharedInstance() as AnyObject).getStopwatchWorkouts())])
        }
        
    }
}

