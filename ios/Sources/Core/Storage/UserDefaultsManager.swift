import Foundation

@propertyWrapper
struct UserDefault<T> {
    let key: String
    let defaultValue: T
    
    init(_ key: String, defaultValue: T) {
        self.key = key
        self.defaultValue = defaultValue
    }
    
    var wrappedValue: T {
        get {
            return UserDefaults.standard.object(forKey: key) as? T ?? defaultValue
        }
        set {
            UserDefaults.standard.set(newValue, forKey: key)
        }
    }
}

final class UserDefaultsManager {
    static let shared = UserDefaultsManager()
    
    @UserDefault("isFirstLaunch", defaultValue: true)
    var isFirstLaunch: Bool
    
    @UserDefault("lastLoginDate", defaultValue: nil)
    var lastLoginDate: Date?
    
    private init() {}
    
    func clearAll() {
        let domain = Bundle.main.bundleIdentifier!
        UserDefaults.standard.removePersistentDomain(forName: domain)
    }
} 