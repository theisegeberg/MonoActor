
import Foundation

/// MonoActor will is a single item queue, it will cancel any ongoing tasks if another is attempted.
/// This is useful for user interactions that needs to cancel any ongoing requests made by the user.
@available(iOS 13.0, *)
@available(macOS 10.15, *)
public actor MonoActor {
    
    private var currentTaskCancellation:(() -> ())? = nil
    
    public init() {}
    
    /// Run a piece of code and cancel any ongoing pieces of code that is being run.
    /// - Parameter f: The closure with the code to be run.
    /// - Returns: The return value of the code being run.
    public func run<T>(_ f: @escaping () async throws -> (T)) async throws -> T {
        defer {
            self.currentTaskCancellation = nil
        }
        if let currentTaskCancellation {
            currentTaskCancellation()
        }
        let task = Task {
            try await f()
        }
        currentTaskCancellation = task.cancel
        return try await task.value
    }
    
    /// Run a piece of code and cancel any ongoing pieces of code that is being run.
    /// - Parameter f: The closure with the code to be run.
    public func run(_ f: @escaping () async throws -> ()) async throws {
        try await self.run<Void>(f)
    }
    
    public func cancel() {
        currentTaskCancellation?()
        currentTaskCancellation = nil
    }
    
}
