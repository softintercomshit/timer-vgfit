import Foundation

enum WatchWorkoutSessionState {
    case notStarted
    case active
    case finished
}


class WatchWorkoutSession {
    
    private (set) var startDate: Date!
    private (set) var endDate: Date!
    
    var state: WatchWorkoutSessionState = .notStarted
    
    func start() {
        startDate = Date()
        state = .active
    }
    
    func end() {
        endDate = Date()
        state = .finished
    }
    
    func clear() {
        startDate = nil
        endDate = nil
        state = .notStarted
    }
    
    var completeWorkout: TabataWorkout? {
        
        get {
            
            guard state == .finished,
                let startDate = startDate,
                let endDate = endDate else {
                    return nil
            }
            
            return TabataWorkout(start: startDate,
                                      end: endDate)
            
        }
    }
}
