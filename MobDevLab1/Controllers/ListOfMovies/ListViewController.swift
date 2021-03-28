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
    
    var currMovie: Movie?

    var searchArr = [Movie]()
    var searching = false
    
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
       
    }
    

}

extension ListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(searchArr.count == 0) {
            tableView.setEmptyView()
        } else {
            tableView.restore()
        }
        
        return searchArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var movie: Movie?
        if searching {
            movie = searchArr[indexPath.row]
        }
            
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableCell") as! CustomTableViewCell
        cell.setImageAndLabel(movie: movie!)
 
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (searching && searchArr[indexPath.row].imdbID.prefix(2) == "tt") {
            NetworkManager.sharad.getMovieDetails(with: searchArr[indexPath.row].imdbID) { (data, error) in
                if let data = data {
                    self.currMovie = Manager.shared.parseJSON(data: data, type: Movie.self)
                }
                self.performSegue(withIdentifier: "showdetail", sender: self)
            }
        } else {
            self.tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            searchArr.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .none)
        }
    }
}
extension ListViewController {
    @IBAction func unwindToVC(segue: UIStoryboardSegue) {
        if let sourceVC = segue.source as? AddMovieViewController {
            if (sourceVC.movie!.title != "") {
                searchArr.append(sourceVC.movie!)
                tableView.reloadData()
            }
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "showdetail") {
            if let indexPath = self.tableView.indexPathForSelectedRow {

                let controller = segue.destination as! MovieDetailsViewController
                controller.details = currMovie
                    
                self.tableView.deselectRow(at: indexPath, animated: true)
            }

            
        }
      
    }
    
}

extension ListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let child = SpinnerViewController()
        child.view.frame = tableView.frame
        if (searchText.count < 3) {
            searching = false
            searchArr = [Movie]()
            child.removeFromParent()
            self.tableView.reloadData()
        } else if(searchText.count >= 3){

            view.addSubview(child.view)
            child.didMove(toParent: self)
            
            NetworkManager.sharad.getMovies(with: searchText) {[weak self] (data, err) in
                child.willMove(toParent: nil)
                child.view.removeFromSuperview()
                child.removeFromParent()
                if let data = data{
                    if let movies = Manager.shared.parseJSON(data: data, type: Movies.self) {
                        self?.searchArr = movies.Search
                    } else {
                        self?.searchArr = []
                    }
                    self?.tableView.reloadData()
                }
            }
            searching = true
        }
    }
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        var allowed = CharacterSet(charactersIn: "A"..."Z")
        allowed.insert(charactersIn: "a"..."z")
        allowed.insert(charactersIn: "0"..."9")
        
        if let range = text.rangeOfCharacter(from: allowed.inverted) {
            print(range)
            return false
        }
        
        return true
    }
    
}

extension ListViewController {
    func registerNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height + tableView.rowHeight - self.tabBarController!.tabBar.frame.size.height, right: 0)
            tableView.scrollIndicatorInsets = tableView.contentInset
        }
    }
    @objc func keyboardWillHide(notification: NSNotification) {
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
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

extension UITableView {
    func setEmptyView () {
        let emptyView = UIView(frame: CGRect(x: self.center.x, y: self.center.y, width: self.bounds.size.width, height: self.bounds.size.height))
        let label = UILabel()
        emptyView.addSubview(label)

        label.translatesAutoresizingMaskIntoConstraints = false
        label.centerYAnchor.constraint(equalTo: emptyView.centerYAnchor).isActive = true
        label.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor).isActive = true
        
        label.text = "No items found"
        label.textColor = .black
        label.numberOfLines = 0
        label.textAlignment = .center
        
        self.backgroundView = emptyView
        self.separatorStyle = .none
        
    }
    
    func restore() {
        self.backgroundView = nil
        self.separatorStyle = .none
    }
}

