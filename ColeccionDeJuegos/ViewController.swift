//
//  ViewController.swift
//  ColeccionDeJuegos
//
//  Created by Jose Falconi on 5/12/22.
//  Copyright © 2022 empresa. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return juegos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let juego = juegos[indexPath.row]
        cell.textLabel?.text = "\(juego.titulo!) - \(juego.categoria!)"
        cell.imageView?.image = UIImage(data: (juego.imagen!))
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let botonEliminar = UITableViewRowAction(style: .normal, title: "Eliminar") {
            (accionesFila, indiceFila) in
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            let juego:Juego = self.juegos[indexPath.row]
            context.delete(juego)
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
            do {
                try self.juegos = context.fetch(Juego.fetchRequest())
                self.tableVIew.reloadData()
            }
            catch {
            }
        }
        botonEliminar.backgroundColor = UIColor.red
        return [botonEliminar]
    }
    
    func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        let objetoMovido = self.juegos[fromIndexPath.row]
        juegos.remove(at: fromIndexPath.row)
        juegos.insert(objetoMovido, at: to.row)
    }
    
    @IBOutlet weak var tableVIew: UITableView!
    
    var juegos:[Juego] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableVIew.dataSource = self
        tableVIew.delegate = self
        
        
        self.navigationItem.leftBarButtonItem = self.editButtonItem
        self.editButtonItem.title = "Editar"
        print(self.isEditing)
        
        
        // Do any additional setup after loading the view.
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        if tableVIew.isEditing == true {
            self.editButtonItem.title = "Editar"
            tableVIew.isEditing = false
        }
        else {
            self.editButtonItem.title = "Hecho"
            tableVIew.isEditing = true
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let juego = juegos[indexPath.row]
        performSegue(withIdentifier: "juegoSegue", sender: juego)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let siguienteVC = segue.destination as! JuegosViewController
        siguienteVC.juego = sender as? Juego
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        do {
            try juegos = context.fetch(Juego.fetchRequest())
            tableVIew.reloadData()
        }
        catch {
        }
    }
}
