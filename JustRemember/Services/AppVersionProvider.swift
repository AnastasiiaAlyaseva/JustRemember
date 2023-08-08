import Foundation

enum AppVersionProvider {
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
}

