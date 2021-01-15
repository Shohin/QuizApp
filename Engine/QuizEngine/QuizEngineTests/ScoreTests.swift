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
    
    func test_oneCorrectAnswer_scoresOne() {
        XCTAssertEqual(BasicScore.score(for: ["correct"], compareTo: ["correct"]), 1)
    }
    
    private struct BasicScore {
        static func score(for answers: [String], compareTo correctAnswers: [String]) -> Int {
            if answers.isEmpty { return 0 }
            return answers == correctAnswers ? 1 : 0
        }
    }
}
