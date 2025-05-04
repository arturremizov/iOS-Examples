//: [Previous](@previous)

import CoreFoundation

// MARK: - DispatchGroup
let concurrentQueue = DispatchQueue(label: "com.test.concurrentQueue", attributes: .concurrent)
let group = DispatchGroup()

concurrentQueue.async(group: group) {
    sleep(1)
    print("group1: test1")
}

concurrentQueue.async(group: group) {
    sleep(2)
    print("group1: test2")
}

group.notify(queue: DispatchQueue.main) {
    print("group1: All tasks completed")
}

let concurrentQueue2 = DispatchQueue(label: "com.test.concurrentQueue", attributes: .concurrent)
let group2 = DispatchGroup()

group2.enter()
concurrentQueue2.async {
    print("group2: test1")
    group2.leave()
}

group2.enter()
concurrentQueue2.async {
    print("group2: test2")
    group2.leave()
}

group2.wait()
print("group2: All tasks completed")


// MARK: - ConcurrentPerform

func fibonacci(n: Int) -> Int {
    if n <= 1 { return 1 }
    return fibonacci(n: n - 1) + fibonacci(n: n - 2)
}

let parameters: [Int] = (0..<8).map { _ in Int.random(in: 35...42) }

/// concurrentPerform 15–25% faster than DispathcGroup implementation.
func concurrentPerformFibonacci() {
    DispatchQueue.concurrentPerform(iterations: parameters.count) { i in
        _ = fibonacci(n: parameters[i])
    }
}

func asyncFibonacci() {
    let group = DispatchGroup()
    for parameter in parameters {
        group.enter()
        concurrentQueue.async {
            _ = fibonacci(n: parameter)
            group.leave()
        }
    }
    group.wait()
}


// MARK: - Dispatch precondition

DispatchQueue.global().async {
//    dispatchPrecondition(condition: .onQueue(.main))
//    dispatchPrecondition(condition: .notOnQueue(.global()))
    dispatchPrecondition(condition: .notOnQueue(.main))
    print("Dispatch precondition test")
}

//: [Next](@next)
