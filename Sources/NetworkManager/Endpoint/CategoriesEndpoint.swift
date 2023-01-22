import Foundation

// MARK: - Request

public enum CategoriesApi {
    case get(id: Int)
    case list
}

extension CategoriesApi: EndpointType {
    public var path: String {
        switch self {
        case let .get(id): return "categorie/\(id)"
        case .list: return "categories"
        }
    }
        
    public func getMockName() -> String {
        switch self {
        case .get: return "categorie"
        case .list: return "categories"
        }
    }
}

// MARK: - Response

public struct CategoriesResponse: Codable, Equatable {
    public var entries: [CategoryResponse]?
}

public struct CategoryResponse: Codable, Equatable {
    public var id: String?
    public var name: String?
    public var image: String?
}
