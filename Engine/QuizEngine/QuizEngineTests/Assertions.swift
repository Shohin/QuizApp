//
//  Assertions.swift
//  QuizEngineTests
//
//  Created by Shohin Tagaev on 14/01/21.
//

import Foundation
import XCTest

func assertEqueal(_ a1: [(String, String)], _ a2: [(String, String)], file: StaticString = #filePath, line: UInt = #line) {
    XCTAssertTrue(a1.elementsEqual(a2, by: ==), "\(a1) is not equal to: \(a2)", file: file, line: line)
}
