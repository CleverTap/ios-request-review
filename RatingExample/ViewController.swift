

import UIKit
import StoreKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        requestRating()
    }

    private func requestRating() {
        if #available(iOS 10.3, *) {
            SKStoreReviewController.requestReview();
        } else {
            print("SKStoreReviewController not available")
        }
    }


}

