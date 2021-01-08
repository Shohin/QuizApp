//
//  Quiz.swift
//  QuizEngine
//
//  Created by Shohin Tagaev on 08/01/21.
//

import Foundation

public final class Quiz {
    private let flow: Any
    init(flow: Any) {
        self.flow = flow
    }
    
    public static func start<Delegate: QuizDelegate> (questions: [Delegate.Question],
                                                      delegate: Delegate,
                                                      correctAnswers: [Delegate.Question: Delegate.Answer]
    ) -> Quiz where Delegate.Answer: Equatable {
        let flow = Flow(questions: questions,
                        delegate: delegate) {
            scoringGame(answers: $0, correctAnswers: correctAnswers)
        }
        flow.start()
        return Quiz(flow: flow)
    }
}


func scoringGame<Question, Answer: Equatable>(answers: [Question: Answer], correctAnswers: [Question: Answer]) -> Int {
    answers.reduce(0) {(score, tuple) in
        score + (correctAnswers[tuple.key] == tuple.value ? 1 : 0)
    }
}
