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
	@IBOutlet weak var imgCapa: UIImageView!

	//isbn teste: 0201075253 / 0201531747 / 978-84-376-0494-7

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
		let isbnBusca = "ISBN:" + isbn
        let urls = "https://openlibrary.org/api/books?jscmd=data&format=json&bibkeys=" + isbnBusca
        let url = NSURL(string: urls)
        let dados:NSData? = NSData(contentsOfURL: url!)

		// se resultado nulo, está sem internet
        if (dados == nil) {
            //cria o alerta
			let alerta = UIAlertController(title: "Aviso!", message: "Sem conexão de Internet", preferredStyle: UIAlertControllerStyle.Alert)
            alerta.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil))
            
            //mostra o alerta
            self.presentViewController(alerta, animated: true, completion: nil)

			self.txtViewResultado.text = ""
			self.imgCapa.hidden = true
        }
        else {
			do {
				let json = try NSJSONSerialization.JSONObjectWithData(dados!, options: NSJSONReadingOptions.MutableLeaves)

				let resultado = json as! NSDictionary //armazena os dados do livro

				//se livro não contém elementos (está vazio), não encontrou o livro
				if (resultado.count == 0) {
					//cria o alerta
					let alerta = UIAlertController(title: "Aviso!", message: "ISBN não encontrado", preferredStyle: UIAlertControllerStyle.Alert)
					alerta.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil))

					//mostra o alerta
					self.presentViewController(alerta, animated: true, completion: nil)
					self.txtViewResultado.text = ""
					self.imgCapa.hidden = true
				}
				
				//senão encontrou um livro
				else {
					print("encontrei")

					//título
					let livro = resultado["\(isbnBusca)"] as! NSDictionary
					let titulo = livro["title"] as! NSString as String
					print(titulo)
					self.txtViewResultado.text = "Título: " + titulo + "\n"

					//autor
					let autores = livro["authors"] as! NSArray
					self.txtViewResultado.text = txtViewResultado.text + "Autor(es):\n"
					for i in 0 ..< autores.count {
						let nome = autores[i]["name"] as! NSString as String
						print(nome)
						self.txtViewResultado.text = txtViewResultado.text + "\t" + nome + "\n"
					}

					/* //autor - OU isso
						let autores = livro["authors"] as! NSArray
						self.txtViewResultado.text = txtViewResultado.text + "Autor(es):\n"
						for autor in autores {
							let nome = autor["name"] as! NSString as String
							print(nome)
							self.txtViewResultado.text = txtViewResultado.text + "\t" + nome + "\n"
						}
					*/

					//capa
					if livro["cover"]?.count > 0 {
						let capas = livro["cover"] as! NSDictionary
						let capaMedia = capas["medium"] as! NSString as String
						print(capaMedia)

						//mostrando a capa
						let urlCapa = NSURL(string: capaMedia)
						let imagemCapa = NSData(contentsOfURL:urlCapa!)
						if (imagemCapa != nil) {
							self.imgCapa.hidden = false
							self.imgCapa.image = UIImage(data: imagemCapa!)
						}
						else {
							//cria o alerta
							let alerta = UIAlertController(title: "Aviso!", message: "Não foi possível carregar a capa do livro", preferredStyle: UIAlertControllerStyle.Alert)
							alerta.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil))

							//mostra o alerta
							self.presentViewController(alerta, animated: true, completion: nil)
							
							self.imgCapa.hidden = false
							let imagem:UIImage = UIImage(named: "SemCapa")!
							self.imgCapa.image = imagem
						}
					}
					else {
						self.imgCapa.hidden = false
						let imagem:UIImage = UIImage(named: "SemCapa")!
						self.imgCapa.image = imagem
					}
				}
			}
			catch _ {
				print("não foi possível converter o resultado")
			}
		}
    }

}

