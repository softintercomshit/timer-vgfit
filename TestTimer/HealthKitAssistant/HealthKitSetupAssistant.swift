import Foundation
import HealthKit


class HealthKitSetupAssistant: NSObject {
    
    private enum HealthKitSetupError: Error {
        case notAvailableOnDevice
        case dataTypeNotAvailable
    }
    
    public func authorizeHealthKit(completion: @escaping (Bool, Error?) -> Swift.Void) {
        
        guard HKHealthStore.isHealthDataAvailable() else {
            completion(false, HealthKitSetupError.notAvailableOnDevice)
            return
        }
        
        let healthKitTypesToWrite: Set<HKSampleType> = [HKObjectType.workoutType()]
        
        HKHealthStore().requestAuthorization(toShare: healthKitTypesToWrite, read: nil) { (success, error) in
            completion(success, error)
        }
    }
    
    public func authorizationHealthKit() {
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
    }
    
    public var isAuthorized: Bool {
        get {
            return HKHealthStore().authorizationStatus(for: HKObjectType.workoutType()) == HKAuthorizationStatus.sharingAuthorized ? true : false
        }
    }
}
