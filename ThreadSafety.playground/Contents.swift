import Foundation
import os

final class Name {
    private(set) var firstName: String = ""
    private(set) var lastName: String = ""

    var stateLock = NSLock()
    func setFullName(firstName: String, lastName: String) {
        stateLock.lock()
        self.firstName = firstName
        self.lastName = lastName
        stateLock.unlock()
    }
}

//MARK: Serial DispatchQueues
let queue = DispatchQueue(label: "my-queue", qos: .userInteractive)

queue.async {
    // Critical region  1
}

queue.async {
    // Critical region  2
}


//MARK: os_unfair_lock
let lock = OSAllocatedUnfairLock()
lock.withLock {
    // Critical region
}


//MARK: NSLock
let nslock = NSLock()

func synchronize(action: () -> Void) {
    if nslock.lock(before: Date().addingTimeInterval(5)) {
        action()
        nslock.unlock()
    } else {
        print("Took to long to lock, did we deadlock?")
        // Report potential deadlock
        action()
    }
}


//MARK: NSRecursiveLock
let recursiveLock = NSRecursiveLock()

func synchronizeWithRecursiveLock(action: () -> Void) {
    recursiveLock.lock()
    action()
    recursiveLock.unlock()
}

func logEntered() {
    synchronizeWithRecursiveLock {
        print("Entered!")
    }
}

func logExited() {
    synchronizeWithRecursiveLock {
        print("Exited!")
    }
}

func logLifecycle() {
    synchronizeWithRecursiveLock {
        logEntered()
        print("Running!")
        logExited()
    }
}

//logLifecycle()


//MARK: DispatchSemaphore
let semaphore = DispatchSemaphore(value: 0)

func mySlowAsynchronousTask(completion: () -> Void) {
    print("Did start task")
    sleep(1)
    print("Did complete task")
    completion()
}

mySlowAsynchronousTask {
    semaphore.signal()
}

semaphore.wait()
print("Did finish fetching user information! Proceeding...")


//MARK: DispatchGroup
let group = DispatchGroup()

for _ in 0..<6 {
    group.enter()
    mySlowAsynchronousTask {
        group.leave()
    }
}

//group.wait()
//print("ALL tasks done!")
group.notify(queue: .main) {
    print("ALL tasks done!")
}
