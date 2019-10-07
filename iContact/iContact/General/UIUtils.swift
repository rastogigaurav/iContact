import Foundation
import UIKit

class UIUtils {
    static func showCustomAlert(with title: String,
                                messge: String,
                                viewControllertoPresent: UIViewController) {
        
        let stylePref = UIAlertController.Style.alert
        let alert = UIAlertController(title: title, message: messge, preferredStyle: stylePref)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(okAction)
        viewControllertoPresent.present(alert, animated: true, completion: nil)
    }
}
