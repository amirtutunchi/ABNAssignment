import Foundation

public final class URLSessionHTTPClient: HTTPClient {
    private let session: URLSession
    
    public init(session: URLSession) {
        self.session = session
    }
        
    public func get(from url: URL, completion: @escaping (HTTPClient.Result) -> Void) {
        let task = session.dataTask(with: url) { data, response, error in
            
        }
        task.resume()
    }
}
