import SwiftUI

enum AppInfoProvider {
    static func appVersion(bundle: Bundle = .main) -> String {
        guard let version = bundle.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String else {
            fatalError("CFBundleShortVersionString should not be missing from info dictionary")
        }
        return version
    }
    
    static func appBuild(bundle: Bundle = .main) -> String {
        guard let build = bundle.object(forInfoDictionaryKey: "CFBundleVersion") as? String else {
            fatalError("CFBundleVersion should not be missing from info dictionary")
        }
        return build
    }
    
    static func appName(bundle: Bundle = .main) -> String {
        guard let name = bundle.object(forInfoDictionaryKey: "CFBundleName") as? String else {
            fatalError("CCFBundleName should not be missing from info dictionary")
        }
        return name
    }
    static let systemVersion = UIDevice.current.systemVersion
    static let deviceMode = UIDevice.current.name
}

