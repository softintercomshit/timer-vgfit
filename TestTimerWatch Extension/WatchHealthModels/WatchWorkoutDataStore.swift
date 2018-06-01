import Foundation
import HealthKit

class WatchWorkoutDataStore {
    
    class func save(tabataWorkout: TabataWorkout,
                    duration: TimeInterval,
                    completion: @escaping ((Bool, Error?) -> Swift.Void)) {

        
        // Build the workout using data from your tabata workout
        let workout = HKWorkout(activityType: .other,
                                start: tabataWorkout.start,
                                end: tabataWorkout.end,
                                duration: duration,
                                totalEnergyBurned: nil ,
                                totalDistance: nil,
                                device: HKDevice.local(),
                                metadata: nil)
        
        // Save your workout to HealthKit
        let healthStore = HKHealthStore()
        let healthAssistant = HealthKitSetupAssistant()
        if healthAssistant.isAuthorized {
            healthStore.save(workout) { (success, error) in
                completion(success, error)
            }
        }
    }
    
    
}
