import XCTest
@testable import MonoActor

final class MonoActorTests: XCTestCase {
    
    func testBasicUsage() async throws {
        let monoActor = MonoActor()
        Task {
            do {
                try await monoActor.run {
                    try await Task.sleep(nanoseconds: 1_000_000)
                    print("I'm never going to get run.")
                    XCTFail("This should never happen")
                }
            } catch {
                print("I'll get cancelled by the next task.")
            }
        }
        
        Task {
            try await monoActor.run {
                print("I'm going to cancel the preceeding closure.")
            }
        }
    }
    
    func testMonoActor() async throws {
        let queue = MonoActor()
        let failureExpectations = expectation(description: "Expected failures")
        failureExpectations.expectedFulfillmentCount = [1,3,5,7,9].count
        let successExpectations = expectation(description: "Expected successes")
        successExpectations.expectedFulfillmentCount = [0,2,4,6,8,10].count
        
        for x in 0...10 {
            Task.detached {
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
                } catch is CancellationError {
                    failureExpectations.fulfill()
                } catch {
                    XCTFail("Unrecognised error '\(error.localizedDescription)' occured.")
                }
            }
        }
        await fulfillment(of: [successExpectations,failureExpectations], timeout: 4, enforceOrder: false)
    }
}
