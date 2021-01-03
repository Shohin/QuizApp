//
//  ResultHelper.swift
//  QuizAppTests
//
//  Created by Shohin Tagaev on 24/12/20.
//

@testable import QuizEngine

extension Result: Hashable {
    static func make(answers: [Question: Answer] = [:], score: Int = 0) -> Result<Question, Answer> {
        Result(answers: answers, score: score)
    }
    
    public var hashValue: Int {
        1
    }
    
    public func hash(into hasher: inout Hasher) {
        
    }
    
    public static func == (lhs: Result<Question, Answer>, rhs: Result<Question, Answer>) -> Bool {
        lhs.score == rhs.score
    }
}
