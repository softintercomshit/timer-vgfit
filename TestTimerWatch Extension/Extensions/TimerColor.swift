import Foundation
import UIKit

extension UIColor {
    
    public class func colorStopwatch(stopwatchCircleType: Int) -> UIColor {
        let color: UIColor
        switch stopwatchCircleType {
        case 0:
            color = UIColor(red: 255/255, green: 230/255, blue: 32/255, alpha: 1)
            break
        case 1:
            color = UIColor(red: 4/255, green: 222/255, blue: 113/255, alpha: 1)
            break
        default:
            color = UIColor(red: 255/255, green: 230/255, blue: 32/255, alpha: 1)
            break
        }
        return color
    }
    
    struct CircleColor {
        static var roundsColor: UIColor  { return UIColor(red: 32/255, green: 148/255, blue: 250/255, alpha: 1) }
        static var cyclesColor: UIColor { return UIColor(red: 0/255, green: 245/255, blue: 234/255, alpha: 1) }
    }
}
