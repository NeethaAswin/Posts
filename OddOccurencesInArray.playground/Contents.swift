import UIKit

public func solution(_ A: inout [Int]) -> Int {
    if A.count == 1 { return A[0] }
    
    var inputElementOccurenceCountDict = [Int:Int]()
    for element in A {
        if let count = inputElementOccurenceCountDict[element] {
            inputElementOccurenceCountDict[element] = count + 1
        } else {
            inputElementOccurenceCountDict[element] = 1
        }
    }
    
    let solution = inputElementOccurenceCountDict.first { (_,count) -> Bool in
        return count%2 != 0 }
    return solution!.key
}

var arr = [1,1,2,2,3,4,4,5,5]
solution(&arr)

//Time complexity O(N) or O(NlogN)
