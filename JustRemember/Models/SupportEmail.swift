import SwiftUI

struct SupportEmail {
    let toAddress: String
    let subject: String
    let message: String
    var body: String {"""

    \(message)

    App Name: \(AppVersionProvider.appName())
    IOS: \(UIDevice.current.systemVersion)
    Device Model: \(UIDevice.current.name)
    App Version: \(AppVersionProvider.appVersion()).\(AppVersionProvider.appBuild())

    ________________________________________

"""
    }
    func sendEmail(openURL: OpenURLAction){
        let subject = subject.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        let body = body.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        let urlString = "mailto:\(toAddress)?subject=\(subject)&body=\(body)"
        guard let url = URL(string: urlString) else { return }
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
