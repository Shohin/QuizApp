//
//  Question.swift
//  QuizApp
//
//  Created by Shohin Tagaev on 23/12/20.
//

import Foundation

public enum Question<T: Hashable>: Hashable {
    case singleAnswer(T)
    case multipleAnswer(T)
    
    public func hash(into hasher: inout Hasher) {
        switch self {
        case .singleAnswer(let value):
            let val = "singleAnswer_\(value)"
            val.hash(into: &hasher)
        case .multipleAnswer(let value):
            let val = "multipleAnswer_\(value)"
            val.hash(into: &hasher)
        }
    }
}
