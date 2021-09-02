//
//  CategoryPickerViewController.swift
//  Azzida
//
//  Created by iVishnu on 07/08/20.
//  Copyright © 2020 Vishnu Chhipa. All rights reserved.
//

import UIKit

class CategoryPickerViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {
    
    var CategoryArr : [String] = []
    var CategorySelectArr : [String] = []
    let userModel : UserModel = UserModel.userModel
    var categoryStr = ""
    var delegate : SelectCategoryDelegate! = nil
    
    @IBOutlet weak var tblView : UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        let array = categoryStr.components(separatedBy: ",")
        CategorySelectArr = Array(repeating: "", count: self.CategoryArr.count)
        
        for cate in CategoryArr{
            if array.contains(cate){
                let index = CategoryArr.firstIndex(of: cate)
                self.CategorySelectArr.remove(at: index ?? 0)
                self.CategorySelectArr.insert(cate, at: index ?? 0)
            }
            
        }
        

    }
    
    @IBAction func btnClose(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CategoryArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FilterCell", for: indexPath) as! FilterCell
        cell.lblFilter.text = CategoryArr[indexPath.row]
        
        if CategorySelectArr[indexPath.row] == ""{
            cell.iconFilter.image = #imageLiteral(resourceName: "Filter_unchecked")
        }
        else{
            cell.iconFilter.image = #imageLiteral(resourceName: "Filter_checked")
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if CategorySelectArr[indexPath.row] == "" {
            CategorySelectArr.remove(at: indexPath.row)
            CategorySelectArr.insert(CategoryArr[indexPath.row], at: indexPath.row)
        }
        else{
            CategorySelectArr.remove(at: indexPath.row)
            CategorySelectArr.insert("", at: indexPath.row)
        }
        
        tableView.reloadData()
    }
    
    @IBAction func btnDone(_ sender: UIButton) {
        var Category = ""
        for ind in CategorySelectArr{
            if ind != "" {
                Category = Category + "," + ind
            }
        }
        
        Category = String(Category.dropFirst())
        print(Category)
        
        self.delegate.GetCategory(category: Category)
        self.dismiss(animated: true, completion: nil)
        
    }
    
    
}


protocol SelectCategoryDelegate {
    func GetCategory(category:String)
}
