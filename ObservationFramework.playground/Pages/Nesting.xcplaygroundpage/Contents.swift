//: [Previous](@previous)
import SwiftUI
import Observation

class A: ObservableObject {
    @Published var b = B()
}

class B: ObservableObject {
    @Published var a = 10
}

let a = A()
a.b.a = 100 /// Does not trigger view update


@Observable
class C {
    var c = 1
    var d = D()
}

@Observable
class D {
    var d = 1
}

let c = C()

withObservationTracking {
    let _ = c.d.d
} onChange: {
    print("update")
}

c.d.d = 100
/// or
c.d = D()
//: [Next](@next)
