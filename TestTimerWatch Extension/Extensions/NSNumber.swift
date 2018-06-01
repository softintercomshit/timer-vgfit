import Foundation

extension NSNumber {
    private func secondsToHoursMinutesSeconds() -> (hours: Int, minutes: Int, seconds: Int) {
        return (self.intValue / 3600, (self.intValue % 3600) / 60, (self.intValue % 3600) % 60)
    }
    private func totalTimeMinutesSeconds() -> (minutes: Int, seconds: Int) {
        return (self.intValue / 60, self.intValue % 60)
    }
    
    private func formatedString(value: Int) -> String {
        return String(format: "%.2ld", value)
    }
    
    private func formattedString(valueMinutes: Int, valueSeconds: Int) -> String {
        var stringFormat: String = ""
        switch TimerObject().timerFormat?.rawValue {
        case TimerObject.TimerFormat.MinSec.rawValue?:
            stringFormat = String(format: "%.2ld:%.2ld",valueMinutes, valueSeconds)
            break
        case TimerObject.TimerFormat.MilisecondsOneDigit.rawValue?:
            stringFormat = String(format: "%.ld:%.2ld.0",valueMinutes, valueSeconds)
            break
        case TimerObject.TimerFormat.MilisecondsTwoDigits.rawValue?:
            stringFormat = String(format: "%.2ld:%.2ld.00",valueMinutes, valueSeconds)
            break
        default:
            stringFormat = String(format: "%.2ld:%.2ld",valueMinutes, valueSeconds)
            break
        }
        return stringFormat
    }
    
    var formatedTime: String {
        let (hours, minutes, seconds) = secondsToHoursMinutesSeconds()
        
        if hours > 0 {
            return "\(formatedString(value: hours)):\(formatedString(value: minutes)):\(formatedString(value: seconds))"
        }
        
        return "\(formatedString(value: minutes)):\(formatedString(value: seconds))"
    }
    
    var timeFormatString: String {
        let (minutes, seconds) = totalTimeMinutesSeconds()
        return "\(formattedString(valueMinutes: minutes, valueSeconds: seconds))"
    }
    
    
}
