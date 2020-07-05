//
//  DetailViewController.swift
//  Projec2
//
//  Created by SWUCOMPUTER on 2020/07/03.
//  Copyright © 2020 SWUCOMPUTER. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet var textName: UILabel!
    @IBOutlet var textDate: UILabel!
    @IBOutlet var textDescription: UILabel!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var textPlace: UILabel!
    @IBOutlet var textLocation: UILabel!
    @IBOutlet var textPoint: UILabel!
    @IBOutlet var textID: UILabel!

    
    // 상위 View에서 자료를 넘겨 받기 위한 변수
    var selectedData: VisitData?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        guard let VisitData = selectedData else { return }
        textName.text = VisitData.name
        textDate.text = VisitData.date
        textDescription.numberOfLines = 0
        textDescription.text = VisitData.descript
        textPlace.text = VisitData.place
        textPoint.text = VisitData.point + "점 / 10"
        textLocation.text = VisitData.location
        //textID.text = VisitData.userid
        var imageName = VisitData.imageName
        // 숫자.jpg 로 저장된 파일 이름
        if (imageName != "") {
            let urlString = "http://condi.swu.ac.kr/student/T12/projec/"
            imageName = urlString + imageName
            let url = URL(string: imageName)!
            if let imageData = try? Data(contentsOf: url) {
                imageView.image = UIImage(data: imageData)
            }
        }
    }
    
    @IBAction func buttonDelete() {
        let alert=UIAlertController(title:"정말 삭제 하시겠습니까?", message: "",preferredStyle:.alert)
        alert.addAction(UIAlertAction(title: "Delete", style: .cancel, handler: { action in
            let urlString: String = "http://condi.swu.ac.kr/student/T12/projec/deleteVisit.php"
            guard let requestURL = URL(string: urlString) else { return }
            var request = URLRequest(url: requestURL)
            request.httpMethod = "POST"
            guard let visitNO = self.selectedData?.visitno else { return }
            let restString: String = "visitno=" + visitNO
            request.httpBody = restString.data(using: .utf8)
            let session = URLSession.shared
            let task = session.dataTask(with: request) { (responseData, response, responseError) in
                guard responseError == nil else { return }
                guard let receivedData = responseData else { return }
                if let utf8Data = String(data: receivedData, encoding: .utf8) { print(utf8Data) }
            }
            task.resume()
            self.navigationController?.popViewController(animated: true)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
