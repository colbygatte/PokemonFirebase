//
//  ViewController.swift
//  PokemonFirebase
//
//  Created by Colby Gatte on 11/9/16.
//  Copyright © 2016 colbyg. All rights reserved.
//

import UIKit
import Firebase
import MapKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet var mapView: MKMapView!
    @IBOutlet var tableView: UITableView!
    
    var allPokemon: [Pokemon]!
    var allPokemonAnn: [String:PokemonPointAnnotation]!
    
    var ref: FIRDatabaseReference!
    var pokeRef: FIRDatabaseReference!
    var loc: CLLocationManager!
    var currentLoc: CLLocationCoordinate2D!
    
    override func viewDidLoad() {
        self.allPokemon = [Pokemon]()
        self.allPokemonAnn = [String:PokemonPointAnnotation]()
        
        self.ref = FIRDatabase.database().reference()
        self.pokeRef = self.ref.child("pokemon").ref
        
        self.loc = CLLocationManager()
        self.loc.delegate = self
        self.loc.desiredAccuracy = kCLLocationAccuracyBest
        self.loc.distanceFilter = kCLDistanceFilterNone // are you confined by some distance?
        self.loc.startUpdatingLocation()
        self.loc.requestAlwaysAuthorization()
        
        self.mapView.delegate = self
        self.mapView.showsUserLocation = true
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        // position map
        let coordinate: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 40, longitude: -100)
        let span = MKCoordinateSpanMake(45, 45)
        let region = MKCoordinateRegionMake(coordinate, span)
        self.mapView.setRegion(region, animated: true)
        
        
        // Firebase : load pokemon
        self.pokeRef.observe(.value, with:{ snapshot in
            let pokemons = snapshot.children.allObjects as! [FIRDataSnapshot]
            self.allPokemon = [Pokemon]()
            
            for t in pokemons {
                let poke = Pokemon(snapshot: t)
                self.allPokemon.append(poke)
            }
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.addPokemonToMap()
            }
        })
        
        super.viewDidLoad()
    }
    

    
    
    // SO WE CAN SEE YOU
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentLoc = (manager.location?.coordinate)!
    }

    
    // MAP
    func addPokemonToMap() {
        for poke in allPokemon {
            let pokePointAnnotation = PokemonPointAnnotation()
            pokePointAnnotation.coordinate = poke.location
            pokePointAnnotation.title = poke.name
            pokePointAnnotation.pokemon = poke
            
            self.allPokemonAnn[poke.key] = pokePointAnnotation
            
            self.mapView.addAnnotation(pokePointAnnotation)
        }
    }
    
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if annotation is MKUserLocation {
            return nil
        }
        
        let pokeAnnotation = annotation as! PokemonPointAnnotation
        let poke = pokeAnnotation.pokemon!
        
        let pokemonAnnotationView = PokemonAnnotationView(annotation: annotation, reuseIdentifier: "")
        
        URLSession.shared.dataTask(with: poke.imageURL) { (data: Data?, response: URLResponse?, error: Error?) in
            
            pokemonAnnotationView.annotationImage = UIImage(data: data!)
            DispatchQueue.main.async {
                pokemonAnnotationView.addImageToView()
            }
            
        }.resume()
        
        return pokemonAnnotationView
    }

    // TABLE
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allPokemon.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        
        cell.textLabel?.text = allPokemon[indexPath.row].name
        
        return cell
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let pokemon = self.allPokemon[indexPath.row]
            pokemon.dbRef?.removeValue()
        }
    }
    
    // SEGUE
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddPokemon" {
            let destVC = segue.destination as! AddPokemonTableViewController
            destVC.currentLoc = self.currentLoc
            destVC.pokeRef = self.pokeRef
        }
    }

}

