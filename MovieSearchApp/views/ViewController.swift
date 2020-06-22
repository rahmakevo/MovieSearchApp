//
//  ViewController.swift
//  MovieSearchApp
//
//  Created by Kevin Siundu on 13/06/2020.
//  Copyright © 2020 Kevin Siundu. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    // what we need to do
    // create ui
    // handle network request
    // have a custom cell
    // handle cell click
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var field: UITextField!
    var movies = [Movies]()
    override func viewDidLoad() {
        super.viewDidLoad()
        table.register(MovieTableViewCell.nib(), forCellReuseIdentifier: MovieTableViewCell.cellIdentifier)
        table.delegate = self
        table.dataSource = self
        field.delegate = self
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    deinit {
        print("--- \(self) deinit")
    }
    // capture events on text field as user gets return key
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchMovies()
        return true
    }
    // we will need a serach function to search for movies on the field
    func searchMovies() {
        field.resignFirstResponder()
        // now we will prepare for a network request
        // assert the field is not empty
        guard let text = field.text, !text.isEmpty else {
            return
        }
        let query = text.replacingOccurrences(of: " ", with: "%20")
        movies.removeAll()
        URLSession.shared.dataTask(with: URL(string: "http://www.omdbapi.com/?i=tt3896198&apikey=fbaf003f&s=\(query)&type=movie")!,
                                   completionHandler: { data, response, error in
                                    // check if that there is data
                                    guard let data = data, error == nil else {
                                        print("error with session")
                                        return
                                    }
                                    // convert data
                                    var result: MovieResult?
                                    do {
                                        result = try JSONDecoder().decode(MovieResult.self, from: data)
                                    } catch {
                                        print("error converting data!")
                                    }
                                    // validate conversion success
                                    guard let finishResult = result else {
                                        return
                                    }
                                    print("\(finishResult.Search.first?.Title)")
                                    // update our movies array
                                    let movie = finishResult.Search
                                    self.movies.append(contentsOf: movie)
                                    // refresh our table
                                    // how to do user interface changes
                                    DispatchQueue.main.async {
                                        self.table.reloadData()
                                    }
            }).resume()
    }
    var openSample: () -> Void = { print("open action is not overridden") }
    func openSampleTapped() { openSample() }
}
struct MovieResult: Codable {
    let Search: [Movies]
}
struct Movies: Codable {
    let Title: String
    let Year: String
    let imdbID: String
    let _Type: String
    let Poster: String
    private enum CodingKeys: String, CodingKey {
         case Title, Year, imdbID, _Type = "Type", Poster
    }
}
extension ViewController: UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate {
    // functions for the table
    // 1. number of rows
    // has to take an array size or int size for the model data
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    //2. cell for at row
    // returns a custom cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MovieTableViewCell.cellIdentifier, for: indexPath) as! MovieTableViewCell
        cell.configure(with: movies[indexPath.row])
        return cell
    }
    //3. did select row at
    // if a specific cell has been selected
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true )
        print("some row was selected")
        openSampleTapped()
    }
}

