//
//  Extensions.swift
//  batIdent2
//
//  Created by Volker Runkel on 02.06.23.
//

import Foundation

extension Array {
    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
}

extension String {
    /// stringToFind must be at least 1 character.
    func countInstances(of stringToFind: String) -> Int {
        assert(!stringToFind.isEmpty)
        var count = 0
        var searchRange: Range<String.Index>?
        while let foundRange = range(of: stringToFind, options: [], range: searchRange) {
            count += 1
            searchRange = Range(uncheckedBounds: (lower: foundRange.upperBound, upper: endIndex))
        }
        return count
    }
    
    func determineColumnSeparator() -> String? {
        let numberOfSemi = self.countInstances(of: ";")
        let numberOfTab = self.countInstances(of: "\t")
        let numberOfComma = self.countInstances(of: ",")
        let max = [numberOfTab, numberOfSemi, numberOfComma].max()
        if max == numberOfTab {
            return "\t"
        }
        if max == numberOfSemi {
            return ";"
        }
        if max == numberOfComma {
            return ","
        }
        return nil
    }
    
    func determineDecimalSeparator() -> String? {
        let numberOfDots = self.countInstances(of: ".")
        let numberOfComma = self.countInstances(of: ",")
        let max = [numberOfDots, numberOfComma].max()
        if max == 0 {
            return nil
        }
        else if max == numberOfDots {
            return "."
        }
        else {
            return ","
        }
    }
    
}
