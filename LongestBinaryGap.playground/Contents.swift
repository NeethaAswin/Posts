import UIKit

public func longestBinaryGap(_ n: Int) -> Int {
    var bitPositions: [Int] = []
    let binaryRepr = String(n, radix: 2)
    
    for(index, char) in binaryRepr.enumerated() where char == "1" {
        bitPositions.append(index)
    }
    var longestGap: Int = 0
    if bitPositions.count >= 2 {
        for i in 0...bitPositions.count - 2 {
            let gap = bitPositions[i+1] - bitPositions[i] - 1
            if gap > longestGap {
                longestGap = gap
            }
        }
    }
    return longestGap
}

longestBinaryGap(1041)
