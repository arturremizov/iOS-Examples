//: [Previous](@previous)
import SwiftUI
import Observation


//MARK: - @Observable with ObservableObject protocol
@Observable
final class Store: ObservableObject {
    var name = ""
    var age = 0
    
    init(name: String = "", age: Int = 0) {
        self.name = name
        self.age = age
        observeProperties()
    }
    
    private func observeProperties() {
        withObservationTracking {
            let _ = name
            let _ = age
        } onChange: { [weak self] in
            guard let self else { return }
            objectWillChange.send()
            observeProperties()
        }
    }
}
//: [Next](@next)
