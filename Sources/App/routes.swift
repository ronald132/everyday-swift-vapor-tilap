import Fluent
import Vapor

func routes(_ app: Application) throws {
    
    app.get("hello") { req -> String in
        return "Hello, world!"
    }


//    //retrieve all acronyms
//    app.get("api", "acronyms") { req -> EventLoopFuture<[Acronym]> in
//        Acronym.query(on: req.db).all()
//    }

    
    let acronymsController = AcronymsController()
    try app.register(collection: acronymsController)
    
    let usersController = UsersController()
    try app.register(collection: usersController)
    
    let categoriesController = CategoriesController()
    try app.register(collection: categoriesController)
    
    let websiteController = WebsiteController()
    try app.register(collection: websiteController)
}
