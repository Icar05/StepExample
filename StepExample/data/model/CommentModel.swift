//
//  CommentModel.swift
//  StepExample
//
//  Created by ICoon on 31.01.2022.
//

import Foundation

struct CommentModel: Codable{
    var postId: Int
    var id: Int
    var name: String
    var email: String
    var body: String
}
