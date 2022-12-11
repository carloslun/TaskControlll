//
//  UserFlujoViewController.swift
//  TaskControl
//
//  Created by Carlos Luna Salazar on 10-12-22.
//

import UIKit
import RxSwift

class UserFlujoViewController: UIViewController, UITableViewDataSource , UITableViewDelegate{
    

    @IBOutlet weak var tableviewFlujo: UITableView!
    
    let viewmodel = TaskViewModel()
    var listMyflow = [UserFlujo]()
    
    
    private var disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()

        tableviewFlujo.register(UINib(nibName: "userFlujoTableViewCell", bundle: nil), forCellReuseIdentifier: "userFlujoTableViewCell")
        tableviewFlujo.dataSource = self
        tableviewFlujo.delegate = self
        
        getFlowByMyUserSubscriptions()
        
        viewmodel.getFlowByMyUser()
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        listMyflow.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var entitie = listMyflow[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "userFlujoTableViewCell", for: indexPath) as! userFlujoTableViewCell
        cell.configure(entitie)
        return cell
    }
    

}


extension UserFlujoViewController {
    func getFlowByMyUserSubscriptions(){
        
        viewmodel.myFlow.subscribe(onNext: { [weak self] flujo in
            self?.listMyflow = flujo
            self?.tableviewFlujo.reloadData()
        }).disposed(by: disposeBag)
        
    }
    
}
