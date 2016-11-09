//
//  AddPokemonTableViewController.swift
//  PokemonFirebase
//
//  Created by Colby Gatte on 11/9/16.
//  Copyright © 2016 colbyg. All rights reserved.
//

import UIKit
import MapKit
import Firebase

class AddPokemonTableViewController: UITableViewController {

    @IBOutlet var addPokemonButton: UIButton!
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var urlTextField: UITextField!
    
    var currentLoc: CLLocationCoordinate2D!
    var pokeRef: FIRDatabaseReference!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        addPokemonButton.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: 4)
        
        if self.currentLoc == nil {
            self.currentLoc = CLLocationCoordinate2D(latitude: CLLocationDegrees(29), longitude: CLLocationDegrees(-95))
        }
        
    }
    
    @IBAction func addPokemonButtonPressed(_ sender: Any) {
        _ = Pokemon(
            newPokemon: self.nameTextField.text!,
            //imageURL: URL(string: urlTextField.text!)!,
            imageURL: URL(string: "https://colbyg.com/pokemon/mega-alakazam.png")!,
            location: self.currentLoc,
            pokeRef: self.pokeRef
        )
        
        self.dismiss(animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }



}
