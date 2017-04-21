## Requesting user app ratings/reviews with SKStoreReviewController

Starting with iOS 10.3, Apple has made significant changes to its app rating and review functionality. [See the Apple documentation for more detail](https://developer.apple.com/app-store/ratings-and-reviews/).

Using the [SKStoreReviewController API](https://developer.apple.com/reference/storekit/skstorereviewcontroller/2851536-requestreview), you can prompt users to leave an App Store rating/review without leaving your app.  Users will be shown a standardized prompt, and can authenticate with Touch ID to write and submit a review. 

Some caveats:
- You should only call the API when it makes sense in the user experience flow of your app, and then only after the user has demonstrated engagement.
- You have no control over exactly when and if the user sees the rating request dialog, that is determined entirely by the system.
- Because the system may or may not show a ratings prompt, it's not appropriate to call the API in response to a button tap or other user action. 
- No matter how many times you call the API, the system will only show up to a maximum of three prompts to the same user in a 365-day period.
- The App Store defaults to showing ratings and reviews only for your app's most recent version.


With these caveats in mind, its important to chose and track a meaningful engagement metric to trigger your API call.  

Moreover, because the App Store defaults to showing only ratings and reviews for your latest app version, you should consider limiting ratings requests to a once-per-user-per-app-version cycle (or perhaps somehow rationing rating requests across different sets of users if you find yourself updating your app more than 3 times per year).  

The [example project](https://github.com/CleverTap/ios-request-review/blob/master/Example/RatingExample/ViewController.swift) included in this repository implements the SKStoreReviewController.requestReview API, along with a simple demo engagement tracking trigger and an app version request limit. 
