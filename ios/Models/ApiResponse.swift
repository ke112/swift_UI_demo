import Foundation

/// API响应模型
struct ApiResponse<T: Decodable>: Decodable {
    let code: Int
    let message: String
    let data: T?
}

/// GitHub事件模型
struct GitHubEvent: Decodable, Identifiable {
    let id: String
    let type: String
    
    // 允许解码器跳过未知字段
    private enum CodingKeys: String, CodingKey {
        case id, type
    }
}

/// 随机用户数据模型
struct RandomUserResponse: Decodable {
    let results: [User]
    let info: Info
    
    struct User: Decodable {
        let name: Name
        let email: String
        let picture: Picture
        
        struct Name: Decodable {
            let title: String
            let first: String
            let last: String
            
            var fullName: String {
                return "\(title) \(first) \(last)"
            }
        }
        
        struct Picture: Decodable {
            let large: String
            let medium: String
            let thumbnail: String
        }
    }
    
    struct Info: Decodable {
        let seed: String
        let results: Int
        let page: Int
        let version: String
    }
}

/// 天气数据模型
struct WeatherResponse: Decodable {
    let coord: Coordinates
    let weather: [Weather]
    let main: Main
    let name: String
    
    struct Coordinates: Decodable {
        let lon: Double
        let lat: Double
    }
    
    struct Weather: Decodable {
        let id: Int
        let main: String
        let description: String
        let icon: String
    }
    
    struct Main: Decodable {
        let temp: Double
        let feels_like: Double
        let temp_min: Double
        let temp_max: Double
        let pressure: Int
        let humidity: Int
    }
}
