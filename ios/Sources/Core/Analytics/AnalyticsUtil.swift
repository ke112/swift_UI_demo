//
//  AnalyticsUtil.swift
//  ios
//
//  Created by ks on 2025/3/15.
//

import Foundation
import UIKit

// 事件类型枚举
enum EventType: String {
    case click
    case show
    case custom
}

// 埋点工具类
class AnalyticsUtil {
    static let shared = AnalyticsUtil()

    // 是否启用调试日志（在Release模式下为false）
    #if DEBUG
        private let isDebugLoggingEnabled = true
    #else
        private let isDebugLoggingEnabled = false
    #endif

    // 缓存的公共参数
    private var cachedCommonParams: [String: Any]?
    private let commonParamsCacheDuration: TimeInterval = 60 // 缓存60秒
    private var lastCommonParamsUpdateTime: Date?

    // 用户ID
    private var userId: String?

    private init() {}

    /// 记录埋点事件
    /// - Parameters:
    ///   - origin: 来源（可选）
    ///   - entity: 入口（可选）
    ///   - event: 事件类型
    ///   - eventName: 事件名称（可选），如果为空则自动根据origin_entity_event格式生成
    ///   - spec: 附加参数（可选）
    func track(
        origin: String? = nil,
        entity: String? = nil,
        event: EventType,
        eventName: String? = nil,
        spec: [String: Any]? = nil
    ) {
        // 如果eventName为空，则根据origin_entity_event格式生成
        let finalEventName: String
        if let providedEventName = eventName {
            finalEventName = providedEventName
        } else {
            // 构建各部分
            var parts: [String] = []

            if let origin = origin {
                parts.append(origin)
            }

            if let entity = entity {
                parts.append(entity)
            }

            parts.append(event.rawValue)

            // 用下划线连接各部分
            finalEventName = parts.joined(separator: "_")
        }

        // 构建埋点数据
        var analyticsData: [String: Any] = [
            "event_type": event.rawValue,
            "event_name": finalEventName,
        ]

        // 添加可选参数
        if let origin = origin {
            analyticsData["origin"] = origin
        }

        if let entity = entity {
            analyticsData["entity"] = entity
        }

        // 添加公共参数
        var commonParams = getCommonParameters()
        commonParams["event_info"] = analyticsData

        if let spec = spec {
            commonParams["spec"] = spec
        }

        // 仅在Debug模式下输出日志
        if isDebugLoggingEnabled {
            // 非Debug模式下避免json序列化
            let jsonData = try? JSONSerialization.data(withJSONObject: commonParams, options: .prettyPrinted)
            if let jsonString = jsonData.flatMap({ String(data: $0, encoding: .utf8) }) {
                // 使用日志工具类记录埋点信息
                LoggerUtil.shared.info("埋点事件: \(jsonString)")
            } else {
                LoggerUtil.shared.error("埋点事件序列化失败: \(commonParams)")
            }
        }

        // 这里可以添加实际的埋点上报逻辑，如调用第三方SDK等
        // 无论是Debug还是Release模式，都执行实际的埋点上报
        sendAnalyticsEvent(commonParams)
    }

    // 获取公共参数（带缓存机制）
    private func getCommonParameters() -> [String: Any] {
        // 检查是否有有效的缓存
        if let cachedParams = cachedCommonParams,
           let lastUpdateTime = lastCommonParamsUpdateTime,
           Date().timeIntervalSince(lastUpdateTime) < commonParamsCacheDuration
        {
            return cachedParams
        }

        // 获取最新的公共参数
        let deviceInfo = DeviceInfoUtil.shared
        let screenSize = deviceInfo.getScreenSize()

        var params: [String: Any] = [
            // 设备信息
            "device_id": deviceInfo.getDeviceUUID(),
            "device_name": deviceInfo.getDeviceName(),
            "device_model": deviceInfo.getDeviceModel(),
            "device_brand": "ios",
            "device_manufacturer": "ios",

            // 操作系统信息
            "os_name": deviceInfo.getOSName(),
            "os_version": deviceInfo.getOSVersion(),

            // 屏幕信息
            "screen_width": screenSize.width,
            "screen_height": screenSize.height,
            "client_width": screenSize.width,
            "client_height": screenSize.height,

            // App信息
            "app_version": deviceInfo.getAppVersion(),
            "app_build": deviceInfo.getAppBuildVersion(),
            "app_package": deviceInfo.getAppBundleId(),

            // 环境信息
            "environment": deviceInfo.getEnvironment(),

            // 时间信息
            "time": Date().timeIntervalSince1970 * 1000,

            // 用户来源
            "user_source": "app",
        ]

        // 添加用户ID（如果有）
        if let userId = userId {
            params["user_id"] = userId
        }

        // 获取通知权限状态（异步，不会立即反映在结果中）
        deviceInfo.getNotificationStatus { granted in
            // 由于这是异步回调，不会影响当前返回的参数
            // 但会影响下一次获取的缓存参数
            if let cachedParams = self.cachedCommonParams {
                var updatedParams = cachedParams
                updatedParams["notification_state"] = granted
                self.cachedCommonParams = updatedParams
            }
        }

        // 更新缓存
        cachedCommonParams = params
        lastCommonParamsUpdateTime = Date()

        return params
    }

    // 实际发送埋点事件的方法（示例）
    private func sendAnalyticsEvent(_: [String: Any]) {
        // TODO: 实现实际的埋点上报逻辑
        // 例如调用第三方SDK的上报接口
        // 这里只是一个占位，实际项目中需要替换为真正的上报逻辑
    }

    // 便捷方法 - 自定义事件
    func trackEvent(
        name: String,
        parameters: [String: Any]? = nil
    ) {
        track(event: .custom, eventName: name, spec: parameters)
    }

    // 便捷方法 - 点击事件
    func trackClick(
        origin: String? = nil,
        entity: String? = nil,
        eventName: String? = nil,
        spec: [String: Any]? = nil
    ) {
        track(origin: origin, entity: entity, event: .click, eventName: eventName, spec: spec)
    }

    // 便捷方法 - 展示事件
    func trackShow(
        origin: String? = nil,
        entity: String? = nil,
        eventName: String? = nil,
        spec: [String: Any]? = nil
    ) {
        track(origin: origin, entity: entity, event: .show, eventName: eventName, spec: spec)
    }

    // 设置用户ID
    func setUserId(_ userId: String?) {
        self.userId = userId
        // 清除缓存，强制下次获取最新的公共参数
        cachedCommonParams = nil
        lastCommonParamsUpdateTime = nil
    }
}
