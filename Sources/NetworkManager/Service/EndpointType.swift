import Foundation

public protocol EndpointType {
    var baseURL: URL { get }
    var path: String { get }
    var httpMethod: HTTPMethod { get }
    var task: HTTPTask { get }
    var headers: HTTPHeaders? { get }
    
    func getMockName() -> String
    func getFullURL() -> URL
}

// MARK: - Default implementations

public extension EndpointType {
    var baseURL: URL {
        guard let schemeName = Bundle.main.infoDictionary?["CURRENT_SCHEME_NAME"] as? String,
            let environment = NetworkEnvironment(rawValue: schemeName) else {
            fatalError("baseURL could not be configured.")
        }

        switch environment {
        case .mock:
            guard let path = Bundle.main.path(forResource: getMockName(), ofType: "json") else {
                fatalError("Mock not found.")
            }
            
            return NSURL.fileURL(withPath: path)
        case .debug, .release:
            guard let url = URL(string: environment.getBaseUrl()) else {
                fatalError("Mock not found.")
            }

            return url
        }
    }
    
    var httpMethod: HTTPMethod {
        .get
    }
    
    var task: HTTPTask {
        .request
    }
    
    var headers: HTTPHeaders? {
        nil
    }
    
    func getFullURL() -> URL {
        guard let schemeName = Bundle.main.infoDictionary?["CURRENT_SCHEME_NAME"] as? String,
            let environment = NetworkEnvironment(rawValue: schemeName) else {
            fatalError("baseURL could not be configured.")
        }

        if environment == .mock {
            return baseURL
        } else {
            return baseURL.appendingPathComponent(path)
        }
    }
}
