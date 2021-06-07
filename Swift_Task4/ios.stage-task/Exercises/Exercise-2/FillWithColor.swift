import Foundation

final class FillWithColor {
    
    var result: [[Int]] = [[]]
    var image: [[Int]] = [[]]
    var newColor: Int = 0
    var oldColor: Int = 0
    var rowCount: Int = 0
    var columnCount: Int = 0
    
    func fillWithColor(_ image: [[Int]], _ row: Int, _ column: Int, _ newColor: Int) -> [[Int]] {
        
        self.result = image
        self.image = image
        
        self.newColor = newColor
        self.oldColor = image[row][column]
        self.rowCount = image.count
        self.columnCount = image[0].count
        
        makeFill(n: row, m: column, image: self.image, compare: self.oldColor, result: self.result, newColor: newColor)
        
        
        return self.result
        
//        [[]]
    }
    
    func makeFill(n: Int, m: Int, image: [[Int]], compare: Int, result: [[Int]], newColor: Int) {
        
        if (n >= 0 && n < self.rowCount) && (m >= 0 && m < self.image[n].count) && (self.result[n][m] != newColor) {
            if image[n][m] == compare {
                self.result[n][m] = newColor
                makeFill(n: n - 1, m: m, image: image, compare: self.oldColor, result: self.result, newColor: newColor)
                makeFill(n: n + 1, m: m, image: image, compare: self.oldColor, result: self.result, newColor: newColor)
                makeFill(n: n, m: m - 1, image: image, compare: self.oldColor, result: self.result, newColor: newColor)
                makeFill(n: n, m: m + 1, image: image, compare: self.oldColor, result: self.result, newColor: newColor)
            }
        } else {
            return
        }

    }
    
    // Рукурсивно рассмитриваем эти кейсы
    //    makeFill(n: n - 1, m: m)
    //    makeFill(n: n + 1, m: m)
    //    makeFill(n: n, m: m - 1)
    //    makeFill(n: n, m: m + 1)
    
    // Относительно каждого m и n
    
    // Попробовть достучаться к значениям матрицы через опционалы что бы не выходить
    // за границы массива
    
    
}
