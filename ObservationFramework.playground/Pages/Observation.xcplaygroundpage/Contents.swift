import SwiftUI
import Observation

//MARK: - ObservableObject protocol
class Store: ObservableObject {
    @Published var firstName: String
    @Published var lastName: String
    var fullName: String {
        firstName + " " + lastName
    }
    @Published private var count: Int = 0
    
    init(firstName: String, lastName: String, count: Int) {
        self.firstName = firstName
        self.lastName = lastName
        self.count = count
    }
}

//MARK: - Using the Observation framework
@Observable
class Store2 {
    var firstName: String = "Yang"
    var lastName: String = "Xu"
    var fullName: String {
        firstName + " " + lastName
    }
    /// count property cannot be observed
    @ObservationIgnored
    var count: Int = 0
    
//    init(firstName: String, lastName: String, count: Int) {
//        self.firstName = firstName
//        self.lastName = lastName
//        self.count = count
//    }
}

//MARK: - Declaring Observable Objects in Views
struct ContentView: View {
    @State var store = Store2()
    var body: some View {
        EmptyView()
    }
}

//MARK: - Injecting Observable Objects into the View Hierarchy Using Environment
//MARK: 1: Injecting instances through environment
struct ObservationTestApp: App {
    @State var store = Store2()
    var body: some Scene {
        WindowGroup {
            ContentView2()
                .environment(store)
        }
    }
}

struct ContentView2: View {
    @Environment(Store2.self) var store /// Inject through environment in view
    var body: some View {
        EmptyView()
    }
}

//MARK: 2: Customize EnvironmentKey
struct StoreKey: EnvironmentKey {
    static var defaultValue = Store2()
}

extension EnvironmentValues {
    var store: Store2 {
        get { self[StoreKey.self] }
        set { self[StoreKey.self] = newValue }
    }
}

struct ContentView3: View {
    @Environment(\.store) var store /// Inject through environment in view
    var body: some View {
        EmptyView()
    }
}

//MARK: 3. Inject optional values
struct ObservationTestApp2: App {
    @State var store = Store2()
    var body: some Scene {
        WindowGroup {
            ContentView2()
                .environment(store)
        }
    }
}
struct ContentView4: View {
    @Environment(Store2.self) var store: Store2? /// Inject through environment in view
    var body: some View {
        if let firstName = store?.firstName {
            Text(firstName)
        }
    }
}

//MARK: - Passing Observable Objects in Views
struct ContentView5: View {
    @State var store = Store2()
    var body: some View {
        SubView(store: store)
    }
}

struct SubView: View {
    let store: Store2
    var body: some View {
        EmptyView()
    }
}

//MARK: - Creating a Binding Type
struct ContentView6: View {
    @State var store = Store2()
    var body: some View {
        SubView(store: store)
    }
}
//MARK: Method One:
struct SubView2: View {
    @Bindable var store: Store2
    var body: some View {
        TextField("", text: $store.firstName)
    }
}
//MARK: Method Two:
struct SubView3: View {
    var store: Store2
    var body: some View {
        @Bindable var store = store
        TextField("", text: $store.firstName)
    }
}
//MARK: Method Three:
struct SubView4: View {
    var store: Store2
    var firstName: Binding<String> {
        .init(get: { store.firstName }, set: { store.firstName = $0 })
    }
    var body: some View {
        TextField("", text: firstName)
    }
}

//: [Next](@next)
