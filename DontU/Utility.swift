//
//  Oldauntie.swift
//  dontu
//
//  Created by nanna on 09/08/2019.
//  Copyright © 2019 OldAuntie. All rights reserved.
//
import Foundation

func d(_ what: Any, label: String = "DEBUG")
{
    print( "\(label)" + "\n" + "\(type(of: what)): " + "\(what)" )
}

/*
func alert(message: String, title: String = "") {
    let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
    let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
    alertController.addAction(OKAction)
    self.present(alertController, animated: true, completion: nil)
}
*/




