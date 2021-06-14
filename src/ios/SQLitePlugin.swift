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
        var pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR)
        
        let insertStatementString = String(describing: command.argument(at: 0)!)
        var insertStatementQuery: OpaquePointer?
        
        DispatchQueue.main.async {
            if sqlite3_prepare_v2(self.dbQueue, insertStatementString, -1, &insertStatementQuery, nil) == SQLITE_OK {

                sqlite3_bind_int(insertStatementQuery, 1, command.argument(at: 1)! as! Int32)
                sqlite3_bind_text(insertStatementQuery, 2, String(describing: command.argument(at: 2)!), -1, self.SQLITE_TRANSIENT)
                sqlite3_bind_text(insertStatementQuery, 3, String(describing: command.argument(at: 3)!), -1, self.SQLITE_TRANSIENT)
                sqlite3_bind_text(insertStatementQuery, 4, String(describing: command.argument(at: 4)!), -1, self.SQLITE_TRANSIENT)
                sqlite3_bind_text(insertStatementQuery, 5, String(describing: command.argument(at: 5)!), -1, self.SQLITE_TRANSIENT)
                sqlite3_bind_text(insertStatementQuery, 6, String(describing: command.argument(at: 6)!), -1, self.SQLITE_TRANSIENT)
                sqlite3_bind_text(insertStatementQuery, 7, String(describing: command.argument(at: 7)!), -1, self.SQLITE_TRANSIENT)
                sqlite3_bind_text(insertStatementQuery, 8, String(describing: command.argument(at: 8)!), -1, self.SQLITE_TRANSIENT)
                if sqlite3_step(insertStatementQuery) == SQLITE_DONE {
                    print("Successfully Inserted the record")
                    pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAs: "Successfully Inserted the record")
                } else {
                    print("Error")
                    pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAs: "Error")
                }

                sqlite3_finalize(insertStatementQuery)
            }
        }
        
        self.commandDelegate!.send(pluginResult, callbackId: command.callbackId)
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
