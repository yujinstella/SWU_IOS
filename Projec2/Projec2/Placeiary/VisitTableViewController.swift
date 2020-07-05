//
//  FavoriteTableViewController.swift
//  ServrLogin
//
//  Created by SWUCOMPUTER on 2020/06/02.
//  Copyright © 2020 SWUCOMPUTER. All rights reserved.
//

import UIKit

class VisitTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem

        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        if let name = appDelegate.userName {
            self.title = name + "'s Visit"
        }
    }
    
    @IBAction func buttonLogout(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title:"로그아웃 하시겠습니까?",message: "",preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
            let urlString: String = "http://condi.swu.ac.kr/student/T12/projec/logout.php"
            guard let requestURL = URL(string: urlString) else { return }
            var request = URLRequest(url: requestURL)
            request.httpMethod = "POST"
            let session = URLSession.shared
            let task = session.dataTask(with: request) { (responseData, response, responseError) in
                guard responseError == nil else { return }
            }
            task.resume()
            
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let loginView = storyboard.instantiateViewController(withIdentifier: "loginView")
            loginView.modalPresentationStyle = .fullScreen
            self.present(loginView, animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
    
    var fetchedArray: [VisitData] = Array()
    var restArray: [VisitData] = Array()
    var barArray: [VisitData] = Array()
    var cafeArray: [VisitData] = Array()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        fetchedArray = [] // 배열을 초기화하고 서버에서 자료를 다시 가져옴
        restArray = []
        barArray = []
        cafeArray = []
        self.downloadDataFromServer()
    }

    func downloadDataFromServer() -> Void {
        
        let urlString: String = "http://condi.swu.ac.kr/student/T12/projec/visitTable.php"
        guard let requestURL = URL(string: urlString) else { return }
        var request = URLRequest(url: requestURL)
        ////////
        request.httpMethod = "POST"
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        guard let userID = appDelegate.ID else { return }
        var restString: String = "id=" + userID
        //////////
        request.httpBody = restString.data(using: .utf8)
        let session = URLSession.shared
        let task = session.dataTask(with: request) {
            (responseData, response, responseError) in guard responseError == nil else {
                print("Error: calling POST"); return;
            }
            guard let receivedData = responseData else {
                print("Error: not receiving Data"); return; }
            let response = response as! HTTPURLResponse
            if !(200...299 ~= response.statusCode) { print("HTTP response Error!"); return }
            do {
                if let jsonData = try JSONSerialization.jsonObject(with: receivedData,
                                                                    options:.allowFragments) as? [[String: Any]] {
                    for i in 0...jsonData.count-1 {
                        var newData: VisitData = VisitData()
                        var jsonElement = jsonData[i]
                        
                        newData.visitno = jsonElement["visitno"] as! String
                        newData.userid = jsonElement["id"] as! String
                        newData.name = jsonElement["name"] as! String
                        newData.descript = jsonElement["description"] as! String
                        newData.imageName = jsonElement["imageName"] as! String
                        newData.date = jsonElement["date"] as! String
                        newData.location = jsonElement["location"] as! String
                        newData.point = jsonElement["point"] as! String
                        newData.place = jsonElement["place"] as! String
                       // print(newData.place)
                        
                        if newData.place == "Restaurant"{
                            self.restArray.append(newData)
                        }
                        else if newData.place == "Cafe" {
                            self.cafeArray.append(newData)
                        }
                        else {
                            self.barArray.append(newData)
                        }
                        
                        //self.fetchedArray.append(newData)
                    }
                    DispatchQueue.main.async { self.tableView.reloadData() } }
            } catch { print("Error: Catch") } }
        task.resume()
    
    }
    
    // MARK: - Table view data source
    let placeArr : Array<String> = ["Restaurant" , "Cafe" , "Bar"]
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return placeArr.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return placeArr[section]
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == 0 { return restArray.count }
        else if section == 1 { return cafeArray.count }
        else { return barArray.count }

        //return fetchedArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Visit Cell", for: indexPath)

        if indexPath.section == 0 {
            let item = restArray[indexPath.row]
            cell.textLabel?.text = item.name
            cell.detailTextLabel?.text = item.location
        }
        else if indexPath.section == 1 {
            let item = cafeArray[indexPath.row]
            cell.textLabel?.text = item.name
            cell.detailTextLabel?.text = item.location
        }
        else {
            let item = barArray[indexPath.row]
            cell.textLabel?.text = item.name
            cell.detailTextLabel?.text = item.location
        }

        return cell
    }
    

    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
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
    var selectSection = 0
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        selectSection = indexPath.section
        return indexPath
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "toDetailView" {
            if let destination = segue.destination as? DetailViewController {
                if let selectedIndex = self.tableView.indexPathsForSelectedRows?.first?.row {
                    var data = VisitData();
                    switch selectSection {
                    case 0:
                        data = restArray[selectedIndex]
                    case 1:
                        data = cafeArray[selectedIndex]
                    default:
                        data = barArray[selectedIndex]
                    }
                    destination.selectedData = data
                    destination.title = data.name
                }
            }
        }
    }
    
    
}

