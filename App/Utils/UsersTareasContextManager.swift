import Foundation

class UsersTareasContextManager: NSObject {
    private static var instance: UsersTareasContextManager?
    
    class var shared: UsersTareasContextManager {
        guard let instance = self.instance else {
            let instance = UsersTareasContextManager()
            self.instance = instance
            return instance
        }
        return instance
    }
    
    class func destroy() {
         instance = nil
    }
    
    var userTarea: [UserTarea]?
    
}

