//
//  FAQVC.swift
//  Meshwar Eat
//
//  Created by Mohamed on 24/11/2023.
//

import UIKit

class FAQVC: UIViewController {

    @IBOutlet weak var FaqTable: UITableView!
    var FaQArr = [FaQ]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTable()
        setData()
    }
    func setTable(){
        FaqTable.rowHeight = UITableView.automaticDimension
        FaqTable.estimatedRowHeight = 400
        FaqTable.dataSource = self
        FaqTable.delegate = self
        FaqTable.register(UINib(nibName: "FaQcell", bundle: nil), forCellReuseIdentifier: "faqcell")
        FaqTable.register(UINib(nibName: "FAQAnswercell", bundle: nil), forCellReuseIdentifier: "answercell")
    }
    func setData(){
        FaQArr = [FaQ(question: "How can i cancel my order?", answer: "When you start and order you can cancel it by clicking the logo on home page. You can find cancel button there."),
                  FaQ(question: "How can i order food?", answer: "When you start and order you can cancel it by clicking the logo on home page. You can find cancel button there."),
                  FaQ(question: "How can i get coupon?", answer: "When you start and order you can cancel it by clicking the logo on home page. You can find cancel button there."),
                  FaQ(question: "How can icontact with delivery man?", answer: "When you start and order you can cancel it by clicking the logo on home page. You can find cancel button there, When you start and order you can cancel it by clicking the logo on home page. You can find cancel button there"),
                  FaQ(question: "How can i order food?", answer: "When you start and order you can cancel it by clicking the logo on home page. You can find cancel button there."),
        ]
    }
    @IBAction func Back_btn(){
        self.dismiss(animated: true)
    }
}
extension FAQVC: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return FaQArr.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sec = FaQArr[section]
        return sec.is_opened ? 2 : 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let sec = FaQArr[indexPath.section]
        if indexPath.row == 0{
            //print("faqcelllllll", sec.is_opened)
            let cell = tableView.dequeueReusableCell(withIdentifier: "faqcell") as! FaQcell
            cell.config(model: sec)
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "answercell") as! FAQAnswercell
            cell.config(model: sec)
            return cell
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0{
            FaQArr[indexPath.section].is_opened = !(FaQArr[indexPath.section].is_opened)
            tableView.reloadSections([indexPath.section], with: .none)
        }
    }
    
    
}

struct FaQ{
    let question: String
    let answer: String
    var is_opened = false
}
