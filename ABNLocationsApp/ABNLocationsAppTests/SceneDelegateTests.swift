import XCTest
@testable import ABNLocationsApp

final class SceneDelegateTests: XCTestCase {
    func test_configureWindow_setWindowsCorrectly() {
        let window = UIWindowSpy()
        let sut = SceneDelegate()
        sut.window = window
        sut.configureWindow()
        XCTAssertEqual(window.makeKeyAndVisibleCallCount, 1, "Expected to make window key and visible")
    }
}
// MARK: - Helper: - UIWindowSpy
private class UIWindowSpy: UIWindow {
    var makeKeyAndVisibleCallCount = 0
    override func makeKeyAndVisible() {
        makeKeyAndVisibleCallCount = 1
    }
}
