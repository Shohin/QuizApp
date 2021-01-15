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
    
    func test_oneCorrectOneWrongAnswers_scoresOne() {
        let score = BasicScore.score(
            for: ["correct 1", "wrong"],
            compareTo: ["correct 1", "correct 2"])
        
        XCTAssertEqual(score, 1)
    }
    
    func test_twoCorrectAnswers_scoreTwo() {
        let score = BasicScore.score(
            for: ["correct 1", "correct 2"],
            compareTo: ["correct 1", "correct 2"])
        
        XCTAssertEqual(score, 2)
    }
    
    private struct BasicScore {
        static func score(for answers: [String], compareTo correctAnswers: [String]) -> Int {
            var score = 0
            for (index, answer) in answers.enumerated() {
                score += answer == correctAnswers[index] ? 1 : 0
            }
            
            return score
        }
    }
}
