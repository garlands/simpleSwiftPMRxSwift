//
//  ViewController.swift
//  simpleSwiftPMRxSwift
//
//  Created by Masahiro Tamamura on 2021/01/17.
//

import UIKit
import RxSwift
import RxCocoa
import RealmSwift
import RxDataSources

class ViewController: UIViewController {

    var items: Results<TodoModel>!
    let realm = try! Realm()
    var disposeBag = DisposeBag()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var button: UIButton! {
        didSet {
            button.rx.tap
                .subscribe(onNext:  { [weak self] in
                    let item:TodoModel = TodoModel()
                    let text = self?.textField.text
                    item.testText = text
                    let realm2 = try! Realm()
                    try! realm2.write {
                        realm2.add(item)
                    }
                    
                    self?.tableView.reloadData()
                })
                .disposed(by: disposeBag)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.items = realm.objects(TodoModel.self)
        

    }
}

extension ViewController: UITableViewDataSource {

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.items.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

    let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath)
    let item: TodoModel = self.items[(indexPath as NSIndexPath).row];
    cell.textLabel?.text = item.testText

    return cell
  }
}
