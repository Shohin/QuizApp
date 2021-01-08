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
public class Game<Question, Answer: Equatable, R: Router> where R.Question == Question, R.Answer == Answer {
    let flow: Any
    init(flow: Any) {
        self.flow = flow
    }
}

@available(*, deprecated)
public func startGame<Question, Answer: Equatable, R: Router> (questions: [Question], router: R, correctAnswers: [Question: Answer]) -> Game<Question, Answer, R> where R.Question == Question, R.Answer == Answer {
    let flow = Flow(questions: questions, delegate: QuizDelegateToRouterAdapter(router: router)) {
        scoringGame(answers: $0, correctAnswers: correctAnswers)
    }
    flow.start()
    return Game(flow: flow)
}

func scoringGame<Question, Answer: Equatable>(answers: [Question: Answer], correctAnswers: [Question: Answer]) -> Int {
    answers.reduce(0) {(score, tuple) in
        score + (correctAnswers[tuple.key] == tuple.value ? 1 : 0)
    }
}

@available(*, deprecated)
private class QuizDelegateToRouterAdapter<R: Router>: QuizDelegate {
    let router: R
    init(router: R) {
        self.router = router
    }
    
    func handle(question: R.Question, answerCallback: @escaping (R.Answer) -> Void) {
        router.routeTo(question: question, answerCallback: answerCallback)
    }
    
    func handle(result: Result<R.Question, Answer>) {
        router.routeTo(result: result)
    }
}
