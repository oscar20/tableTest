//
//  TableViewController.swift
//  tableTest
//
//  Created by d182_oscar_a on 26/05/18.
//  Copyright © 2018 d182_oscar_a. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {
    
    var alumnos = ["Oscar","Julio","Vanessa","Carolina","Susana"]
    var allalumnos = ["Oscar","Julio","Vanessa","Carolina","Susana"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.rightBarButtonItem = self.editButtonItem
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "reuseIdentifier")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return alumnos.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...
        
        cell.textLabel?.text = alumnos[indexPath.row]

        return cell
    }
    
    //para crear el swipe de trail a ling de derecha a izquierda
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        //action, vista y completion handler
        let deleteAction  = UIContextualAction(style: .destructive, title: "Delete") { (action, sourceView, completionHandler) in
            //necesitamos borrar el renglo de nuestros datos
            //necesito self para estar en el ambito de la clase
            self.alumnos.remove(at: indexPath.row)
            //voy a ver el efecto de borrado en la tabla
            self.tableView.deleteRows(at: [indexPath], with: .fade)
            completionHandler(true)
        }
        
        let sharedAction = UIContextualAction(style: .normal, title: "Compartir") { (action, sourceView, completionHandler) in
            let message = "Rescatando al alumno: " + self.alumnos[indexPath.row]
            
            //activityItems, applicationActivities es para si ya tenemos por default con que aplicaciones ya vamos a compartir
            let activityController = UIActivityViewController(activityItems: [message], applicationActivities: nil)
            
            self.present(activityController, animated: true, completion: nil)
            completionHandler(true)
        }
        
        deleteAction.backgroundColor = UIColor(red: 231/255, green: 76/255, blue: 60/255, alpha: 1.0)
        deleteAction.image = UIImage(named: "hongito")
        
        let swipeConfiguration = UISwipeActionsConfiguration(actions: [deleteAction,sharedAction])
        return swipeConfiguration
        
    }
    
    
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        //action, vista y completion handler
        let deleteAction2  = UIContextualAction(style: .normal, title: "Recupera!") { (action, sourceView, completionHandler) in
            self.alumnos = self.allalumnos
            self.tableView.reloadData()
            completionHandler(true)
        }
            
            let swipeConfiguration2 = UISwipeActionsConfiguration(actions: [deleteAction2])
            return swipeConfiguration2
        
    }
    
    //quita el circulo de editar de cada renglon
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .none
    }
    
    //quita la identacion
    override func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    //Para mover un renglon a otro
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let movedAlumno = self.alumnos[sourceIndexPath.row]
        self.alumnos.remove(at: sourceIndexPath.row)
        self.alumnos.insert(movedAlumno, at: destinationIndexPath.row)
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        let rowData = self.alumnos[indexPath.row]
        return rowData.hasPrefix("O")
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let alertController = UIAlertController(title: "Marcando alumnos", message: "¿Desea marcarlo?", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
            let cell = tableView.cellForRow(at: indexPath) //nos crea una celda dado el index path
            cell?.accessoryType = .checkmark
        }
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
        
    }
    //para efecto de transparecnia(fade) cuando aparece la tabla
    /*override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.alpha = 0
        UIView.animate(withDuration: 1.0, animations: {cell.alpha = 1})
    }*/
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let rotationAngleinRadians = 90 * CGFloat(M_PI/180)
        //let rotationTransform = CATransform3DMakeRotation(rotationAngleinRadians, 0, 0, 1)
        let rotationTransform = CATransform3DTranslate(CATransform3DIdentity, -500, 100, 0)
        
        cell.layer.transform = rotationTransform
        UIView.animate(withDuration: 1.0) {
            cell.layer.transform = CATransform3DIdentity
        }
    }
    
 

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    //Me va a dar la habilidad, si la tabla esta en modo de edicion ver si puedo hacer algo con esa celda
    //Override to support editing the table view.
    /*override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            alumnos.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }*/
    

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
