//
//  ViewController.swift
//  Busca_ISBN
//
//  Created by Henrique Zuchetto Rossi on 31/05/16.
//  Copyright © 2016 Henrique Zuchetto Rossi. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var txtISBN: UITextField!
    @IBOutlet weak var txtViewResultado: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func buscar(sender: AnyObject) {
		//se o campo de busca estiver vazio
        if (txtISBN.text == "") {
            //cria o alerta
            let alerta = UIAlertController(title: "Aviso!", message: "Preencha o ISBN", preferredStyle: UIAlertControllerStyle.Alert)
            alerta.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil))
            
            //mostra o alerta
            self.presentViewController(alerta, animated: true, completion: nil)
        }
        else {
            //esconde teclado
            buscaSincrona(txtISBN.text!)
        }
    }
    
    func buscaSincrona(isbn:String) {
        let urls = "https://openlibrary.org/api/books?jscmd=data&format=json&bibkeys=ISBN:" + isbn
        let url = NSURL(string: urls)
        let dados:NSData? = NSData(contentsOfURL: url!)
		// se resultado nulo, está sem internet
        if (dados == nil) {
            //cria o alerta
			let alerta = UIAlertController(title: "Aviso!", message: "Sem conexão de Internet", preferredStyle: UIAlertControllerStyle.Alert)
            alerta.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil))
            
            //mostra o alerta
            self.presentViewController(alerta, animated: true, completion: nil)
        }
        else {
            let texto = NSString(data: dados!, encoding: NSUTF8StringEncoding)
			//se resultado for vazio ou chaves, não encontrou o ISBN
            if (texto! == "" || texto! == "{}") {
                //cria o alerta
                let alerta = UIAlertController(title: "Aviso!", message: "ISBN não encontrado", preferredStyle: UIAlertControllerStyle.Alert)
                alerta.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil))
                
                //mostra o alerta
                self.presentViewController(alerta, animated: true, completion: nil)
            }
            else {
                txtViewResultado.text = texto! as String
            }
        }
    }

}

