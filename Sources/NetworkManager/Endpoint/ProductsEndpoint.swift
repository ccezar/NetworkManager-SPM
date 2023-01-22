import Foundation

// MARK: - Request

public enum ProductsApi {
    case get(id: String)
    case list(page: Int)
}

extension ProductsApi: EndpointType {
    public var path: String {
        switch self {
        case let .get(id): return "product/\(id)"
        case .list: return "products"
        }
    }
        
    public func getMockName() -> String {
        switch self {
        case .get: return "product-detail"
        case .list: return "products"
        }
    }
}

// MARK: - Response

public struct ProductsResponse: Codable, Equatable {
    public let entries: [ProductResponse]?
}

public struct ProductResponse: Codable, Equatable {
    public var id: String?
    public let name: String?
    public let image: String?
    public let price: String?
    public let category: CategoryResponse?
    public let description: String?
    public let size: String?
    public let condition: String?
    public let brand: String?
    public let otherInfos: String?
    public let seller: SellerResponse?
    
    public init(id: String? = nil, name: String? = nil, image: String? = nil, price: String? = nil, category: CategoryResponse? = nil, description: String? = nil, size: String? = nil, condition: String? = nil, brand: String? = nil, otherInfos: String? = nil, seller: SellerResponse? = nil) {
        self.id = id
        self.name = name
        self.image = image
        self.price = price
        self.category = category
        self.description = description
        self.size = size
        self.condition = condition
        self.brand = brand
        self.otherInfos = otherInfos
        self.seller = seller
    }
}

public struct SellerResponse: Codable, Equatable {
    public let name: String?
    public let memberSince: String?
    public let sales: Int?
}
