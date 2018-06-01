import WatchKit
import HealthKit

class HealthKitBackgroundManager: NSObject {
    
    static let shared  = HealthKitBackgroundManager()
    let healthStore = HKHealthStore()
    var session: HKWorkoutSession?
    
    private override init() {
        super.init()
        
        let configuration = HKWorkoutConfiguration()
        configuration.activityType = .coreTraining
        configuration.locationType = .unknown
        
        do {
            session = try HKWorkoutSession(configuration: configuration)
            if let session = session {
                session.delegate = self
            }
        }
        catch let error as NSError {
            // Perform proper error handling here...
            fatalError("*** Unable to create the workout session: \(error.localizedDescription) ***")
        }
    }
    
    func activateBackgroundMode() {
        if let session = session {
            healthStore.start(session)
        }
    }
    
    func pauseBackgroundMode() {
        if let session = session {
            healthStore.pause(session)
        }
    }
    
    func endBackgroundMode() {
        if let session = session {
            healthStore.end(session)
        }
    }
}

extension HealthKitBackgroundManager: HKWorkoutSessionDelegate {
    func workoutSession(_ workoutSession: HKWorkoutSession, didChangeTo toState: HKWorkoutSessionState, from fromState: HKWorkoutSessionState, date: Date) {
    }
    
    func workoutSession(_ workoutSession: HKWorkoutSession, didFailWithError error: Error) {
        print("Workout session: \(error)")
    }
}
