//
//  Game.swift
//  QuizEngine
//
//  Created by Shohin Tagaev on 12/18/20.
//

import Foundation

@available(*, deprecated)
public protocol Router {
    associatedtype Question: Hashable
    associatedtype Answer
    
    func routeTo(question: Question, answerCallback: @escaping (Answer) -> Void)
    func routeTo(result: Result<Question, Answer>)
}

@available(*, deprecated)
public struct Result<Question: Hashable, Answer> {
    public let answers: [Question: Answer]
    public let score: Int
}

@available(*, deprecated)
public class Game<Question, Answer: Equatable, R: Router> where R.Question == Question, R.Answer == Answer {
    let flow: Any
    init(flow: Any) {
        self.flow = flow
    }
}

@available(*, deprecated)
public func startGame<Question, Answer: Equatable, R: Router> (questions: [Question], router: R, correctAnswers: [Question: Answer]) -> Game<Question, Answer, R> where R.Question == Question, R.Answer == Answer {
    let flow = Flow(questions: questions, delegate: QuizDelegateToRouterAdapter(router: router, correctAnswers: correctAnswers))
    flow.start()
    return Game(flow: flow)
}

@available(*, deprecated)
private class QuizDelegateToRouterAdapter<R: Router>: QuizDelegate where R.Answer: Equatable {
    let router: R
    let correctAnswers: [R.Question: R.Answer]
    init(router: R, correctAnswers: [R.Question: R.Answer]) {
        self.router = router
        self.correctAnswers = correctAnswers
    }
    
    func answer(for question: R.Question, completion: @escaping (R.Answer) -> Void) {
        router.routeTo(question: question, answerCallback: completion)
    }
    
    func didCompleteQuiz(withAnswers answers: [(question: R.Question, answer: R.Answer)]) {
        let answersDict = answers.reduce([R.Question: R.Answer]()) { (acc, tuple) in
            var acc = acc
            acc[tuple.question] = tuple.answer
            return acc
        }
        let result = Result(answers: answersDict, score: scoringGame(answers: answersDict, correctAnswers: correctAnswers))
        router.routeTo(result: result)
    }
    
    private func scoringGame<Question, Answer: Equatable>(answers: [Question: Answer], correctAnswers: [Question: Answer]) -> Int {
        answers.reduce(0) {(score, tuple) in
            score + (correctAnswers[tuple.key] == tuple.value ? 1 : 0)
        }
    }
}
