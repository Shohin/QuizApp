//
//  ScoreTests.swift
//  QuizEngineTests
//
//  Created by Shohin Tagaev on 15/01/21.
//

import Foundation
import XCTest

final class ScoreTests: XCTestCase {
    func test_noAnswers_scoresZero() {
        XCTAssertEqual(BasicScore.score(for: [], compareTo: []), 0)
    }
    
    func test_oneWrongAnswer_scoresZero() {
        XCTAssertEqual(BasicScore.score(for: ["wrong"], compareTo: ["correct"]), 0)
    }
    
    private struct BasicScore {
        static func score(for: [Any], compareTo: [Any]) -> Int {
            0
        }
    }
}
