import Combine
import XCTest
@testable import Combineer

final class BindingObjectTests: XCTestCase {
    typealias SUT = BindingObject

    func test_bind_storesSubscriptionInCancellables() {
        let object = MockBindingObject()
        object.bind("".publisher, valueHandler: { _ in })
        XCTAssertEqual(object.cancellables.count, 1)
    }
}

extension BindingObjectTests {
    final class MockBindingObject: BindingObject {
        var cancellables: Set<AnyCancellable> = []
    }
}
