struct DataSource{
    var data:[String]
}
var grpCount = 0
enum sectionHeader:CaseIterable{
    case firstname,lastname,workinfo,group,notes
    
    
}


func getDs()->[DataSource]{
    var ds:[DataSource] = []
    for i in sectionHeader.allCases.enumerated(){
        
        switch i.element{
        case .firstname:
            ds.append(DataSource(data: ["firstName","lastname"]))
        case .lastname:
            continue
        case .workinfo:
            ds.append(DataSource(data: ["wi"]))
        case .group:
            if(grpCount > 0){
                ds.append(DataSource(data: ["group"]))
            }
        case .notes:
            ds.append(DataSource(data: ["notes"]))
        }
    }
    return ds
}
print(getDs())
