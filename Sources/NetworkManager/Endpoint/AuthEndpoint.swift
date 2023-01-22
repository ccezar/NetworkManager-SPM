import Foundation

// MARK: - Request

public enum AuthApi {
    case auth(login: String, password: String)
}

extension AuthApi: EndpointType {
    public var path: String {
        switch self {
        case .auth: return "auth"
        }
    }
        
    public func getMockName() -> String {
        switch self {
        case .auth: return "auth"
        }
    }
}

// MARK: - Response

public struct AuthResponse: Codable, Equatable {
    public var id: String?
    public var name: String?
    public var email: String?
    public var phone: String?
    
    public init(id: String? = nil, name: String? = nil, email: String? = nil, phone: String? = nil) {
        self.id = id
        self.name = name
        self.email = email
        self.phone = phone
    }
}
