import WatchKit
import Foundation
import WatchConnectivity

class TabataController: WKInterfaceController, WCSessionDelegate {
    
    static let headerType = "HeaderTabataRow"
    static let rowType = "TabataRow"
    
    @IBOutlet private var tabataTable: WKInterfaceTable!
    
    struct TabataStruct {
        let prepare: NSNumber
        let work: NSNumber
        let rest: NSNumber
        let rounds: NSNumber
        let cycles: NSNumber
        let restBC: NSNumber
    }

    var tabataArray = [TabataStruct]()
    var tabataTitleArray = [String]()
    var array = [String]()
    private struct TimerStruct {
        let title: String
        let controllerName: String
        var data: [[NSNumber]]
        
        init(title: String, controllerName: String) {
            self.title = title
            self.controllerName = controllerName
            self.data = [[NSNumber]]()
        }
    }
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        requestData()
    }
    
    func requestData() {
        
        
            if (WCSession.isSupported()) {
                let session = WCSession.default()
                session.sendMessage(["tabataWorkouts": true], replyHandler: { reply in
                    print("reply : \(reply)")
                    if let receivedDictionaries = reply["tabataWorkouts"] as? [String:Any] {
                        if let receivedArray = receivedDictionaries["content"] {
                            if (receivedArray as! [[NSNumber]]).isEmpty {
                                let tabataStruct = TabataStruct(prepare: 5, work: 10, rest: 5, rounds: 3, cycles: 4, restBC: 4)
                                self.tabataArray.append(tabataStruct)
                                self.notifyUser(title: " ", message: "If you want to add more workouts create custom workouts on iOS", timeToDissapear: 2)
                                
                            }else{
                                for item in receivedArray as! [[NSNumber]] {
                                    let tabataStruct = TabataStruct(prepare: item[0], work: item[1], rest: item[2], rounds: item[3], cycles: item[4], restBC: item[5])
                                    self.tabataArray.append(tabataStruct)
                                }
                            }
                        }
                        if let receivedTitleArray = receivedDictionaries["titles"] {
                            if (receivedTitleArray as! [String]).isEmpty {
                                self.tabataTitleArray.append("Tabata Workout")
                                for index in 0..<2 {
                                    if index % 2 == 0 {
                                        self.array.append(TabataController.headerType)
                                    }else{
                                        self.array.append(TabataController.rowType)
                                    }
                                }
                            }else{
                                for title in receivedTitleArray as! [String] {
                                    self.tabataTitleArray.append(title)
                                }
                                for index in 0..<(receivedTitleArray as! NSArray).count * receivedDictionaries.count {
                                    if index % 2 == 0 {
                                        self.array.append(TabataController.headerType)
                                    }else{
                                        self.array.append(TabataController.rowType)
                                    }
                                }
                            }
                        }
                    }
                    DispatchQueue.main.async {
                        self.configureTable(items: self.tabataArray, titleItems: self.tabataTitleArray)
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
    
    private func configureTable(items: [TabataStruct], titleItems:[String]) {
        tabataTable.setRowTypes(array)
        
        let arrays = self.array as NSArray
        print(arrays)
        arrays.enumerateObjects ({ (object, index, stop) in
            if object as! String == TabataController.headerType {
                let header = tabataTable.rowController(at: index) as! HeaderTabataRow
                header.workoutTitleLabel.setText(titleItems[index/2])
            }else{
                let tabataRow = tabataTable.rowController(at: index) as! TabataRow
                let item = items[index / 2]
                tabataRow.prepareValue.setText(item.prepare.formatedTime)
                tabataRow.workValue.setText(item.work.formatedTime)
                tabataRow.restValue.setText(item.rest.formatedTime)
                tabataRow.roundsValue.setText(String(describing: item.rounds.intValue))
                tabataRow.cyclesValue.setText(String(describing: item.cycles.intValue))
                tabataRow.restBCValue.setText(item.restBC.formatedTime)
            }
        })
    }
    
    func notifyUser(title: String, message: String, timeToDissapear: Int) {
        DispatchQueue.once(token: "Once", block: {
            let action = WKAlertAction(title: "OK", style: .destructive) {}
            self.presentAlert(withTitle: title, message: message, preferredStyle: .actionSheet, actions: [action])
        })
    }
    
    
    override func table(_ table: WKInterfaceTable, didSelectRowAt rowIndex: Int) {
        if self.array[rowIndex] == TabataController.headerType {
            return
        }
        let selectedTimer = self.tabataArray[rowIndex/2]
        print("selectedTimer == \(selectedTimer)")
        var tabataNumbers:[NSNumber] = []
        tabataNumbers += ([selectedTimer.prepare, selectedTimer.work, selectedTimer.rest, selectedTimer.rounds, selectedTimer.cycles, selectedTimer.restBC])
        pushController(withName: "TabataTimerController", context: tabataNumbers)
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

