//
//  SuccessViewController.swift
//  TaskControl
//
//  Created by Carlos Luna Salazar on 27-11-22.
//

import UIKit

enum Status {
    case success
    case danger
    case info
}


class CongratsViewController: UIViewController {

    @IBOutlet weak var titleMessage: UILabel!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var iconCongrats: UIImageView!
    
    @IBOutlet weak var Homebtn: UIButton!
    var message = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Homebtn.backgroundColor = UIColor(hexFromString: "#b0f2c2")
        titleMessage.text = message
        iconCongrats.image = UIImage(systemName: "CongratsViewController.swift")
        iconCongrats.isHidden = false
        containerView.layer.cornerRadius = 5
        containerView.clipsToBounds = true
        
    }
    
    init(_ title: String, status: Status) {
        super.init(nibName: nil, bundle: nil)
        message = title
        setupView(status)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @IBAction func tapPressed(_ sender: Any) {
        let viewController = NavsViewController()
        viewController.modalPresentationStyle = .overCurrentContext
        self.present(viewController, animated: true)
    }
    
    private func setupView(_ status: Status){
        switch status {
        case .success:
            view.backgroundColor = UIColor(hexFromString: "#b0f2c2")
            iconCongrats.tintColor = UIColor(hexFromString: "#b0f2c2")
            iconCongrats.isHidden = false
        case .danger:
            view.backgroundColor = UIColor(hexFromString: "#ff6961")
            iconCongrats.isHidden = true
        case .info:
            view.backgroundColor = UIColor(hexFromString: "#84b6f4")
            iconCongrats.tintColor = UIColor(hexFromString: "#84b6f4")
            iconCongrats.isHidden = false
        }
    }
    

}
