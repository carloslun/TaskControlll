import Foundation
import UIKit

protocol MenuDelegate: AnyObject {
    func didSelect(menuItem: Menu.MenuOptions)
}

class Menu: UIViewController, UITableViewDelegate, UITableViewDataSource {
    weak var delegate: MenuDelegate?
    var countNotifications: Int?
    private let tableView: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()
    
    enum MenuOptions: String, CaseIterable {
        case home = "Home"
        case createTarea = "Crear Tarea"
        case listMyTask = "Mis Tareas"
        case userTask = "Revision Usuarios"
        case notifications = "Notificaciones"
        case logout = "Salir"
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        view.backgroundColor = .gray
        tableView.delegate = self
        tableView.dataSource = self
        view.backgroundColor = .cyan
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = CGRect(x: 0, y: view.safeAreaInsets.top, width: view.bounds.size.width, height: view.bounds.size.height)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MenuOptions.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        if MenuOptions.allCases[indexPath.row].rawValue == "Mis Notificaciones"{
            cell.textLabel?.text = MenuOptions.allCases[indexPath.row].rawValue + "\(countNotifications!)"
        }
        cell.textLabel?.text = MenuOptions.allCases[indexPath.row].rawValue
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let item = MenuOptions.allCases[indexPath.row]
        delegate?.didSelect(menuItem: item)
    }
}
