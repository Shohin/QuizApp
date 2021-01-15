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
        let score = BasicScore.score(for: [])
        XCTAssertEqual(score, 0)
    }
    
    private struct BasicScore {
        static func score(for: [Any]) -> Int {
            0
        }
    }
}
