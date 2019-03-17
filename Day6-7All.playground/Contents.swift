import UIKit


let fruits = ["banana", "orange", "apple"]

//======================================================
let driver = {
    print("Denis")
}

func loadDriver(driver: () -> Void) {
    print("Car Koleos")
    print("Driver: ")
    driver()
    print("Start Engine")
}

loadDriver(driver: driver)

//======================================================
loadDriver {
    print("Denis Andreev")
}

//======================================================

func saladMake() -> ([String]) -> Void {
    return {
        for f in $0 {
            print("Add \(f)")
        }
    }
}

let maker = saladMake()
maker(fruits)
//======================================================

func getFruit() -> ([String]) -> String {
    return {
        return $0.last!
    }
}

let fruit = getFruit()
print(fruit(fruits))

//=====================================================

let newFruit = fruits.sorted(by: {$0 < $1})
print(newFruit)

//=====================================================

func juseMaker(vlume: Int, ingradients: ([String]) -> Void) {
    print("Start making...")
    ingradients(fruits)
    print("End")
}

juseMaker(vlume: 10) {
    for fr in $0 {
        print("frsh \(fr)")
    }
}

