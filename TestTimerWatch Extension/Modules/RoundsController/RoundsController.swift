import WatchKit
import Foundation
import WatchConnectivity

class RoundsController: WKInterfaceController, WCSessionDelegate {
    
    static let headerRoundsRow = "HeaderRoundsRow"
    static let roundsRow = "RoundsRow"
    
    
    @IBOutlet private var roundsTable: WKInterfaceTable!
    
    struct RoundStruct {
        let prepare: NSNumber
        let work: NSNumber
        let rest: NSNumber
        let rounds: NSNumber
    }
    
    var roundsArray = [RoundStruct]()
    var roundsTitlesArray = [String]()
    var arrayCellsStructure = [String]()
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        requestData()
    }
    
    func requestData() {
        if (WCSession.isSupported()) {
            let session = WCSession.default()
            session.sendMessage(["roundsWorkouts": true], replyHandler: { reply in
                  print("reply : \(reply)")
                if let receivedRoundsDictionary = reply["roundsWorkouts"] as? [String: Any] {
                    if let receivedRoundsContentArray = receivedRoundsDictionary["roundsContent"] {
                        if (receivedRoundsContentArray as! [[NSNumber]]).isEmpty {
                        let roundsStruct = RoundStruct(prepare:5, work: 10, rest: 5, rounds: 4)
                        self.roundsArray.append(roundsStruct)
                        self.notifyUser(title: " ", message: "If you want to add more workouts create custom workouts on iOS", timeToDissapear: 2)
                    }else {
                        for item in receivedRoundsContentArray as! [[NSNumber]] {
                            let roundsStruct = RoundStruct(prepare: item[0], work: item[1], rest: item[2], rounds: item[3])
                            self.roundsArray.append(roundsStruct)
                        }
                    }
                }
                if let receivedRoundsTitlesArray = receivedRoundsDictionary["roundsTitles"] {
                    
                    if (receivedRoundsTitlesArray as! [String]).isEmpty {
                         self.roundsTitlesArray.append("Rounds Workout")
                        for index in 0..<2 {
                            if index % 2 == 0 {
                                self.arrayCellsStructure.append(RoundsController.headerRoundsRow)
                            }else{
                                self.arrayCellsStructure.append(RoundsController.roundsRow)
                            }
                        }
                    }else {
                        for item in receivedRoundsTitlesArray as! [String] {
                            self.roundsTitlesArray.append(item)
                        }
                        
                        for index in 0..<(receivedRoundsTitlesArray as! NSArray).count * receivedRoundsDictionary.count {
                            if index % 2 == 0 {
                                self.arrayCellsStructure.append(RoundsController.headerRoundsRow)
                            }else{
                                self.arrayCellsStructure.append(RoundsController.roundsRow)
                            }
                        }
                    }
                    }
                    DispatchQueue.main.async {
                        self.configureTable(items: self.roundsArray, titleItems: self.roundsTitlesArray)
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
    
    private func configureTable(items: [RoundStruct], titleItems: [String]) {
        
        roundsTable.setRowTypes(self.arrayCellsStructure)
        let arrays = self.arrayCellsStructure as NSArray
        
        arrays.enumerateObjects ({ (object, index, stop) in
            if object as! String == RoundsController.headerRoundsRow {
                let headerRow = roundsTable.rowController(at: index) as! HeaderRoundsRow
                headerRow.roundsWorkoutTitleLabel.setText(titleItems[index/2])
            }else{
                let roundsRow = roundsTable.rowController(at: index) as! RoundsRow
                let item = items[index/2]
                roundsRow.roundsPrepareValue.setText(item.prepare.formatedTime)
                roundsRow.roundsWorkValue.setText(item.work.formatedTime)
                roundsRow.roundsRestValue.setText(item.rest.formatedTime)
                roundsRow.roundsValue.setText(String(describing: item.rounds.intValue))
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
        
        if self.arrayCellsStructure[rowIndex] == RoundsController.headerRoundsRow {
            return
        }
        let selectedTimer = roundsArray[rowIndex/2]
        var roundsNumbers:[NSNumber] = []
        roundsNumbers += ([selectedTimer.prepare,selectedTimer.work, selectedTimer.rest,selectedTimer.rounds])
        pushController(withName: "RoundsTimerController", context: roundsNumbers)
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
