//
//  File.swift
//  
//
//  Created by Ronald on 5/8/21.
//

import Fluent

struct CreateUser : Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        database.schema("users")
            .id()
            .field("name", .string, .required)
            .field("username", .string, .required)
            .unique(on: "username")
            .create()
    }
    
    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema("users").delete()
    }
}
