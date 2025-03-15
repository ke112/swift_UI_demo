//
//  DeviceInfoUtil.swift
//  ios
//
//  Created by ks on 2025/3/15.
//

import Foundation
import UIKit
import SystemConfiguration

/// 设备信息工具类
/// 负责收集设备相关信息，不包含埋点逻辑
class DeviceInfoUtil {
    static let shared = DeviceInfoUtil()
    
    private init() {}
    
    // 获取设备唯一标识符
    func getDeviceUUID() -> String {
        if let uuid = UIDevice.current.identifierForVendor?.uuidString {
            return uuid
        }
        return UUID().uuidString
    }
    
    // 获取设备名称
    func getDeviceName() -> String {
        return UIDevice.current.name
    }
    
    // 获取设备型号
    func getDeviceModel() -> String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        return identifier
    }
    
    // 获取操作系统名称
    func getOSName() -> String {
        return UIDevice.current.systemName
    }
    
    // 获取操作系统版本
    func getOSVersion() -> String {
        return UIDevice.current.systemVersion
    }
    
    // 获取App版本
    func getAppVersion() -> String {
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            return version
        }
        return "unknown"
    }
    
    // 获取App构建版本
    func getAppBuildVersion() -> String {
        if let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String {
            return build
        }
        return "unknown"
    }
    
    // 获取App包名
    func getAppBundleId() -> String {
        return Bundle.main.bundleIdentifier ?? "unknown"
    }
    
    // 获取屏幕尺寸
    func getScreenSize() -> CGSize {
        return UIScreen.main.bounds.size
    }
    
    // 获取通知权限状态
    func getNotificationStatus(completion: @escaping (Bool) -> Void) {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            let granted = settings.authorizationStatus == .authorized
            DispatchQueue.main.async {
                completion(granted)
            }
        }
    }
    
    // 获取当前环境
    func getEnvironment() -> String {
        #if DEBUG
        return "dev"
        #else
        return "prod"
        #endif
    }
} 
