import Combine
import XCTest
@testable import Combineer

final class BindingObjectTests: XCTestCase {
    private var sut: MockBindingObject!
    private var stringPulisher: Publishers.Sequence<String, Never>!
    private var stringSubject: PassthroughSubject<String, Never>!
    private var otherStringSubject: PassthroughSubject<String, Never>!

    // MARK: - Lifecycle

    override func setUp() {
        sut = MockBindingObject()
        stringPulisher = "".publisher
        stringSubject = PassthroughSubject<String, Never>()
        otherStringSubject = PassthroughSubject<String, Never>()
    }

    override func tearDown() {
        sut = nil
        stringPulisher = nil
        stringSubject = nil
    }

    // MARK: - Test bind

    func test_bind_storesSubscriptionInCancellables() {
        sut.bind(stringPulisher, valueHandler: { _ in })
        XCTAssertEqual(sut.cancellables.count, 1)
    }

    func test_bind_assignsCorrectReceiveHandler() {
        let passedValue = "passed value"
        let expectation = makeReceivedValueExpectation()

        sut.bind(stringSubject) { value in
            XCTAssertEqual(value, passedValue)
            expectation.fulfill()
        }

        DispatchQueue.main.async { [weak self] in
            self?.stringSubject.send(passedValue)
        }

        wait(for: [expectation], timeout: 1)
    }

    func test_bindTo_storesSubscriptionInCancellables() {
        sut.bind(stringSubject, to: otherStringSubject)
        XCTAssertEqual(sut.cancellables.count, 1)
    }

    func test_bindTo_toAnotherSubject_subscribesToThatSubject() {
        let passedValue = "some text"
        let expectation = makeReceivedValueExpectation()

        sut.bind(otherStringSubject) { value in
            XCTAssertEqual(value, passedValue)
            expectation.fulfill()
        }
        sut.bind(stringSubject, to: otherStringSubject)

        stringSubject.send(passedValue)

        wait(for: [expectation], timeout: 1)
    }

    // MARK: - Test bindOnMainQueue

    func test_bindOnMainQueue_storesSubscriptionInCancellables() {
        sut.bindOnMainQueue(stringPulisher, valueHandler: { _ in })
        XCTAssertEqual(sut.cancellables.count, 1)
    }

    func test_bindOnMainQueue_whenValueSentFromOtherQueue_receivesOnMainQueue() {
        let expectation = makeReceivedValueExpectation()

        sut.bindOnMainQueue(stringSubject) { _ in
            XCTAssert(Thread.current.isMainThread, "Not on main thread.")
            expectation.fulfill()
        }

        DispatchQueue.global().async { [weak self] in
            self?.stringSubject.send("123")
        }

        wait(for: [expectation], timeout: 1)
    }

    func test_bindOnMainQueueTo_storesSubscriptionInCancellables() {
        sut.bindOnMainQueue(stringSubject, to: otherStringSubject)
        XCTAssertEqual(sut.cancellables.count, 1)
    }

    func test_bindOnMainQueueTo_whenValueSentFromOtherQueue_receivesOnMainQueue() {
        let expectation = makeReceivedValueExpectation()

        sut.bind(otherStringSubject) { _ in
            XCTAssert(Thread.current.isMainThread, "Not on main thread.")
            expectation.fulfill()
        }
        sut.bindOnMainQueue(stringSubject, to: otherStringSubject)

        DispatchQueue.global().async {
            self.stringSubject.send("text")
        }

        wait(for: [expectation], timeout: 1)
    }
}

// MARK: - Private Methods

extension BindingObjectTests {
    private func makeReceivedValueExpectation() -> XCTestExpectation {
        expectation(description: "Receive value from publisher")
    }
}

// MARK: - Helpers

extension BindingObjectTests {
    private final class MockBindingObject: BindingObject {
        var cancellables: Set<AnyCancellable> = []
    }
}
