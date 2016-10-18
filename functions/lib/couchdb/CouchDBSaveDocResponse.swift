import Foundation

public class CouchDBSaveDocResponse {

    //  id: XXX,
    //  ok: true
    //  rev: 1-YYY

    var id: String
    var ok: Bool
    var rev: String
    
    public init(dict:[String:Any]) {
        self.id = dict["id"] as! String
        self.ok = dict["ok"] as! Bool
        self.rev = dict["rev"] as! String
    }  

}
