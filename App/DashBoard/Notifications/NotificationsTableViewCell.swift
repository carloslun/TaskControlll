//
//  NotificationsTableViewCell.swift
//  TaskControl
//
//  Created by Carlos Luna Salazar on 03-12-22.
//

import UIKit

class NotificationsTableViewCell: UITableViewCell {

    @IBOutlet weak var dateCell: UILabel!
    @IBOutlet weak var descriptionCell: UILabel!
    @IBOutlet weak var titleCell: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(model: NotificationsModel){
        dateCell.text = model.fechaCreacion
        descriptionCell.text = model.mensaje
        titleCell.text = "Notification #\(model.id)"
    }
    
}
