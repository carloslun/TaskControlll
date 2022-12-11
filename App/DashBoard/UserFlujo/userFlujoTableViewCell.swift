//
//  userFlujoTableViewCell.swift
//  TaskControl
//
//  Created by Carlos Luna Salazar on 10-12-22.
//

import UIKit

class userFlujoTableViewCell: UITableViewCell {

    
    @IBOutlet weak var flujoNameLabel: UILabel!
    
    @IBOutlet weak var descriptionFlujoLabel: UILabel!
    
    @IBOutlet weak var ejecutar: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(_ flujo: UserFlujo){
        flujoNameLabel.text = flujo.flujo?.flujoName ?? ""
        descriptionFlujoLabel.text = flujo.flujo?.descripcionFlujo ?? ""
        ejecutar.text = "Estado: \(flujo.flujo?.ejecutar ?? "")"
    }
    
}
