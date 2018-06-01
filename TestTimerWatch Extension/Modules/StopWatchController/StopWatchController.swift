import WatchKit
import Foundation
import WatchConnectivity

class StopWatchController: WKInterfaceController, WCSessionDelegate {
    
    static let stopwatchHeaderRow = "HeaderStopwatchRow"
    static let stopwatchRow = "StopWatchRow"
    
    @IBOutlet private var stopWatchTable: WKInterfaceTable!
    
    struct StopWatchStruct {
        let prepare: NSNumber
        let timeLap: NSNumber
    }
    
    var stopWatchArray = [StopWatchStruct]()
    var stopwatchTitlesArray = [String]()
    var arrayCellStructure = [String]()
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        requestData()
    }
    
    func requestData() {
        if (WCSession.isSupported()) {
            let session = WCSession.default()
            session.sendMessage(["stopwatchWorkouts": true], replyHandler: { reply in
                  print("reply : \(reply)")
                if let receivedStopwatchDictionary = reply["stopwatchWorkouts"] as? [String:Any] {
                    print(receivedStopwatchDictionary)
                    if let receivedStopwatchContentArrays = receivedStopwatchDictionary["stopwatchContent"] {
                        
                        if (receivedStopwatchContentArrays as! [[NSNumber]]).isEmpty {
                            
                            let stopWatchStruct = StopWatchStruct(prepare: 5, timeLap: 5)
                            self.stopWatchArray.append(stopWatchStruct)
                            self.notifyUser(title: " ", message: "If you want to add more workouts create custom workouts on iOS", timeToDissapear: 2)
                            
                        }else {
                            for item in receivedStopwatchContentArrays as! [[NSNumber]] {
                                let stopWatchStruct = StopWatchStruct(prepare: item[0], timeLap: item[1])
                                self.stopWatchArray.append(stopWatchStruct)
                            }
                        }
                    }
                    if let receivedStopwatchTitlesArray = receivedStopwatchDictionary["stopwatchTitles"] {
                        
                        if (receivedStopwatchTitlesArray as! [String]).isEmpty {
                            self.stopwatchTitlesArray.append("Stopwatch Workout")
                            for index in 0..<2 {
                                if index % 2 == 0 {
                                    self.arrayCellStructure.append(StopWatchController.stopwatchHeaderRow)
                                }else{
                                    self.arrayCellStructure.append(StopWatchController.stopwatchRow)
                                }
                            }
                        }else {
                            for item in receivedStopwatchTitlesArray as! [String] {
                                self.stopwatchTitlesArray.append(item)
                            }
                            
                            for index in 0..<(receivedStopwatchTitlesArray as! NSArray).count * receivedStopwatchDictionary.count {
                                if index % 2 == 0 {
                                    self.arrayCellStructure.append(StopWatchController.stopwatchHeaderRow)
                                }else{
                                    self.arrayCellStructure.append(StopWatchController.stopwatchRow)
                                }
                            }
                        }
                    }
                    DispatchQueue.main.async {
                         self.configureTable(items: self.stopWatchArray, titleItems: self.stopwatchTitlesArray)
                    }
                }
            }, errorHandler:{ error in
                print("error: \(error)")
            })
        }
    }
    
    override func willActivate() {
        super.willActivate()
    }
    
    override func didDeactivate() {
        super.didDeactivate()
    }
    
    private func configureTable(items: [StopWatchStruct], titleItems: [String]) {
        
        stopWatchTable.setRowTypes(self.arrayCellStructure)
        let arraysStructure = self.arrayCellStructure as NSArray
        arraysStructure.enumerateObjects ({ (object, index, stop) in
            if object as! String == StopWatchController.stopwatchHeaderRow {
                let headerRow = stopWatchTable.rowController(at: index) as! HeaderStopwatchRow
                headerRow.stopwatchWorkoutTitleLabel.setText(titleItems[index/2])
            }else{
                let stopwatchRow = stopWatchTable.rowController(at: index) as! StopWatchRow
                let item = items[index/2]
                stopwatchRow.prepareValue.setText(item.prepare.formatedTime)
                stopwatchRow.timeLapValue.setText(item.timeLap.formatedTime)
            }
        })
    }
    
    func notifyUser(title: String, message: String, timeToDissapear: Int) {
        DispatchQueue.once(token: "Once", block: {
            let action = WKAlertAction(title: "OK", style: .destructive) {}
            presentAlert(withTitle: title, message: message, preferredStyle: .actionSheet, actions: [action])
        })
    }
    
    override func table(_ table: WKInterfaceTable, didSelectRowAt rowIndex: Int) {
        if self.arrayCellStructure[rowIndex] == StopWatchController.stopwatchHeaderRow {
            return
        }
        let selectedTimer = stopWatchArray[rowIndex/2]
        var stopwatchNumbers:[NSNumber] = []
        stopwatchNumbers += ([selectedTimer.prepare, selectedTimer.timeLap])
        pushController(withName: "StopwatchTimerController", context: stopwatchNumbers)
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        print("\(message)")
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        NSLog("%@", "activationDidCompleteWith activationState:\(activationState) error:\(String(describing: error))")
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void) {
        
    }
}
