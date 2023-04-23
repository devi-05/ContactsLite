//
//  DatabaseDelegator.swift
//  sqliteTutorial
//
//  Created by devi-pt6261 on 25/03/23.
//

import Foundation
import SQLite3
struct DatabaseManager{
    
    static var shared:DatabaseManager = DatabaseManager()
    private init(){}
    
    var database:OpaquePointer?
    
    
    mutating func createDb(location:FileManager.SearchPathDirectory,path:String){
        
        let filePath = try! FileManager.default.url(for: location, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent(path)
        print(filePath)
        
        var db:OpaquePointer?=nil
        
        if sqlite3_open(filePath.path,&db) != SQLITE_OK{
            print("DB Not Created!")
            database =  db
        }
        else {
            print("DB created!")
            database =  db
        }
        
    }
    
    
    func commonCreateTableFunc(query:String,tableName:String){
        var statement:OpaquePointer? = nil
        if sqlite3_prepare_v2(database, query, -1, &statement, nil) == SQLITE_OK {
            if sqlite3_step(statement) == SQLITE_DONE {
                print("\(tableName) Table created!")
            }
            else {
                print("\(tableName) Table Not created!")
            }
        }
        else {
            print(String(cString: sqlite3_errmsg(DatabaseManager.shared.database)))
            print("\(tableName) creation preparation failed!")
        }
        sqlite3_finalize(statement)
    }
    func createTable(tableName:String,columns:[String:String]){
        var statement:OpaquePointer? = nil
        
        var empty:[String] = []
    
        for i in columns.keys{
            var emptyStr = ""
            emptyStr+=i+" "+columns[i]!
            empty.append(emptyStr)
        }
        
        let columnStr = empty.joined(separator: ",")
        
        let query = "CREATE TABLE IF NOT EXISTS \(tableName) (\(columnStr))"
        
        if sqlite3_prepare_v2(database, query, -1, &statement, nil) == SQLITE_OK {
            if sqlite3_step(statement) == SQLITE_DONE {
                print("\(tableName) Table created!")
            }
            else {
                print("\(tableName) Table Not created!")
            }
        }
        else {
            print(String(cString: sqlite3_errmsg(DatabaseManager.shared.database)))
            print("\(tableName) creation preparation failed!")
        }
        sqlite3_finalize(statement)
    }
    
    
    func Insert(tableName:String,listOfValToBeAppended:[[String:Any?]]){
       

        for i in 0..<listOfValToBeAppended.count{
            var statement:OpaquePointer? = nil
            
            let myInitialValues = (Array(repeating: "?", count: listOfValToBeAppended[i].count))
            let str = myInitialValues.joined(separator: ",")
            
            let columns = listOfValToBeAppended[i].keys
            let colNameStr = columns.joined(separator: ",")
            
            let query = "INSERT INTO \(tableName)(\(colNameStr)) VALUES (\(str))"
            
                                    
            var values:[Any] = []
            for j in columns{
                values.append(listOfValToBeAppended[i][j]! as Any)
            }
            print(columns)
           print(values)
            if sqlite3_prepare_v2(database, query, -1, &statement, nil) ==
                SQLITE_OK {
                bind(statement: statement!, values: values)
                
                
                if sqlite3_step(statement) == SQLITE_DONE {
                    print("Successfully inserted row.")
                } else {
                    print("Could not insert row.")
                }
            } else {
                print("INSERT statement is not prepared.")
            }
            sqlite3_finalize(statement)
        }
    }
    
    
    func fetch(tableName:String,colList:[String]?,conditions:String?) -> [[String:Any]] {
        
        var statement:OpaquePointer? = nil
       
        
        var query = "SELECT "
        if colList != nil{
            query+=colList!.joined(separator: ", ")
        }
        else{
            query+="*"
        }
        query+=" FROM \(tableName)"
        if conditions != nil{
            query+=" WHERE \(conditions!)"
        }
        query += ";"
        var fetchedData:[[String:Any]] = []
        
        
        if sqlite3_prepare_v2(database, query, -1, &statement, nil) == SQLITE_OK {
            
            while sqlite3_step(statement) == SQLITE_ROW{
                var tempDict:[String:Any] = [:]
                for i in 0..<sqlite3_column_count(statement){
                    let currentColName = String(cString: sqlite3_column_name(statement, i))
                    switch sqlite3_column_type(statement, i){
                    case SQLITE_TEXT:
                        tempDict[currentColName] = String(cString: sqlite3_column_text(statement, i))
                    case SQLITE_INTEGER:
                        tempDict[currentColName] = sqlite3_column_int(statement, i)
                    case SQLITE_FLOAT:
                        tempDict[currentColName] = sqlite3_column_double(statement, i)
                    case SQLITE_BLOB:
                        if let blob = sqlite3_column_blob(statement, i){
                            let data = Data(bytes: blob, count: Int(sqlite3_column_bytes(statement, i)))
                            tempDict[currentColName] = data
                        }
                        else{
                            tempDict[currentColName] = nil
                        }
                    default:
                        tempDict[currentColName] = nil
                    }
                }
                fetchedData.append(tempDict)
            }
            
        }
        else{
            print(String(cString: sqlite3_errmsg(DatabaseManager.shared.database)))
        }
        return fetchedData
    }
    
    func update(tableName:String,colListWithVal:[String:Any?],criteria:String){
        var statement:OpaquePointer? = nil
        
        let colList = colListWithVal.keys
        
        var values:[Any] = []
        
        for i in colList{
            values.append(colListWithVal[i] as Any)
        }
        var emptyList:[String] = []
        for i in colList{
            var emptyStr:String=""
            emptyStr += i + "=" + "?"
            emptyList.append(emptyStr)
            
        }
        let initialUpdatedStr = emptyList.joined(separator: ",")
        
        let query = "UPDATE \(tableName) SET \(initialUpdatedStr) WHERE \(criteria)"
        
        if sqlite3_prepare_v2(database, query, -1, &statement, nil) == SQLITE_OK{
            bind(statement: statement!,values: values)
            if sqlite3_step(statement) == SQLITE_DONE {
                print("\(tableName) updated successfully!")
            }
            else {
                print("\(tableName) not updated!")
            }
        }
        else {
            print("\(tableName) update statement not prepared!")
        }
        sqlite3_finalize(statement)
        
    }
    
    
    func addColumn(tableName:String,colNameWithType:[String:String]){
        var emptyList:[String]=[]
        for i in colNameWithType.keys{
            var emptyStr:String = " ADD COLUMN "
            emptyStr+=i+" "+colNameWithType[i]!
            emptyList.append(emptyStr)

        }
        for i in 0..<emptyList.count{
            var statement:OpaquePointer? = nil
            
            let query = "ALTER TABLE \(tableName)\(emptyList[i]);"
            
            if sqlite3_prepare_v2(database, query, -1, &statement, nil) == SQLITE_OK {
                if sqlite3_step(statement) == SQLITE_DONE {
                    print("column added!")
                }
                else {
                    print("column  Not ADDED!")
                }
            }
            else {
                print("column addition preparation droped!")
            }
            sqlite3_finalize(statement)
        }
    }
    
    func deleteRow(tableName:String,criteria:String?) {
        
        var deleteStatement: OpaquePointer?
        var delString = "DELETE FROM \(tableName)"
        if(criteria != nil){
            delString += " WHERE \(criteria!);"
        }
       
        if sqlite3_prepare_v2(database, delString , -1, &deleteStatement, nil) ==
            SQLITE_OK {
            if sqlite3_step(deleteStatement) == SQLITE_DONE {
                print("Successfully deleted row.")
            } else {
                print("Could not delete row.")
            }
        } else {
            print("DELETE statement could not be prepared")
        }
        
        sqlite3_finalize(deleteStatement)
    }
    
    func bind(statement:OpaquePointer,values:[Any?]){
        for i in 0..<values.count {
            switch values[i]{
            case is Int :
                sqlite3_bind_int(statement, Int32(i+1), Int32(values[i] as! Int))
            case  is Double :
                sqlite3_bind_double(statement, Int32(i+1), values[i] as! Double)
            case  is String :
                sqlite3_bind_text(statement, Int32(i+1), (values[i] as! NSString).utf8String, -1, nil)
            case is Data :
                let _ = (values[i] as! Data).withUnsafeBytes{ (bytes:UnsafeRawBufferPointer) in
                    sqlite3_bind_blob(statement, Int32(i+1), bytes.baseAddress, Int32((values[i] as! Data).count), nil)
                }
            default:
                sqlite3_bind_null(statement, Int32((i+1)))
            }
        }
        
    }
    func dropTable(tableName : String) {
        let query = "DROP TABLE \(tableName)"
        var statement : OpaquePointer? = nil
        if sqlite3_prepare_v2(database, query, -1, &statement, nil) == SQLITE_OK {
            if sqlite3_step(statement) == SQLITE_DONE {
                print("\(tableName) Table droped!")
            }
            else {
                print("\(tableName) Table Not droped!")
            }
        }
        else {
            print("\(tableName) drop preparation droped!")
        }
    }
;
    func orderBy(tableName:String,colNames:[String]?,criteria:[String],sortPreference:String) -> [[String:Any]]{
        var statement : OpaquePointer? = nil
        var query = "SELECT "
        query += (colNames != nil) ? colNames!.joined(separator: ", ") : "* "
        query += "FROM \(tableName) ORDER BY"
        var temp :[String] = []
        for i in criteria{
            temp.append(" \(i) \(sortPreference)")
        }
        query += temp.joined(separator: " ,")
        query += ";"
        print(query)
        
        var fetchedData:[[String:Any]] = []
        
        
        if sqlite3_prepare_v2(database, query, -1, &statement, nil) == SQLITE_OK {
            
            while sqlite3_step(statement) == SQLITE_ROW{
                var tempDict:[String:Any] = [:]
                for i in 0..<sqlite3_column_count(statement){
                    let currentColName = String(cString: sqlite3_column_name(statement, i))
                    switch sqlite3_column_type(statement, i){
                    case SQLITE_TEXT:
                        tempDict[currentColName] = String(cString: sqlite3_column_text(statement, i))
                    case SQLITE_INTEGER:
                        tempDict[currentColName] = sqlite3_column_int(statement, i)
                    case SQLITE_FLOAT:
                        tempDict[currentColName] = sqlite3_column_double(statement, i)
                    case SQLITE_BLOB:
                        if let blob = sqlite3_column_blob(statement, i){
                            let data = Data(bytes: blob, count: Int(sqlite3_column_bytes(statement, i)))
                            tempDict[currentColName] = data
                        }
                        else{
                            tempDict[currentColName] = nil
                        }
                    default:
                        tempDict[currentColName] = nil
                    }
                }
                fetchedData.append(tempDict)
            }
            
        }
        else{
            print(String(cString: sqlite3_errmsg(DatabaseManager.shared.database)))
        }
        return fetchedData
    }
    
}
