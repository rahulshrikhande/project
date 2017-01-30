//
//  DBManager.swift
//  TBS-SMS
//
//  Created by vaibhav deshpande on 27/01/17.
//  Copyright © 2017 TechnoBase IT Solutions Pvt Ltd. All rights reserved.
//

import UIKit

class DBManager: NSObject {
    
    let field_ID = "ID"
    let field_ProductID = "ProductID"
    let field_ProductTitle = "title"
    let field_ProductQuantity = "quantity"
    let field_ProductUnit = "unit"
    let field_ProductAmount = "amount"
    
    static let shared: DBManager = DBManager()
    
    let databaseFileName = "tbssms.sqlite"
    var pathToDatabase: String!
    var database: FMDatabase!
    
    override init() {
        super.init()
        let documentsDirectory = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString) as String
        pathToDatabase = documentsDirectory.appending("/\(databaseFileName)")
        //print("Path To dic: \(pathToDatabase)")
    }
    func createDatabase() -> Bool {
        var created = false
        if !FileManager.default.fileExists(atPath: pathToDatabase) {
            database = FMDatabase(path: pathToDatabase!)
            
            if database != nil {
                // Open the database.
                if database.open() {
                    let createProductsTableQuery = "create table products (\(field_ID) integer primary key autoincrement not null, \(field_ProductID) integer not null, \(field_ProductTitle) text not null, \(field_ProductQuantity) text not null, \(field_ProductUnit) text not null, \(field_ProductAmount) text not null)"
                    
                    do {
                        try database.executeUpdate(createProductsTableQuery, values: nil)
                        created = true
                    }
                    catch {
                        print("Could not create table.")
                        print(error.localizedDescription)
                    }
                    database.close()
                }
                else {
                    print("Could not open the database.")
                }
            }
        }
        print("BOOL : \(created)")
        return created
    }
    func openDatabase() -> Bool {
        if database == nil {
            if FileManager.default.fileExists(atPath: pathToDatabase) {
                database = FMDatabase(path: pathToDatabase)
            }
        }
        if database != nil {
            if database.open() {
                return true
            }
        }
        return false
    }
    func insertData(productID: Int, productTitle : String, quantity: String, unit: String, amount: String ) {
         if openDatabase() {
            let query = "insert into products (\(field_ProductID), \(field_ProductTitle), \(field_ProductQuantity), \(field_ProductUnit), \(field_ProductAmount)) values ('\(productID)', '\(productTitle)', '\(quantity)', '\(unit)', '\(amount)')"
            
            if !database.executeStatements(query) {
                print("Failed to insert initial data into the database.")
                print(database.lastError(), database.lastErrorMessage())
            }
        }
    }
    
    func loadProducts() -> [ProductInfo]! {
        var products: [ProductInfo]!
        
        if openDatabase() {
            let query = "select * from products order by \(field_ProductID) asc"
            
            do {
                let results = try database.executeQuery(query, values: nil)
               
                while results.next() {
                    let product = ProductInfo(id: Int(results.int(forColumn: field_ID)),                        
                                          product_id: Int(results.int(forColumn: field_ProductID)),
                                          product_title: results.string(forColumn: field_ProductTitle),
                                          quantity: results.string(forColumn: field_ProductQuantity),
                                          unit: results.string(forColumn: field_ProductUnit),
                                          amount: results.string(forColumn: field_ProductAmount)
                    )                    
                    if products == nil {
                        products = [ProductInfo]()
                    }
                    products.append(product)
                }
            }
            catch {
                print(error.localizedDescription)
            }
            database.close()
        }
        return products
    }
    func deleteProduct(withID ID: Int) -> Bool {
        var deleted = false
        var query = ""
        if openDatabase() {
            if ID == 0 {
                 query = "delete from products"
            } else {
                 query = "delete from products where \(field_ID)=?"
            }
            print(query)
            do {
                if ID == 0 {
                    try database.executeUpdate(query, values: nil)
                    deleted = true
                } else {
                    try database.executeUpdate(query, values: [ID])
                    deleted = true
                }
            }
            catch {
                print(error.localizedDescription)
            }
            database.close()
        }
        return deleted
    }

    
  /*  func loadMovie(withID ID: Int, completionHandler: (_ movieInfo: MovieInfo?) -> Void) {
        var movieInfo: MovieInfo!
        
        if openDatabase() {
            let query = "select * from movies where \(field_MovieID)=?"
            
            do {
                let results = try database.executeQuery(query, values: [ID])
                
                if results.next() {
                    movieInfo = MovieInfo(movieID: Int(results.int(forColumn: field_MovieID)),
                                          title: results.string(forColumn: field_MovieTitle),
                                          category: results.string(forColumn: field_MovieCategory),
                                          year: Int(results.int(forColumn: field_MovieYear)),
                                          movieURL: results.string(forColumn: field_MovieURL),
                                          coverURL: results.string(forColumn: field_MovieCoverURL),
                                          watched: results.bool(forColumn: field_MovieWatched),
                                          likes: Int(results.int(forColumn: field_MovieLikes))
                    )
                    
                }
                else {
                    print(database.lastError())
                }
            }
            catch {
                print(error.localizedDescription)
            }
            
            database.close()
        }
        
        completionHandler(movieInfo)
    }*/
 
 /*   func updateMovie(withID ID: Int, watched: Bool, likes: Int) {
        if openDatabase() {
            let query = "update movies set \(field_MovieWatched)=?, \(field_MovieLikes)=? where \(field_MovieID)=?"
            
            do {
                try database.executeUpdate(query, values: [watched, likes, ID])
            }
            catch {
                print(error.localizedDescription)
            }
            
            database.close()
        }
    }*/
}
