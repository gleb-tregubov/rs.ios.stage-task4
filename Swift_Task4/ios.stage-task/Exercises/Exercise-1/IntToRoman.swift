import Foundation

public extension Int {
    
    var roman: String? {
        
        if self < 0 {
            return nil
        }
        
        let edges = [(1000, "M"),
                     (900, "CM"),
                     (500, "D"),
                     (400, "CD"),
                     (100, "C"),
                     (90, "XC"),
                     (50, "L"),
                     (40, "XL"),
                     (10, "X"),
                     (9, "IX"),
                     (5, "V"),
                     (4, "IV"),
                     (1, "I")]
        var result = ""
        
        var inputNum = self
        
        edges.forEach {
            let (edgeNum, edgeSymbol) = $0
            let numberOfSymbols = inputNum / edgeNum;
            result += String(repeating: edgeSymbol, count: numberOfSymbols)
            inputNum %= edgeNum
        }
        
        return !result.isEmpty ? result : nil
    }
}
