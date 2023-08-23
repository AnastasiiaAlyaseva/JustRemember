import SwiftUI

struct SupportEmail {
    let toAddress: String
    let subject: String
    let message: String
    var body: String {"""

    \(message)

    App Name: \(AppInfoProvider.appName())
    IOS: \(AppInfoProvider.systemVersion)
    Device Model: \(AppInfoProvider.deviceMode)
    App Version: \(AppInfoProvider.appVersion()).\(AppInfoProvider.appBuild())

    ________________________________________

"""
    }
    
    func sendEmail(openURL: OpenURLAction) {
        let subject = subject.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        let body = body.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        let urlString = "mailto:\(toAddress)?subject=\(subject)&body=\(body)"
        guard let url = URL(string: urlString) else { return }
        
        //todo: check if all good, if not - show to user This device does not support email
        openURL(url) { accepted in
            if !accepted {
                print("""
                This device does not support email
                \(body)
                """
                )
            }
        }
    }
}
