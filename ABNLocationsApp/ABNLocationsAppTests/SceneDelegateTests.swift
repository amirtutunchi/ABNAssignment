import XCTest
@testable import ABNLocationsApp
import ABNLocationiOS

final class SceneDelegateTests: XCTestCase {
    func test_configureWindow_setWindowsCorrectly() {
        let window = UIWindowSpy()
        let sut = SceneDelegate()
        sut.window = window
        
        sut.configureWindow()
        
        XCTAssertEqual(window.makeKeyAndVisibleCallCount, 1, "Expected to make window key and visible")
    }
    
    func test_configureWindow_configuresRootViewController() {
        let sut = SceneDelegate()
        sut.window = UIWindow()
        
        sut.configureWindow()
        
        let root = sut.window?.rootViewController
        let rootViewController = root as? LocationsListViewController
        
        XCTAssertTrue(rootViewController != nil, "Expected a LocationsListViewController as top view controller, got \(String(describing: rootViewController)) instead")
    }
}

// MARK: - Helper: - UIWindowSpy
private class UIWindowSpy: UIWindow {
    var makeKeyAndVisibleCallCount = 0
    
    override func makeKeyAndVisible() {
        makeKeyAndVisibleCallCount = 1
    }
}
