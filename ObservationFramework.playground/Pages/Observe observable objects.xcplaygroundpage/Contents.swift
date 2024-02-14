//: [Previous](@previous)
import SwiftUI
import Observation

@Observable
class Store {
    var a = 10
    var b = 20
    var c = 20
}

struct ContentView: View {
    @State var store = Store()
    var body: some View {
        EmptyView()
    }
}


let store = Store()

let sum = withObservationTracking {
    store.a + store.b
} onChange: {
    print("Store Changed a:\(store.a), b:\(store.b), c:\(store.c)")
}

store.c = 100 /// No output
store.b = 100 /// Store Changed a:10 b:20 c:100
store.a = 100 /// No output


withObservationTracking {
   print(store)
   DispatchQueue.main.asyncAfter(deadline: .now() + 0.3){
      store.a = 100
   }
} onChange: {
    print("Store Changed")
}

store.b = 100 /// No output
store.a = 100 /// No output

//: [Next](@next)
