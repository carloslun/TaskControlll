import Foundation
import UIKit
import RxSwift

class NavsViewController: UIViewController {
    
    enum MenuState {
        case opened
        case closed
    }
    var count: Int = 0 {
        didSet {
            
        }
    }
    private var menuState: MenuState = .closed
    let viewmodel = TaskViewModel()
    
    let createUser = TaskViewController()
    let home = HomeViewController()
    let menu = Menu()
    var navVC: UINavigationController?
    private var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        addChildVC()
        viewmodel.getNotifications()
        notificationsListSubscription()
    }
    
    func addChildVC(){
        // MARK: - Add here more element to subviews
        // menu
        menu.delegate = self
        addChild(menu)
        view.addSubview(menu.view)
        menu.didMove(toParent: self)
        
        // home
        home.delegate = self
        let navVC = UINavigationController(rootViewController: home)
        addChild(navVC)
        view.addSubview(navVC.view)
        navVC.didMove(toParent: self)
        self.navVC = navVC
    }
}

extension NavsViewController: HomeViewControllerDelegate {
    func didtapMenuButtom() {
        toggleMenu(completion: nil)
    }
    
    func toggleMenu(completion: (() -> Void)?){
        switch menuState {
        case .closed:
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut) {
                    self.navVC?.view.frame.origin.x = self.home.view.frame.size.width - 100
                } completion: { done in
                    if done {
                        self.menuState = .opened
                    }
                }
        case .opened:
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut) {
                self.navVC?.view.frame.origin.x = 0
            } completion: { done in
                if done {
                    self.menuState = .closed
                    DispatchQueue.main.async {
                        completion?()
                    }
                }
            }
        }
    }
}

extension  NavsViewController: MenuDelegate {
    func didSelect(menuItem: Menu.MenuOptions) {
        toggleMenu { [weak self] in
            // MARK: - Add heere more options
            switch menuItem {
            case .home:
                self?.resetHome()
            case .createTarea:
                self?.showCreateUser()
            case .listMyTask:
                self?.listMyTask()
            case .logout:
                self?.logout()
            case .userTask:
                self?.goToListTask()
        
            case .notifications:
                self?.goToNotifications()
                
            case .flujo:
                self?.goToFlow()
            }
            
        
        }
    }
    
    // MARK: - Add here more views
    func showCreateUser() {
        let vc = TaskViewController()
        home.addChild(vc)
        home.view.addSubview(vc.view)
        vc.view.frame = view.frame
        vc.didMove(toParent: home)
        home.title = "Crear Tarea"
    }
    
    func resetHome(){
        let vc = HomeViewController()
        home.addChild(vc)
        home.view.addSubview(vc.view)
        vc.view.frame = view.frame
        vc.didMove(toParent: home)
        home.title = "Home"
    }
    
    func listMyTask(){
//        let vc = ListTaskViewController()
        let vc = TaskListViewController()
//        vc.datasource = home.listMyTask
        home.addChild(vc)
        home.view.addSubview(vc.view)
        vc.view.frame = view.frame
        vc.didMove(toParent: home)
        home.title = "Mis Tarea"
    }
    
    func logout(){
        UserDefaults.standard.removeObject(forKey: "username")
        UserDefaults.standard.removeObject(forKey: "password")
        UserDefaults.standard.removeObject(forKey: "token")
        let viewController = LoginViewController()
        viewController.modalPresentationStyle = .overCurrentContext
        self.present(viewController, animated: true)
    }
    
    func goToListTask(){
        
        let vc = ListTaskUserViewController()
        home.addChild(vc)
        home.view.addSubview(vc.view)
        vc.view.frame = view.frame
        vc.didMove(toParent: home)
        home.title = "Buscar usuario"
    }
    
    func goToNotifications(){
        let vc = NotificationsViewController()
        home.addChild(vc)
        home.view.addSubview(vc.view)
        vc.view.frame = view.frame
        vc.didMove(toParent: home)
        home.title = "Mis Notificaciones"
    }

    func notificationsListSubscription(){
        viewmodel.listNotification .subscribe(onNext: { [weak self] response in
            guard let self = self else { return }
            let myNotifications = response.filter { notifications in
                notifications.idNotificado == UserContextManager.shared.id! &&
                notifications.isRead == false
            }
            
            self.menu.countNotifications = myNotifications.count
            
        }).disposed(by: disposeBag)
    }
    
    func goToFlow(){
        let vc = UserFlujoViewController()
        home.addChild(vc)
        home.view.addSubview(vc.view)
        vc.view.frame = view.frame
        vc.didMove(toParent: home)
        home.title = "Mis Flujos"
    }
}
