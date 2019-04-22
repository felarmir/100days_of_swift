import UIKit

let name = "Taylor"

for letter in name {
    print("Give me a \(letter)!")
}

//print(name[0])
let letter = name.index(name.startIndex, offsetBy: 3)
extension String {
    subscript(i: Int) -> String {
        return String(self[index(startIndex, offsetBy: i)])
    }
}

let letter2 = name[2]

if !name.isEmpty {
    print(name.count)
}

let pass = "123456"
pass.hasPrefix("123")
pass.hasSuffix("456")

extension String {
    func deletingPrefix(_ prefix: String) -> String {
        guard self.hasPrefix(prefix) else { return self }
        return String(self.dropFirst(prefix.count))
    }
    
    func deleteSufix(_ suffix: String) -> String {
        guard self.hasSuffix(suffix) else { return self}
        return String(self.dropLast(suffix.count))
    }
}

pass.deleteSufix("456")


let weather = "it's going to rain"
print(weather.capitalized)


extension String {
    var capitalizedFirst: String {
        guard let firstLater = self.first else { return "" }
        return firstLater.uppercased() + self.dropFirst()
    }
}

weather.capitalizedFirst


let input = "Swift is like Objective-C without the C"
input.contains("Swift")

let langs = ["Python", "Ruby", "Swift"]
langs.contains("Swift")

extension String {
    func containsAny(of array: [String]) -> Bool {
        for item in array {
            if self.contains(item) {
                return true
            }
        }
        return false
    }
}

input.containsAny(of: langs)


langs.contains(where: input.contains)

// attribute

let string = "This is a test string"
let attributes: [NSAttributedString.Key: Any] = [
    .foregroundColor: UIColor.white,
    .backgroundColor: UIColor.gray,
    .font: UIFont.boldSystemFont(ofSize: 36.0)
]

let attrString = NSAttributedString(string: string, attributes: attributes)

let attrString2 = NSMutableAttributedString(string: string)
attrString2.addAttribute(.font, value: UIFont.systemFont(ofSize: 8), range: NSRange(location: 0, length: 4))
attrString2.addAttribute(.font, value: UIFont.systemFont(ofSize: 16), range: NSRange(location: 5, length: 2))
attrString2.addAttribute(.font, value: UIFont.systemFont(ofSize: 24), range: NSRange(location: 8, length: 1))
attrString2.addAttribute(.font, value: UIFont.systemFont(ofSize: 32), range: NSRange(location: 10, length: 4))
attrString2.addAttribute(.font, value: UIFont.systemFont(ofSize: 40), range: NSRange(location: 15, length: 6))


//chalange 
extension String {
    func withPrefix(_ prefix: String) -> String {
        if self.hasPrefix(prefix) {
            return self
        } else {
            return prefix+self
        }
    }
}

"pet".withPrefix("car")


extension String {
    func isNumeric() -> Bool {
        for l in self {
            if let _ = Int("\(l)") {
                return true
            }
        }
        return false
    }
}

"den".isNumeric()
"den387".isNumeric()
extension String {
    var lines: [String] {
        return self.components(separatedBy: "\n")
    }
}

let ln = "Denis \n iOS \n Developer".lines
print(ln)
