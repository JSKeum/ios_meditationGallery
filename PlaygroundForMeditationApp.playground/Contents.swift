import UIKit

protocol MeditationStuffs {
    var todayImage: UIImage? { get }
    var textAboutTodayImage: String? { get set }
}

// 으.. 좀더 고민해야

struct MeditationNote: MeditationStuffs {
    var todayImage: UIImage?
    var text: String
    var style: TextStyle
    
    init(text: String, todayImage: UIImage) {
        self.text = text
        self.todayImage = todayImage
        
        self.style = .normal
    }
    
    var textAboutTodayImage: String? {
        get { return text }
        set {
            text = newValue ?? ""
            style = .normal
        }
    }
    
    enum TextStyle {
        case normal
        case stained
        case highlighted
        
        func effect() -> UIColor {
            switch self {
            case .normal: return UIColor.black
            case .stained: return UIColor.red
            case .highlighted: return UIColor.blue
            }
        }
    }
    
}

//nil == 1
