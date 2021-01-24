//
//  Game.swift
//  QuizEngine
//
//  Created by Shohin Tagaev on 12/18/20.
//

import Foundation

@available(*, deprecated, message: "Use QuizDelegate instead")
public protocol Router {
    associatedtype Question: Hashable
    associatedtype Answer
    
    func routeTo(question: Question, answerCallback: @escaping (Answer) -> Void)
    func routeTo(result: Result<Question, Answer>)
}

@available(*, deprecated, message: "Scroing is not supported in the future")
public struct Result<Question: Hashable, Answer> {
    public let answers: [Question: Answer]
    public let score: Int
}

@available(*, deprecated, message: "Use Quiz instead")
public class Game<Question, Answer: Equatable, R: Router> where R.Question == Question, R.Answer == Answer {
    let quiz: Quiz
    init(quiz: Quiz) {
        self.quiz = quiz
    }
}

@available(*, deprecated, message: "Use Quiz.start instead")
public func startGame<Question, Answer: Equatable, R: Router> (questions: [Question], router: R, correctAnswers: [Question: Answer]) -> Game<Question, Answer, R> where R.Question == Question, R.Answer == Answer {
    let adapter = QuizDelegateToRouterAdapter(router: router, correctAnswers: correctAnswers)
    let quiz = Quiz.start(questions: questions, delegate: adapter)
    return Game(quiz: quiz)
}

@available(*, deprecated, message: "Remove along with the deprecated Game types")
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
