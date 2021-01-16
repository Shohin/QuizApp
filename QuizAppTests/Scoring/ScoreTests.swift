//
//  ScoreTests.swift
//  QuizEngineTests
//
//  Created by Shohin Tagaev on 15/01/21.
//

import Foundation
import XCTest
@testable import QuizApp

final class ScoreTests: XCTestCase {
    func test_noAnswers_scoresZero() {
        XCTAssertEqual(BasicScore.score(for: [String](), compareTo: [String]()), 0)
    }
    
    func test_oneNotMatchingAnswer_scoresZero() {
        XCTAssertEqual(BasicScore.score(for: ["not a match"], compareTo: ["an answer"]), 0)
    }
    
    func test_oneMatchingAnswer_scoresOne() {
        XCTAssertEqual(BasicScore.score(for: ["an answer"], compareTo: ["an answer"]), 1)
    }
    
    func test_oneMatchingOneNotMatchingAnswers_scoresOne() {
        let score = BasicScore.score(
            for: ["an answer", "not a match"],
            compareTo: ["an answer", "another answer"])
        
        XCTAssertEqual(score, 1)
    }
    
    func test_twoMatchingAnswers_scoreTwo() {
        let score = BasicScore.score(
            for: ["an answer", "another answer"],
            compareTo: ["an answer", "another answer"])
        
        XCTAssertEqual(score, 2)
    }
    
    func test_withTooManyAnswers_twoMatchingAnswers_scoreTwo() {
        let score = BasicScore.score(
            for: ["an answer", "another answer", "an exrta answer"],
            compareTo: ["an answer", "another answer"])
        
        XCTAssertEqual(score, 2)
    }
    
    func test_withTooManyCorrectAnswers_oneMatchingAnswers_scoreOne() {
        let score = BasicScore.score(
            for: ["not a match", "another answer"],
            compareTo: ["an answer", "another answer", "an exrta answer"])
        
        XCTAssertEqual(score, 1)
    }
}
