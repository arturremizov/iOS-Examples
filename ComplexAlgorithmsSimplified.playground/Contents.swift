enum Gender {
    case male
    case female
}

struct Student {
    let id: String
    let name: String
    let gender: Gender
    let age: Int
}

let students = [
    Student(id: "001", name: "Jessica", gender: .female, age: 20),
    Student(id: "002", name: "James", gender: .male, age: 25),
    Student(id: "003", name: "Mary", gender: .female, age: 19),
    Student(id: "004", name: "Edwin", gender: .male, age: 27),
    Student(id: "005", name: "Stacy", gender: .female, age: 18),
    Student(id: "006", name: "Emma", gender: .female, age: 22),
]


// MARK: Grouping Array Elements by Criteria
//let groupByFirstLetter = Dictionary(grouping: students, by: { $0.name.first! })
let groupByFirstLetter = Dictionary(grouping: students, by: \.name.first!)


// MARK: Counting Occurrence of Array Elements
//let groupByGender = Dictionary(grouping: students, by: \.gender)
//
//let femaleCount = groupByGender[.female]?.count
//let maleCount = groupByGender[.male]?.count


let genderCount = students.reduce(into: [Gender: Int]()) { partialResult, student in
    partialResult[student.gender, default: 0] += 1
}

let femaleCount = genderCount[.female]
let maleCount = genderCount[.male]


// MARK: Getting the Sum of an Array
let sum = students.reduce(0, { $0 + $1.age })

let sum1 = [2, 3, 4].reduce(0, +)
let sum2 = [5.5, 10.7, 9.43].reduce(0, +)
let sum3 = ["a", "b", "c"].reduce("", +)


// MARK: Accessing Array Elements by ID
let studentsTuple = students.map { ($0.id, $0) }
let studentsDictionary = Dictionary(uniqueKeysWithValues: studentsTuple)

let emma = studentsDictionary["006"]


// MARK: Getting a Number of Random Elements From An Array
let randomized = students.shuffled()
let selected = randomized.prefix(3)
