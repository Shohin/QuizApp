//
//  Flow.swift
//  QuizEngine
//
//  Created by Shohin Tagaev on 12/13/20.
//

import Foundation

class Flow<R: Router> {
    typealias Question = R.Question
    typealias Answer = R.Answer
    
    private let router: R
    private let questions: [Question]
    private var answers: [Question: Answer] = [:]
    private let scoring: ([Question: Answer]) -> Int
    
    init(questions: [Question], router: R, scoring: @escaping ([Question: Answer]) -> Int) {
        self.questions = questions
        self.router = router
        self.scoring = scoring
    }
    
    func start() {
        if let firstQuestion = questions.first {
            router.routeTo(question: firstQuestion, answerCallback: nextCallback(from: firstQuestion))
        } else {
            router.routeTo(result: result())
        }
    }
    
    private func nextCallback(from question: Question) -> (Answer) -> Void {
        {[weak self]  in
            self?.routeNext(question, $0)
        }
    }
    
    private func routeNext(_ question: Question,  _ answer: Answer) {
        if let curQuestionIndex = questions.firstIndex(of: question) {
            answers[question] = answer
            let nextIndex = curQuestionIndex + 1
            if nextIndex < questions.count {
                let nextQeustion = questions[nextIndex]
                router.routeTo(question: nextQeustion, answerCallback: nextCallback(from: nextQeustion))
            } else {
                router.routeTo(result: result())
            }
        }
    }
    
    private func result() -> Result<Question, Answer> {
        Result(answers: answers, score: scoring(answers))
    }
}
