var query = "SELECT"
let colNames :[String]? = []
let criteria = ["firstname","lastname"]
query += (colNames != nil) ? colNames!.joined(separator: ", ") : "*"
query += " FROM CONTACTS ORDER BY"
for i in criteria{
    query += " \(i) asc"
}

print(query)
