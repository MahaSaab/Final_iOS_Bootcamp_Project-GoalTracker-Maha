//
//  JournalViewController.swift
//  GoalTracker
//
//  Created by Maha S on 15/12/2021.
//

import UIKit

class JournalViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, AddJournal {

  var journals = [Journal]()
  
  @IBOutlet weak var tableView: UITableView!
 
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.delegate = self
    tableView.dataSource = self
  }
  
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    tableView.reloadData()
  }
  
  
  @IBSegueAction func addTitle(_ coder: NSCoder) -> AddJournalViewController? {
    let aT = AddJournalViewController(coder: coder)
    aT?.delegate = self
    return aT
  }
  
  
  @IBSegueAction func addJournal(_ coder: NSCoder) -> DetailsViewController? {
    let vc = DetailsViewController(coder: coder)

        if let indexpath = tableView.indexPathForSelectedRow {
          let journal = journals[indexpath.row]
          vc?.journal = journal
        }

    return vc
  }

  
  @IBAction func startEditing(_ sender: Any) {
    tableView.isEditing = !tableView.isEditing
  }
  
  
  func addJournal(title: String, date: String, body: String) {
    journals.append(Journal(title: title, date: date, body: body))
    tableView.reloadData()
  }
  
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return journals.count
  }
  
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "JournalCell", for: indexPath) as! JournalViewCell
    
    cell.titleLabel.text = journals[indexPath.row].title
    cell.dateLabel.text = journals[indexPath.row].date
    cell.bodyLabel.text = journals[indexPath.row].body
    
    return cell
}
 
  
  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    
    if editingStyle == .delete {
      journals.remove(at: indexPath.row)
      tableView.deleteRows(at: [indexPath], with: .automatic)
    }
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let journal = journals[indexPath.row]

    print(journal)

    
    if let detailViewController: DetailsViewController = UIStoryboard.main.instantiate() {
      detailViewController.titleText = journal.title
      detailViewController.date = journal.date
      detailViewController.body = journal.body
      navigationController?.pushViewController(detailViewController, animated: true)
    }
  }
 }


extension UIStoryboard {
  static var main: UIStoryboard {
    return UIStoryboard(name: "Main", bundle: nil)
  }
  
  func instantiate<T: UIViewController>() -> T? {
    let viewController = instantiateViewController(withIdentifier: T.storyboardID) as? T
    return viewController
  }
}


extension UIViewController {
  static var storyboardID: String {
    return String(describing: self)
  }
}
