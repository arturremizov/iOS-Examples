//: [Previous](@previous)

import Foundation

//MARK: - DispatchSource

//MARK: DispatchSourceTimer
let timerSource = DispatchSource.makeTimerSource()
func testTimerDispatchSource() {
    timerSource.setEventHandler {
        print("timerSource test")
    }
    timerSource.schedule(deadline: .now(), repeating: 5)
    timerSource.resume()
}
testTimerDispatchSource()

//MARK: DispatchSourceMemory
let memorySource = DispatchSource.makeMemoryPressureSource(eventMask: .warning, queue: .main)
func testMemoryDispatchSource() {
    memorySource.setEventHandler {
        print("memorySource test")
    }
    memorySource.resume()
}
testMemoryDispatchSource()


//MARK: DispatchSourceSignal
let signalSource = DispatchSource.makeSignalSource(signal: SIGSTOP, queue: .main)
func testSignalSource() {
    signalSource.setEventHandler {
        print("signalSource test")
    }
    signalSource.resume()
}
testSignalSource()

//MARK: DispatchSourceProcess
let processSource = DispatchSource.makeProcessSource(identifier: ProcessInfo.processInfo.processIdentifier, eventMask: .signal, queue: .main)
func testProcessSource() {
    processSource.setEventHandler {
        print("processSource test")
    }
    processSource.resume()
}
testProcessSource()


//MARK: - Target queue hierarchy
let targetQueue = DispatchQueue(label: "com.test.targetQueue", qos: .utility)
let queue1 = DispatchQueue(label: "com.test.queue1", target: targetQueue)
let queue2 = DispatchQueue(label: "com.test.queue2", qos: .background, target: targetQueue)
let queue3 = DispatchQueue(label: "com.test.queue3", qos: .userInteractive, target: targetQueue)

targetQueue.async {
    print(DispatchQoS.QoSClass(rawValue: qos_class_self()) ?? .unspecified)
    print(Thread.current)
}

queue1.async {
    print(DispatchQoS.QoSClass(rawValue: qos_class_self()) ?? .unspecified)
    print(Thread.current)
}

queue2.async {
    print(DispatchQoS.QoSClass(rawValue: qos_class_self()) ?? .unspecified)
    print(Thread.current)
}

queue3.async {
    print(DispatchQoS.QoSClass(rawValue: qos_class_self()) ?? .unspecified)
    print(Thread.current)
}
//: [Next](@next)
