//
//  LoggerUtil.swift
//  ios
//
//  Created by ks on 2025/3/15.
//

import Foundation

enum LogLevel: String {
    case debug = "DEBUG"      // 调试信息
    case info = "INFO"        // 信息
    case warning = "WARNING"  // 警告
    case error = "ERROR"      // 错误
}

class LoggerUtil {
    static let shared = LoggerUtil()
    
    // 是否启用日志输出（在Release模式下为false）
    #if DEBUG
    private let isLoggingEnabled = true
    #else
    private let isLoggingEnabled = false
    #endif
    
    private init() {}
    
    func log(level: LogLevel = .info, message: String, file: String = #file, function: String = #function, line: Int = #line) {
        // 在Release模式下不输出日志
        guard isLoggingEnabled else { return }
        
        let fileName = (file as NSString).lastPathComponent
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let timestamp = dateFormatter.string(from: Date())
        
        print("[\(timestamp)] [\(level.rawValue)] [\(fileName):\(line)] \(function): \(message)")
    }
    
    // 便捷方法
    func debug(_ message: String, file: String = #file, function: String = #function, line: Int = #line) {
        log(level: .debug, message: message, file: file, function: function, line: line)
    }
    
    func info(_ message: String, file: String = #file, function: String = #function, line: Int = #line) {
        log(level: .info, message: message, file: file, function: function, line: line)
    }
    
    func warning(_ message: String, file: String = #file, function: String = #function, line: Int = #line) {
        log(level: .warning, message: message, file: file, function: function, line: line)
    }
    
    func error(_ message: String, file: String = #file, function: String = #function, line: Int = #line) {
        log(level: .error, message: message, file: file, function: function, line: line)
    }
} 
