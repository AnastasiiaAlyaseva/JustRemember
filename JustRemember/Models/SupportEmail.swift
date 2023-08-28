import SwiftUI

struct SupportEmail {
    let toAddress: String
    let subject: String
    let message: String
    var body: String {"""

    \(message)

    App Name: \(AppInfoProvider.appName())
    IOS: \(AppInfoProvider.systemVersion)
    Device Model: \(AppInfoProvider.deviceModel)
    App Version: \(AppInfoProvider.appVersion()).\(AppInfoProvider.appBuild())

    ________________________________________

"""
    }
    
    func sendEmail(openUrl: OpenURLAction, completion: @escaping (Bool) -> ()) {
        let subject = subject.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        let body = body.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        let urlString = "mailto:\(toAddress)?subject=\(subject)&body=\(body)"
        
        guard let url = URL(string: urlString) else {
            completion(false)
            return
        }
        
        openUrl(url) { accepted in
            completion(accepted)
        }
    }
}
