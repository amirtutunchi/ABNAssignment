public struct Location: Equatable {
    public init(name: String?, latitude: Double, longitude: Double) {
        self.name = name
        self.latitude = latitude
        self.longitude = longitude
    }
    
    let name: String?
    let latitude: Double
    let longitude: Double
}
