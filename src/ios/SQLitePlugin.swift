import Foundation
import SQLite3

@objc(SQLitePlugin) 
class SQLitePlugin : CDVPlugin {
    
    var dbQueue: OpaquePointer!
    let SQLITE_TRANSIENT = unsafeBitCast(-1, to: sqlite3_destructor_type.self)
    
    @objc(createTableWithQuery:)
    func createTableWithQuery(command: CDVInvokedUrlCommand) {
        var pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR)
        
        dbQueue = createAndOpenDatabase()
        
        if createTable(query: String(describing: command.argument(at: 0)!)) == false {
            print("Error in Creating Tables")
            pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAs: "Error in Creating Tables")
        } else {
            print("Yes! Table Created.")
            pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAs: "Yes! Table Created.")
        }
        
        self.commandDelegate!.send(pluginResult, callbackId: command.callbackId)
    }

    @objc(insert:)
    func insert(command: CDVInvokedUrlCommand) {
        DispatchQueue.main.async {
            var pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR)
            
            let insertStatementString = String(describing: command.argument(at: 0)!)
            var insertStatementQuery: OpaquePointer?
            
            let value1 = command.arguments[1] as? Int32 ?? 0
            let value2 = command.arguments[2] as? String ?? ""
            let value3 = command.arguments[3] as? String ?? ""
            let value4 = command.arguments[4] as? String ?? ""
            let value5 = command.arguments[5] as? String ?? ""
            let value6 = command.arguments[6] as? String ?? ""
            let value7 = command.arguments[7] as? String ?? ""
            
            if sqlite3_prepare_v2(self.dbQueue, insertStatementString, -1, &insertStatementQuery, nil) == SQLITE_OK {
                
                sqlite3_bind_int(insertStatementQuery, 1, value1)
                sqlite3_bind_text(insertStatementQuery, 2, value2, -1, self.SQLITE_TRANSIENT)
                sqlite3_bind_text(insertStatementQuery, 3, value3, -1, self.SQLITE_TRANSIENT)
                sqlite3_bind_text(insertStatementQuery, 4, value4, -1, self.SQLITE_TRANSIENT)
                sqlite3_bind_text(insertStatementQuery, 5, value5, -1, self.SQLITE_TRANSIENT)
                sqlite3_bind_text(insertStatementQuery, 6, value6, -1, self.SQLITE_TRANSIENT)
                sqlite3_bind_text(insertStatementQuery, 7, value7, -1, self.SQLITE_TRANSIENT)
                
                if sqlite3_step(insertStatementQuery) == SQLITE_DONE {
                    pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAs: "Successfully Inserted the record")
                } else {
                    pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAs: "Error inserted the record")
                }
                sqlite3_finalize(insertStatementQuery)
            }
            self.commandDelegate!.send(pluginResult, callbackId: command.callbackId)
        }
    }
    
    func createAndOpenDatabase() -> OpaquePointer? {
        var db: OpaquePointer?
        
        // Sets up the URL to the Database
        let url = NSURL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String)
        
        // Name your database here
        if let pathComponent = url.appendingPathComponent("TEST.sqlite"){
            
            let filePath = pathComponent.path
            
            if sqlite3_open(filePath, &db) == SQLITE_OK {
                print("Successfully opened the database :) at \(filePath)")
                return db
            } else {
                print("Could not open the database")
            }
        } else {
            print("File Path is not available.")
        }
        
        return db
    }
    
    func createTable(query: String) -> Bool {
        var bRetVal: Bool = false
        let createTable = sqlite3_exec(dbQueue, query, nil, nil, nil)
        
        if createTable != SQLITE_OK {
            print("Not able to create table")
            bRetVal = false
        } else {
            bRetVal = true
        }
        return bRetVal
    }
    
}
