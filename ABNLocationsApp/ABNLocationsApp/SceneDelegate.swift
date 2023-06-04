import UIKit
import ABNLocations

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    private lazy var baseURL = URL(string: "https://raw.githubusercontent.com/")!
    
    private lazy var httpClient: HTTPClient = {
        URLSessionHTTPClient(session: URLSession(configuration: .ephemeral))
    }()
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

        guard let scene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: scene)
        configureWindow()
    }
    
    func configureWindow() {
        let locationsListViewController = LocationUIComposer.locationsComposedWith(locationLoader: makeRemoteLocationLoader())
        window?.rootViewController = locationsListViewController
        window?.makeKeyAndVisible()
    }
    
    private func makeRemoteLocationLoader() -> LocationLoader {
        let url = LocationEndpoint.get.url(baseURL: baseURL)
        
        return httpClient
            .getPublisher(url: url)
            .tryMap(LocationMapper.map)
            .eraseToAnyPublisher()
    }
}
