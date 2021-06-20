import Foundation
import UIKit

class LanguageSmartManager {
    
//    var shared : LanguageSmartManager?
    
    public init(){
//        self.shared = LanguageSmartManager()
    }
    
    enum LanguageType: String {
        case en
        case ar

        var langaugTitle: String {
            switch self {
            case .en:
                return "English"
            case .ar:
                return "عربى"
            }
        }
    }

    static var language: LanguageType {
        get {
            return self.LanguageType(rawValue: UserDefaults.standard.string(forKey: "LanguageType") ?? "en") ?? .en
        }
        set {
            UserDefaults.standard.setValue(newValue.rawValue, forKey: "LanguageType")
            changeLanguage(language: newValue)
        }
    }

    static var isRTL: Bool {
        return language == .ar
    }

    static private func changeLanguage(language: LanguageType){
        //        switch language {
        //        case .ar:
        UIView.appearance().semanticContentAttribute = (language == .ar) ? .forceRightToLeft : .forceLeftToRight
        UserDefaults.standard.set(language.rawValue, forKey: "i18n_language")
        UserDefaults.standard.set([language.rawValue], forKey: "AppleLanguages")
        UserDefaults.standard.set(language.rawValue, forKey: "selectedLanguage")
        UserDefaults.standard.set(language.rawValue, forKey: "AppleLanguage")
        UserDefaults.standard.set(isRTL, forKey: "AppleTextDirection")
        UserDefaults.standard.set(isRTL, forKey: "NSForceRightToLeftWritingDirection")
        L012Localizer.DoTheSwizzling()
//        let targetLang = UserDefaults.standard.object(forKey: "selectedLanguage") as? String
//        Bundle.setLanguage((targetLang != nil) ? targetLang! : "en")
//        UserDefaults.standard.synchronize()
//        changeSemantic()
        
        //        case .en:
        //            UIView.appearance().semanticContentAttribute = .forceLeftToRight
        //            UserDefaults.standard.set("en", forKey: "i18n_language")
        //            UserDefaults.standard.set(["en"], forKey: "AppleLanguages")
        //            UserDefaults.standard.set(false, forKey: "AppleTextDirection")
        //            UserDefaults.standard.set(false, forKey: "NSForceRightToLeftWritingDirection")
        //            UserDefaults.standard.synchronize()
        //        }
    }
    
    static private func changeSemantic(){
        
//        let windows = UIApplication.shared.windows
//        for window in windows {
//            if let childVCs = (window.rootViewController?.children){
//                window.rootViewController?.viewWillAppear(true)
//                UIApplication.topViewController()?.viewWillAppear(true)
//                for child in childVCs{
////                    if let child_vc = child as? BaseViewController {
//                        DispatchQueue.main.async {
//                            child.viewWillAppear(true)
//                        }
//                    }
//                }
//
//            }
//            for view in window.subviews {
////                view.awakeFromNib()
//                view.removeFromSuperview()
//                window.addSubview(view)
//            }
//        }
//
//        let rootviewcontroller: UIWindow = ((UIApplication.shared.delegate?.window)!)!
//////
//////
////        rootviewcontroller.rootViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "mianNav")
//        let mainwindow = (UIApplication.shared.delegate?.window!)!
//        mainwindow.backgroundColor = UIColor(hue: 0.6477, saturation: 0.6314, brightness: 0.6077, alpha: 0.8)
//        UIView.transition(with: mainwindow, duration: 0.55001, options: .transitionFlipFromLeft, animations: { () -> Void in
//        }) { (finished) -> Void in
//        }
//        if let vc = UIApplication.topViewController() as? BaseViewController{
//            vc.viewWillAppear(true)
//        }

            
        }

    static func localizedString(key: String, comment: String? = nil) -> String {
        var translation = self.getTranslationValue(forKey: key)

        if translation == nil {
            translation = NSLocalizedString(key, comment: comment ?? "")
        }
        //return translation ?? ""
         if translation ?? "" == key {
             return comment ?? ""
         } else {
             return translation ?? ""
         }
    }

}

class L012Localizer: NSObject {
    class func DoTheSwizzling() {
        MethodSwizzleGivenClassName(cls: Bundle.self, originalSelector: #selector(Bundle.localizedString(forKey:value:table:)), overrideSelector:
            #selector(Bundle.specialLocalizedString(key:value:table:)))
    }
}

extension Bundle {
    @objc func specialLocalizedString(key: String, value: String?, table tableName: String?) -> String {
        let currentLanguage = LanguageSmartManager.isRTL ? "ar" : "en"
        var bundle = Bundle();
        if let _path = Bundle.main.path(forResource: currentLanguage, ofType: "lproj") {
            bundle = Bundle(path: _path)!
        } else {
            let _path = Bundle.main.path(forResource: "Base", ofType: "lproj")!
            bundle = Bundle(path: _path)!
        }
        return (bundle.specialLocalizedString(key: key, value: value, table: tableName))
    }
}

func MethodSwizzleGivenClassName(cls: AnyClass, originalSelector: Selector, overrideSelector: Selector){

    let origMethod: Method = class_getInstanceMethod(cls, originalSelector)!;
    let overrideMethod: Method = class_getInstanceMethod(cls, overrideSelector)!;
    if (class_addMethod(cls, originalSelector, method_getImplementation(overrideMethod), method_getTypeEncoding(overrideMethod))) {
        class_replaceMethod(cls, overrideSelector, method_getImplementation(origMethod), method_getTypeEncoding(origMethod));
    } else {
        method_exchangeImplementations(origMethod, overrideMethod);
    }
}
// MARK: - HELPER METHODS
extension LanguageSmartManager {
    static func getTranslationValue(forKey key: String) -> String? {
        return nil
    }

}

let appDelegate = UIApplication.shared.delegate

extension UIApplication {
    class func topViewController(base: UIViewController? = appDelegate?.window??.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return topViewController(base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewController(base: selected)
            }
        }
        if let presented = base?.presentedViewController {
            return topViewController(base: presented)
        }
        return base
    }
}

