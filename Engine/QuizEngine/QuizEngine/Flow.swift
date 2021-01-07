//
//  Flow.swift
//  QuizEngine
//
//  Created by Shohin Tagaev on 12/13/20.
//

import Foundation

class Flow<Delegate: QuizDelegate> {
    typealias Question = Delegate.Question
    typealias Answer = Delegate.Answer
    
    private let delegate: Delegate
    private let questions: [Question]
    private var answers: [Question: Answer] = [:]
    private let scoring: ([Question: Answer]) -> Int
    
    init(questions: [Question], delegate: Delegate, scoring: @escaping ([Question: Answer]) -> Int) {
        self.questions = questions
        self.delegate = delegate
        self.scoring = scoring
    }
    
    func start() {
        delegateQuestionHandling(at: questions.startIndex)
    }
    
    private func delegateQuestionHandling(at index: Int) {
        if let firstQuestion = questions.first {
            delegate.handle(question: firstQuestion, answerCallback: nextCallback(from: firstQuestion))
        } else {
            delegate.handle(result: result())
        }
    }
    
    private func nextCallback(from question: Question) -> (Answer) -> Void {
        {[weak self]  in
            self?.delegateQuestionHandling(question, $0)
        }
    }
    
    private func delegateQuestionHandling(_ question: Question,  _ answer: Answer) {
        if let curQuestionIndex = questions.firstIndex(of: question) {
            answers[question] = answer
            let nextIndex = curQuestionIndex + 1
            if nextIndex < questions.count {
                let nextQeustion = questions[nextIndex]
                delegate.handle(question: nextQeustion, answerCallback: nextCallback(from: nextQeustion))
            } else {
                delegate.handle(result: result())
            }
        }
    }
    
    private func result() -> Result<Question, Answer> {
        Result(answers: answers, score: scoring(answers))
    }
}
