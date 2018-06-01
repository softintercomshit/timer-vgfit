import WatchKit
import Foundation
import WatchKit
import WatchConnectivity
import HealthKit

class MainController: WKInterfaceController, WCSessionDelegate {
    
    @IBOutlet private var timersTable: WKInterfaceTable!
    @IBOutlet var headerTable: WKInterfaceTable!
    
    let controllerNames = ["TabataController", "RoundsController", "StopWatchController"]
    let namesArray = ["Tabata", "Rounds", "StopWatch"]
    let imagesArray = ["icTabata", "icRounds", "icStopwatch"]
    private var session: WCSession!

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        configureTable(items: namesArray, images: imagesArray)
        configureHeader(image: "icAppleHealthKit")
    }
    
    override func willActivate() {
        super.willActivate()
        session = WCSession.default()
        session?.delegate = self
        session?.activate()
    }
    
    override func didDeactivate() {
        super.didDeactivate()
    }
    
    private func configureTable(items: [String], images: [String]) {
        
        timersTable.setNumberOfRows(items.count, withRowType: "TimerRow")
        timersTable.setNumberOfRows(images.count, withRowType: "TimerRow")
        
        for (idx, item) in items.enumerated() {
            let timerRow = timersTable.rowController(at: idx) as! TimerRow
            timerRow.titleLabel.setText(item)
        }
        for (idx, item) in images.enumerated() {
            let timerRow = timersTable.rowController(at: idx) as! TimerRow
            timerRow.image.setImageNamed(item)
        }
    }
    
    private func configureHeader(image: String) {
        headerTable.setNumberOfRows(1, withRowType: "HeaderTimerRow")
        let timerRow = headerTable.rowController(at: 0) as! HeaderTimerRow
        timerRow.image.setImageNamed(image)
    }
    
    override func table(_ table: WKInterfaceTable, didSelectRowAt rowIndex: Int) {
        pushController(withName: controllerNames[rowIndex], context: rowIndex)
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        print("\(message)")
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        NSLog("%@", "activationDidCompleteWith activationState:\(activationState) error:\(String(describing: error))")
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void) {
        //        if let tabataArray = message["tabataWorkouts"] as? [[NSNumber]] {
        //            timerTypes[TimerType.tabata.rawValue].data = tabataArray
        //        }
        //        if let roundsArray = message["roundsWorkouts"] as? [[NSNumber]] {
        //            timerTypes[TimerType.rounds.rawValue].data = roundsArray
        //        }
        //        if let stopwatchArray = message["stopwatchWorkouts"] as? [[NSNumber]] {
        //            timerTypes[TimerType.stopWatch.rawValue].data = stopwatchArray
        //        }
    }
}
