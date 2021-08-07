//
//  File.swift
//  
//
//  Created by Ronald on 5/8/21.
//

import Vapor

struct UsersController : RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let usersRoute = routes.grouped("api", "users")
        usersRoute.post(use: createHandler)
        usersRoute.get(use: getAllHandler)
        usersRoute.get(":userID", use: getHandler)
        usersRoute.get(":userID", "acronyms", use: getAcronymsHandler)
    }
    
    func createHandler(_ req: Request) throws -> EventLoopFuture<User.Public> {
        let user = try req.content.decode(User.self)
        user.password = try Bcrypt.hash(user.password)
        return user.save(on: req.db).map {
            user.convertToPublic()
        }
    }
    
    func getAllHandler(_ req: Request) -> EventLoopFuture<[User.Public]> {
        User.query(on: req.db).all().convertToPublic()
    }
    
    func getHandler(_ req: Request) -> EventLoopFuture<User.Public> {
        User.find(req.parameters.get("userID"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .convertToPublic()
    }
    
    func getAcronymsHandler(_ req: Request) -> EventLoopFuture<[Acronym]> {
        User.find(req.parameters.get("userID"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { user in
                user.$acronyms.get(on: req.db)
            }
    }
}
