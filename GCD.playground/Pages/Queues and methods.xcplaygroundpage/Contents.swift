import CoreFoundation

let serialQueue = DispatchQueue(label: "com.test.serial")
let concurrentQueue = DispatchQueue(label: "com.test.concurrent", attributes: .concurrent)

let globalQueue = DispatchQueue.global()
let mainQueue = DispatchQueue.main

serialQueue.async {
    print("test 1")
}
serialQueue.async {
//    sleep(1)
    print("test 2")
}
serialQueue.sync {
    print("test 3")
}
serialQueue.sync {
    print("test 4")
}

// Cause deadlock
//serialQueue.sync {
//    serialQueue.sync {
//        print("test")
//    }
//}

// Cause deadlock
//DispatchQueue.main.sync {
//    print("test")
//}

concurrentQueue.async {
    print("concurrent test 1")
}
concurrentQueue.async {
    print("concurrent test 2")
}
concurrentQueue.sync {
    print("concurrent test 3")
}
concurrentQueue.sync {
    print("concurrent test 4")
}

concurrentQueue.asyncAfter(deadline: .now() + 3, execute: {
    print("async after test")
})


serialQueue.async {
    sleep(3)
    print("Serial queue long-term task finish")
}

serialQueue.asyncAfter(deadline: .now() + 1) {
    print("serial queue async after test")
}

//: [Next](@next)
