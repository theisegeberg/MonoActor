import XCTest
@testable import MonoActor

final class MonoActorTests: XCTestCase {
    func testMonoActor() async throws {
        let queue = MonoActor()
        let failureExpectations = expectation(description: "Expected failures")
        failureExpectations.expectedFulfillmentCount = [1,3,5,7,9].count
        let successExpectations = expectation(description: "Expected successes")
        successExpectations.expectedFulfillmentCount = [0,2,4,6,8,10].count
        
        for x in 0...10 {
            Task {
                do {
                    let result = try await queue.run {
                        if x.isMultiple(of: 2) {
                            return x
                        } else {
                            try await Task.sleep(nanoseconds: 1000)
                            return x
                        }
                        
                    }
                    XCTAssertEqual(result, x)
                    successExpectations.fulfill()
                } catch {
                    failureExpectations.fulfill()
                }
            }
        }
        await fulfillment(of: [successExpectations,failureExpectations], timeout: 4, enforceOrder: false)
    }
}
