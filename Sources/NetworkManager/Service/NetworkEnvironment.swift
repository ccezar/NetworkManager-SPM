public enum NetworkEnvironment: String {
    case debug = "Debug"
    case mock = "Mock"
    case release = "Release"
    
    public func getBaseUrl() -> String {
        switch self {
        case .debug: return "https://growmart-api.herokuapp.com/v1/"
        case .mock: return ""
        case .release: return "https://growmart-api.herokuapp.com/v1/"
        }
    }
}
