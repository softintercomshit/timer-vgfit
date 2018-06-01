import Foundation

enum CircleType: Int {
    case tabata, rounds, cycles
    
    var simpleDescription: String {
        switch self {
        case .tabata:
            return "Tabata"
        case .rounds:
            return "Rounds"
        case .cycles:
            return "Cycles"
        }
    }
}

enum RoundCircleType: Int {
    case roundsCircle, roundsCount
    
    var simpleDescription: String {
        switch self {
        case .roundsCircle:
            return "Rounds"
        case .roundsCount:
            return "Rounds"
        }
    }
}


