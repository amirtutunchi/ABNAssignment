public enum LocationEndpoint {
    case get
    
    public func url(baseURL: URL) -> URL {
        switch self {
        case .get:
           return baseURL.appendingPathComponent( "abnamrocoesd/assignment-ios/main/locations.json")
        }
    }
}
