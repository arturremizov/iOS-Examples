//: [Previous](@previous)

import CoreFoundation

let serialQueue = DispatchQueue(label: "com.test.serial")

// MARK: - DispatchWorkItem
let item = DispatchWorkItem {
    print("test")
}
item.notify(queue: DispatchQueue.main) {
    print("finish")
}
serialQueue.async(execute: item)


let item2 = DispatchWorkItem {
    print("test2")
}
item2.perform()

// MARK: - Cancel
serialQueue.async {
    print("cancel test1")
    sleep(1)
}
serialQueue.async {
    print("cancel test2")
    sleep(1)
}
let item3 = DispatchWorkItem {
    print("cancel test")
}

serialQueue.async(execute: item3)
item3.cancel()

// MARK: - Wait
let workItem = DispatchWorkItem {
    print("wait task")
    sleep(1)
}
serialQueue.async(execute: workItem)
workItem.wait()
print("wait test")

// MARK: - Barrier
let concurrentQueue = DispatchQueue(label: "com.test.concurrent", attributes: .concurrent)

let barrierItem = DispatchWorkItem(flags: .barrier) {
    print("Barrier Item task")
    sleep(3)
}
concurrentQueue.async {
    print("barrier test 1")
    sleep(3)
}
concurrentQueue.async(execute: barrierItem)
concurrentQueue.async {
    print("barrier test 2")
}

// MARK: - QoS
print(DispatchQueue.global().qos.qosClass)
print(DispatchQueue.global(qos: .background).qos.qosClass)

// MARK: Propagation
DispatchQueue.main.async {
    // userInteractive
    print(DispatchQoS.QoSClass(rawValue: qos_class_self()) ?? .unspecified)
}

let utilityQueue = DispatchQueue(label: "com.test.utility", qos: .utility)
utilityQueue.async {
    serialQueue.async {
        // utility
        print(DispatchQoS.QoSClass(rawValue: qos_class_self()) ?? .unspecified)
    }
}

/// automatically drops from userInteractive to userInitiated
DispatchQueue.main.async {
    serialQueue.async {
        // userInitiated
        print(DispatchQoS.QoSClass(rawValue: qos_class_self()) ?? .unspecified)
    }
}


let userInitiatedQueue = DispatchQueue(label: "com.test.userInitiated", qos: .userInitiated)
utilityQueue.async {
    // utility
    print(DispatchQoS.QoSClass(rawValue: qos_class_self()) ?? .unspecified)
    userInitiatedQueue.async {
        // userInitiated
        print(DispatchQoS.QoSClass(rawValue: qos_class_self()) ?? .unspecified)
    }
}


serialQueue.async(qos: .utility) {
    // utility
    print(DispatchQoS.QoSClass(rawValue: qos_class_self()) ?? .unspecified)
}

utilityQueue.async {
    // utility
    print(DispatchQoS.QoSClass(rawValue: qos_class_self()) ?? .unspecified)
}

// MARK: DispatchWorkItem QoS
// inheritQoS
utilityQueue.async {
    let workItem = DispatchWorkItem(qos: .userInitiated, flags: .inheritQoS) {
        // utility
        print(DispatchQoS.QoSClass(rawValue: qos_class_self()) ?? .unspecified)
    }
    workItem.perform()
}
// or
let inheritQoSWorkItem = DispatchWorkItem(qos: .userInitiated, flags: .inheritQoS) {
    // utility
    print(DispatchQoS.QoSClass(rawValue: qos_class_self()) ?? .unspecified)
}
utilityQueue.async(execute: inheritQoSWorkItem)

// enforceQoS
let enforceQoSWorkItem = DispatchWorkItem(qos: .userInitiated, flags: .enforceQoS) {
    // userInitiated
    print(DispatchQoS.QoSClass(rawValue: qos_class_self()) ?? .unspecified)
}
utilityQueue.async(execute: enforceQoSWorkItem)

// MARK: Priority Inversion
// GCD automatically raises the QoS of the low-prioritized task
utilityQueue.async {
    sleep(2)
}
let priorityInversionWorkItem = DispatchWorkItem(qos: .userInitiated, flags: .enforceQoS) {
    sleep(1)
}
utilityQueue.async(execute: priorityInversionWorkItem)
