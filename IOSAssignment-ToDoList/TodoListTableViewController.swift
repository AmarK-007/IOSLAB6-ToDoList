//
//  TodoListTableViewController.swift
//  IOSAssignment-ToDoList
//
//  Created by Amarnath  Kathiresan on 2023-10-17.
//

import UIKit

/* Struct holding a string variable to fetch user input as to do cell value */
struct toDo{
    let toDoItemValue: String
}
class TodoListTableViewController: UITableViewController {
    
    /* Array of Struct holding a string variable fetched from user input as collection of to do items */
    var toDoArray = [toDo]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        if ((getUserDefaultInstance().array(forKey: "To-do-List")) != nil) {
            // userDefault has a value
            //print("To-do-List userDefault has a value")
            reStoreToDoArrayFromUserDefaults()
        } else {
            // userDefault is nil (empty)
            //print("To-do-List userDefault is nil (empty)")
        }
    }
    
    //    override func viewWillDisappear(_ animated: Bool) {
    //        storeTodoArrayInUserDefaults()
    //    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return toDoArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //Configure the cell...
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "todoTableViewCell", for: indexPath)
        // Configure the cell...
        cell.textLabel?.text = toDoArray[indexPath.row].toDoItemValue
        //print("ValueAdded \(toDoArray[indexPath.row].toDoListItemValue)")
        return cell
    }
    
    /* function to handle addButton action implementation - to add input from user into the toDoArray */
    @IBAction func addButton(_ sender: Any) {
        let alertController = UIAlertController(title: "Add To-Do Item", message: "", preferredStyle: .alert)
        
        let OKAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { alert -> Void in
            let value = alertController.textFields![0] as UITextField
            if((value.text?.isEmpty) != nil && (value.text != "")){
                self.toDoArray.append(toDo(toDoItemValue:value.text!))
                self.storeTodoArrayInUserDefaults()
                self.tableView.reloadData()
                self.showToast(message: "'\(value.text ?? "")' is added.", seconds: 1.0)
                //print("ValueAdded \(value.text!)")
                //            if(!value.text!.isEmpty){}else{
                //
                //            }
            } else {
                self.showToast(message: "Input was empty! non added...", seconds: 1.0)
            }
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: {
            (action : UIAlertAction!) -> Void in })
        
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Write an Item"
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(OKAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    /* function to get UserDefaults instance  */
    func getUserDefaultInstance() -> UserDefaults {
        return UserDefaults.standard
    }
    
    /* function to store user input into UserDefaults */
    func storeTodoArrayInUserDefaults(){
        var stringToDoList : [String] = []
        if(!toDoArray.isEmpty){
            stringToDoList.reserveCapacity(toDoArray.count)
            for value in toDoArray {
                stringToDoList.append(value.toDoItemValue)
                //print(value.toDoItemValue)
            }
        }
        getUserDefaultInstance().set(stringToDoList, forKey: "To-do-List")
    }
    
    /* function to restore user input from UserDefaults */
    func reStoreToDoArrayFromUserDefaults(){
        var stringToDoList : [String] = []
        stringToDoList.append(contentsOf:getUserDefaultInstance().value(forKey:"To-do-List") as? [String] ?? [])
        if(stringToDoList.count>0){
            for value in stringToDoList {
                toDoArray.append(toDo(toDoItemValue:value))
                //print(value)
            }
            self.tableView.reloadData()
        }
    }
    
    /* function to delete a row of item from tableView as per user selection */
    func deleteItemfromArray(cellForRowAt indexPath: IndexPath){
        // Delete the item from input array
        let value = toDoArray[indexPath.row].toDoItemValue
        tableView.beginUpdates()
        self.toDoArray.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .fade)
        tableView.endUpdates()
        storeTodoArrayInUserDefaults()
        self.showToast(message: "'\(value)' is deleted.", seconds: 1.0)
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            deleteItemfromArray(cellForRowAt: indexPath)
        } /*else if editingStyle == .insert {
           // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
           }*/
    }
    
    func showToast(message : String, seconds: Double){
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.view.backgroundColor = .black
        alert.view.alpha = 0.5
        alert.view.layer.cornerRadius = 15
        self.present(alert, animated: true)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + seconds) {
            alert.dismiss(animated: true)
        }
    }
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
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
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
}
