protocol Shape {}
struct Circle: Shape {}
struct Triangle: Shape {}

var userShapes: [Shape] = []
func userDidCreate(shape: Shape) {
    userShapes.append(shape)
}
userDidCreate(shape: Circle())
userDidCreate(shape: Triangle())


protocol Sequence {
    associatedtype Element
}
//var sequences: [Sequence] = [] // Can't do

/// Before Swift 5.7
class AnySequence {
    let value: Any
    init<T: Sequence>(_ sequence: T) {
        self.value = sequence
    }
}

/// After Swift 5.7
struct MyConcreteSequenceType: Sequence {
    typealias Element = Int
}

let erased: any Sequence = MyConcreteSequenceType()

// MARK: - Type safety of "any"
protocol Animal {
    associatedtype Food
    func eat(_ food: Food)
}

protocol FoodProvider {
    func getFood<T: Animal>(for animal: T) -> T.Food
}

func feedAll(_ animals: [any Animal], provider: FoodProvider) {
    animals.forEach { animal in
//        let food = provider.getFood(for: animal)
//        animal.eat(food)
        feed(animal, provider: provider)
    }
}

func feed<T: Animal>(_ animal: T, provider: FoodProvider) {
    let food = provider.getFood(for: animal)
    animal.eat(food)
}

// MARK: - Supporting Features

// MARK: Opaque Parameters
// func feed<T: Animal>(_ animal: T)
func feed(_ animal: some Animal) {}

// MARK: Primary Associated Types
protocol Sequence2<Element> {
    associatedtype Element
    associatedtype Iterator
}

//extension Sequence2 where Element == Int {
//    func grabSomeNumbers() {}
//}
// or
//func grabSomeNumbers<T: Sequence2>(_ s: T) where T.Element == Int { }

extension Sequence2<Int> {
    func grabSomeNumbers() {}
}
// or
func grabSomeNumbers(_ s: any Sequence2<Int>) { }
