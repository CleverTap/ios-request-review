

import UIKit
import StoreKit

class ViewController: UIViewController {
    
    private let appVersionKey = "lastAppVersionReviewRequest"
    private let reviewRequestedKey = "ReviewRequested"
    private let buttonClickKey = "ButtonClicked"
    
    private let clevertap: CleverTap = {
        CleverTap.enablePersonalization()
        return CleverTap.autoIntegrate()
    }()
    
    private lazy var appVersion: String = {
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            return version;
        } else {
            return "unknown";
        }
    }()

    @IBAction func buttonDidClick(_ sender: Any) {
        handleButtonClick()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // uncomment to remove here to be able to re-test on subsequent app launches
        clevertap.profileRemoveValue(forKey: appVersionKey)
    }

    /** Calls the SKStoreReviewController.requestReview API
     *  if it has not been already been called for this user for the current app version
     *  last app version reviewed is stored as a CleverTap user profile
     */
    private func requestReviewIfAppropriate() {
        if #available(iOS 10.3, *) {
            let lastReviewedVersion = clevertap.profileGet(appVersionKey) as! String?
            if (lastReviewedVersion != nil && (appVersion == lastReviewedVersion!)) {
                print("already requested a review for appVersion \(appVersion)")
                return
            }
            SKStoreReviewController.requestReview();
            clevertap.recordEvent(reviewRequestedKey, withProps: ["appVersion": appVersion])
            clevertap.profilePush([appVersionKey:appVersion])
        } else {
            print("SKStoreReviewController not available")
        }
    }
    
    /** Attempts a review request call if the button has been clicked at least 5 times,
     *  as a simple-minded demo proxy for user engagement.
     *  Button clicks are tracked in CleverTap
     */
    private func handleButtonClick() {
        if let buttonClickEventDetail = clevertap.eventGetDetail(buttonClickKey) {
            let numClicks = buttonClickEventDetail.count + 1
            if numClicks >= 5 {
                print("num button clicks is \(numClicks) calling requestReviewIfAppropriate")
                requestReviewIfAppropriate()
            }
        }
        clevertap.recordEvent(buttonClickKey)
    }
}

