import Foundation

/// 网络请求工具类
class NetworkUtil {
    static let shared = NetworkUtil()

    private init() {}

    /// 请求结果回调
    typealias CompletionHandler<T: Decodable> = (Result<T, Error>) -> Void

    /// 错误类型
    enum NetworkError: Error {
        case invalidURL
        case noData
        case decodingError
        case serverError(Int)
        case unknownError(String)

        var localizedDescription: String {
            switch self {
            case .invalidURL:
                return "无效的URL"
            case .noData:
                return "没有返回数据"
            case .decodingError:
                return "数据解析失败"
            case let .serverError(code):
                return "服务器错误: \(code)"
            case let .unknownError(message):
                return "未知错误: \(message)"
            }
        }
    }

    /// 执行GET请求
    /// - Parameters:
    ///   - urlString: URL字符串
    ///   - parameters: 请求参数
    ///   - headers: 请求头
    ///   - completion: 完成回调
    func get<T: Decodable>(
        urlString: String,
        parameters: [String: Any]? = nil,
        headers: [String: String]? = nil,
        completion: @escaping CompletionHandler<T>
    ) {
        guard var components = URLComponents(string: urlString) else {
            completion(.failure(NetworkError.invalidURL))
            return
        }

        // 添加查询参数
        if let parameters = parameters {
            components.queryItems = parameters.map {
                URLQueryItem(name: $0.key, value: "\($0.value)")
            }
        }

        guard let url = components.url else {
            completion(.failure(NetworkError.invalidURL))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        // 添加请求头
        if let headers = headers {
            for (key, value) in headers {
                request.setValue(value, forHTTPHeaderField: key)
            }
        }

        // 添加默认请求头
        request.setValue("application/json", forHTTPHeaderField: "Accept")

        executeRequest(request, completion: completion)
    }

    /// 执行POST请求
    /// - Parameters:
    ///   - urlString: URL字符串
    ///   - parameters: 请求参数
    ///   - headers: 请求头
    ///   - completion: 完成回调
    func post<T: Decodable>(
        urlString: String,
        parameters: [String: Any]? = nil,
        headers: [String: String]? = nil,
        completion: @escaping CompletionHandler<T>
    ) {
        guard let url = URL(string: urlString) else {
            completion(.failure(NetworkError.invalidURL))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        // 添加请求头
        if let headers = headers {
            for (key, value) in headers {
                request.setValue(value, forHTTPHeaderField: key)
            }
        }

        // 添加默认请求头
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")

        // 添加请求体
        if let parameters = parameters {
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: parameters)
                request.httpBody = jsonData
            } catch {
                completion(.failure(error))
                return
            }
        }

        executeRequest(request, completion: completion)
    }

    /// 执行请求
    private func executeRequest<T: Decodable>(
        _ request: URLRequest,
        completion: @escaping CompletionHandler<T>
    ) {
        LoggerUtil.shared.info("发起请求: \(request.url?.absoluteString ?? "unknown")")

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            // 处理错误
            if let error = error {
                LoggerUtil.shared.error("网络请求失败: \(error.localizedDescription)")
                completion(.failure(error))
                return
            }

            // 检查HTTP状态码
            if let httpResponse = response as? HTTPURLResponse {
                let statusCode = httpResponse.statusCode

                if statusCode < 200 || statusCode >= 300 {
                    LoggerUtil.shared.error("HTTP错误: \(statusCode)")
                    completion(.failure(NetworkError.serverError(statusCode)))
                    return
                }
            }

            // 检查数据
            guard let data = data else {
                LoggerUtil.shared.error("没有返回数据")
                completion(.failure(NetworkError.noData))
                return
            }

            // 解析数据
            do {
                // 如果T是Data类型，直接返回
                if T.self == Data.self {
                    completion(.success(data as! T))
                    return
                }

                // 解析JSON
                let decodedObject = try JSONDecoder().decode(T.self, from: data)
                LoggerUtil.shared.info("请求成功: \(request.url?.absoluteString ?? "unknown")")
                completion(.success(decodedObject))
            } catch {
                LoggerUtil.shared.error("数据解析失败: \(error.localizedDescription)")
                completion(.failure(NetworkError.decodingError))
            }
        }

        task.resume()
    }
}
