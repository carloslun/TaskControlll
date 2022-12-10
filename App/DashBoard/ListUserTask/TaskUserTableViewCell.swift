//
//  TaskUserTableViewCell.swift
//  TaskControl
//
//  Created by Carlos Luna Salazar on 30-11-22.
//

import UIKit

class TaskUserTableViewCell: UITableViewCell {

    
    
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var cantTaskLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(){
        
    }
    
}
