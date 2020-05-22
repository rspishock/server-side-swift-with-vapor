import Vapor
import Foundation

/// Register your application's routes here.
public func routes(_ router: Router) throws {
    // Basic "It works" example
    router.get { req in
        return "It works!"
    }
    
    // Basic "Hello, world!" example
    router.get("hello") { req in
        return "Hello, world!"
    }
    
    router.get("hello", "vapor") { req in
        return "Hello Vapor!"
    }
    
    router.get("hello", String.parameter) { req -> String in
        let name = try req.parameters.next(String.self)
        return "Hello \(name)!"
    }
    
    router.post("info") { req -> InfoResponse in
        let data = try req.content.syncDecode(InfoData.self)
//        return "Hello, \(data.name)!"
        return InfoResponse(request: data)
    }
    
    // returns current date
    router.get("date") { req in
        return "\(Date())"  // from Foundation
    }
    
    // returns count in JSON
    router.get("counter", Int.parameter) { req -> CountJSON in
        let count = try req.parameters.next(Int.self)
        return CountJSON(count: count)
    }
    
    // returns user name and age in JSON
    router.post("user-info") { req -> String in
        let userInfo = try req.content.syncDecode(UserInfoData.self)
        return "Hello \(userInfo.name), you are \(userInfo.age)!"
    }

    // Example of configuring a controller
    let todoController = TodoController()
    router.get("todos", use: todoController.index)
    router.post("todos", use: todoController.create)
    router.delete("todos", Todo.parameter, use: todoController.delete)
}

struct InfoData: Content {
    let name: String
}

struct InfoResponse: Content {
    let request: InfoData
}


// returns count as JSON  conforms to Content
struct CountJSON: Content {
    let count: Int
}

struct UserInfoData: Content {
    let age: Int
    let name: String
}
