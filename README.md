# MonoActor

A tiny little `actor` that will only run one piece of code at a time. 

It's designed to solve the problem of users initiating multiple tasks. Think a 
user who clicks a download button and then a refresh button. In some cases we 
want the latest action the user has initiated to be running. `MonoActor` solves 
this by keeping a reference to the currently running task. When a new task is
begun it will cancel the current task.

You can see it as a single item auto-cancelling queue.

```Swift
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
```
