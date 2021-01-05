//
//  Result.swift
//  QuizEngine
//
//  Created by Shohin Tagaev on 12/18/20.
//

import Foundation

public struct Result<Question: Hashable, Answer> {
    public let answers: [Question: Answer]
    public let score: Int
}
