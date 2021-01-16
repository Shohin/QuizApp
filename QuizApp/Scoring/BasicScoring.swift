//
//  BasicScoring.swift
//  QuizApp
//
//  Created by Shohin Tagaev on 16/01/21.
//

import Foundation

struct BasicScore {
    static func score<T: Equatable>(for answers: [T], compareTo correctAnswers: [T]) -> Int {
        zip(answers, correctAnswers).reduce(0) { (score, tuple) -> Int in
            score + (tuple.0 == tuple.1 ? 1 : 0)
        }
    }
}
