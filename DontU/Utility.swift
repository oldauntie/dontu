//  Created by Old Auntie (www.oldauntie.org).
//  Copyright © 2019 OldAuntie. All rights reserved.
//

import Foundation
import UIKit

func d(_ what: Any, label: String = "DEBUG")
{
    print( "\(label): \(type(of: what)): \(what)" )
}


func dd(_ target: UITextView, _ what: Any?, label: String = ""){
    // let currentDateTime = Date()
    target.text += "\(now()) \(label): \(String(describing: what!)) \n"
}

func now() -> String{
    let dateFormatter : DateFormatter = DateFormatter()
    dateFormatter.dateFormat = "dd-MMM-yyyy HH:mm:ss"
    let date = Date()
    let now = dateFormatter.string(from: date)
    
    return now
}

/*
func alert(message: String, title: String = "") {
    let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
    let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
    alertController.addAction(OKAction)
    self.present(alertController, animated: true, completion: nil)
}
*/




