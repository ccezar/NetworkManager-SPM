import Foundation

// MARK: - Request

public enum HomeApi {
    case get
    case getLastSearch
}

extension HomeApi: EndpointType {
    public var path: String {
        switch self {
        case .get: return "home"
        case .getLastSearch: return "home/last-search"
        }
    }
        
    public func getMockName() -> String {
        switch self {
        case .get: return "home"
        case .getLastSearch: return "home-last-search"
        }
    }
}

// MARK: - Response

public struct HomeResponse: Codable, Equatable {
    
}
