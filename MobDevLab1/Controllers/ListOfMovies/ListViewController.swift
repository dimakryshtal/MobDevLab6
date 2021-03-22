//
//  ListViewController.swift
//  MobDevLab1
//
//  Created by Dima on 19.02.2021.
//

import UIKit

class ListViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var searchBar: UISearchBar!

    var searchArr = [Movie]()
    var searching = false
   
    lazy var jsonMovies = Manager.shared.getText("MoviesList", type: Movies.self)
    lazy var moviesArr:[Movie] = jsonMovies!.Search
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        registerNotifications()
        hideKeyboard()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()
    }

}

extension ListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searching {
            return searchArr.count
        } else {
            return moviesArr.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var movie: Movie?
        if searching {
            movie = searchArr[indexPath.row]
        } else {
            movie = moviesArr[indexPath.row]
        }
            
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableCell") as! CustomTableViewCell
        cell.setImageAndLabel(movie: movie!)
 
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(moviesArr[indexPath.row].imdbID.prefix(2) == "tt" && !searching) {
            performSegue(withIdentifier: "showdetail", sender: self)
        } else if (searching && searchArr[indexPath.row].imdbID.prefix(2) == "tt") {
            performSegue(withIdentifier: "showdetail", sender: self)
        } else {
            self.tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            moviesArr.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .none)
        }
    }
}
extension ListViewController {
    @IBAction func unwindToVC(segue: UIStoryboardSegue) {
        if let sourceVC = segue.source as? AddMovieViewController {
            if (sourceVC.movie!.title != "") {
                moviesArr.append(sourceVC.movie!)
            }
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "showdetail") {
            if let indexPath = self.tableView.indexPathForSelectedRow {

                let controller = segue.destination as! MovieDetailsViewController
                var data: Movie?
   
                if searching {
                    data = Manager.shared.getText(searchArr[indexPath.row].imdbID, type: Movie.self)
                } else {
                    data = Manager.shared.getText(moviesArr[indexPath.row].imdbID, type: Movie.self)
                }
                
                controller.details = data
                self.tableView.deselectRow(at: indexPath, animated: true)
            }
        }
      
    }
    
}

extension ListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if (searchText == "") {
            searching = false
            searchArr = [Movie]()
        } else {
            searchArr = moviesArr.filter(){$0.title.lowercased().hasPrefix(searchText.lowercased())}
            searching = true
        }
        self.tableView.reloadData()
    }
    
}

extension ListViewController {
    func registerNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height + tableView.rowHeight - self.tabBarController!.tabBar.frame.size.height, right: 0)
            tableView.scrollIndicatorInsets = tableView.contentInset
        }
    }
    @objc func keyboardWillHide(notification: NSNotification) {
        tableView.contentInset = .zero
        tableView.scrollIndicatorInsets = tableView.contentInset
    }
    
    func hideKeyboard() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
