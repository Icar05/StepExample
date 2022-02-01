//
//  CustomCell.swift
//  StepExample
//
//  Created by ICoon on 01.02.2022.
//

import UIKit

class CustomCell: UITableViewCell{
    
    
    
    @IBOutlet weak var labelId: UILabel!
    
    @IBOutlet weak var labelPostId: UILabel!
    
    @IBOutlet weak var labelName: UILabel!
    
    @IBOutlet weak var labelEmail: UILabel!

    @IBOutlet weak var labelDescription: UILabel!
    
    
    func setup(model: CommentModel){
        self.labelId.text = "ID: \(model.id)"
        self.labelPostId.text = "PostID: \(model.postId)"
        self.labelName.text = "Name: \(model.name)"
        self.labelEmail.text = "Email: \(model.email)"
        self.labelDescription.text = "\(model.body)"
        self.selectionStyle = .none
    }
    
}
