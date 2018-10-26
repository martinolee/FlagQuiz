//
//  File.swift
//  FlagQuiz
//
//  Created by 이수한 on 2018. 3. 18..
//  Copyright © 2018년 이수한. All rights reserved.
//

import Foundation

struct Quiz {
    var example: Array<Int>
    var correctAnswerIndex: Int
}

struct FlagInfo: Hashable {
    var name: String
    var imageName: String
    var GDP: Int
    var area: Int
}

var flagInfo = Array<FlagInfo>()
