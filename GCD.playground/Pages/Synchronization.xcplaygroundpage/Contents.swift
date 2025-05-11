//: [Previous](@previous)

import CoreFoundation

// MARK: - Semaphore
let semaphore = DispatchSemaphore(value: 0)
DispatchQueue.global().async {
    print("test1")
    sleep(1)
    semaphore.signal()
}
semaphore.wait()
print("test2")


let semaphore2 = DispatchSemaphore(value: 1)
private var internalResource: Int = 0
var resource: Int {
    get {
        defer {
            semaphore2.signal()
        }
        semaphore2.wait()
        return internalResource
    }
    set {
        semaphore2.wait()
        print(newValue)
        internalResource = newValue
        sleep(1)
        semaphore2.signal()
    }
}

let group = DispatchGroup()
DispatchQueue.global().async(group: group) {
    resource = 1
}
DispatchQueue.global().async(group: group) {
    resource = 2
}
DispatchQueue.global().async(group: group) {
    resource = 3
}
group.notify(queue: .global()) {
    print("Result: \(resource)")
}

// MARK: - Sync
let queue = DispatchQueue(label: "com.test.serial")
private var internalResource2: Int = 0
var resource2: Int {
    get {
        queue.sync {
            print("Read \(internalResource2)")
            sleep(1)
            return internalResource2
        }
    }
    set {
        queue.async {
            print("Write \(newValue)")
            sleep(1)
            internalResource2 = newValue
        }
    }
}

func testQueueSynchronization() {
    for i in 0..<10 {
        if i % 2 == 0 {
            DispatchQueue.global().asyncAfter(deadline: .now() + .seconds(Int.random(in: 1...5))) {
                resource2 = i
            }
        } else {
            DispatchQueue.global().asyncAfter(deadline: .now() + .seconds(Int.random(in: 1...5))) {
                _ = resource2
            }
        }
    }
}

testQueueSynchronization()

// MARK: - Barrier
let concurrentQueue = DispatchQueue(label: "com.test.concurrent", attributes: .concurrent)
private var internalResource3: Int = 0
var resource3: Int {
    get {
        concurrentQueue.sync {
            return internalResource3
        }
    }
    set {
        concurrentQueue.async(flags: .barrier) {
            print("--Barrier--")
            sleep(1)
            internalResource3 = newValue
        }
    }
}

func testBarrier() {
    for i in 0..<10 {
        if i % 2 == 0 {
            DispatchQueue.global().asyncAfter(deadline: .now() + .seconds(Int.random(in: 1...5))) {
                resource3 = i
            }
        } else {
            DispatchQueue.global().asyncAfter(deadline: .now() + .seconds(Int.random(in: 1...5))) {
                print(resource3)
            }
        }
    }
}

testBarrier()
//: [Next](@next)
