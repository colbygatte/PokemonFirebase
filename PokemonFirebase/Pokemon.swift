//
//  Pokemon.swift
//  PokemonFirebase
//
//  Created by Colby Gatte on 11/9/16.
//  Copyright © 2016 colbyg. All rights reserved.
//

import UIKit
import CoreLocation
import Firebase


class Pokemon: NSObject {
    var name: String!
    var imageURL: URL!
    var location: CLLocationCoordinate2D!
    
    var key: String!
    var dbRef: FIRDatabaseReference?
    
    init(snapshot: FIRDataSnapshot) {
        super.init()
        
        self.key = snapshot.key
        self.dbRef = snapshot.ref
        
        let value = snapshot.value as! [String:Any]
        self.name = value["name"] as! String
        self.imageURL = URL(string: value["imageURL"] as! String)
        
        let lat = CLLocationDegrees(value["latitude"] as! Double)
        let lon = CLLocationDegrees(value["longitude"] as! Double)
        
        self.location = CLLocationCoordinate2D(latitude: lat, longitude: lon)
    }

    init(newPokemon: String, imageURL: URL, location: CLLocationCoordinate2D, pokeRef: FIRDatabaseReference) {
        super.init()
        
        self.dbRef = pokeRef.childByAutoId().ref
        self.key = self.dbRef?.key
        
        self.name = newPokemon
        self.imageURL = imageURL
        self.location = location

        
        self.dbRef?.setValue(self.toAnyObject())
    }
    
    
    func toAnyObject() -> Any {
        return [
            "name": self.name,
            "imageURL": self.imageURL.absoluteString,
            "latitude": self.location.latitude,
            "longitude": self.location.longitude
        ] as Any
    }
}

/*
{
    "pokemon" : {
        "-KW938ZS53mWr8jEg6yk" : {
            "imageURL" : "https://colbyg.com/pokemon/caterpie.png",
            "latitude" : 28.111,
            "longitude" : 19.44,
            "name" : "Caterpie"
        },
        "-KW9EJNXiTJk9oyVpnzZ" : {
            "imageURL" : "https://colbyg.com/pokemon/haunter.png",
            "latitude" : 58.21,
            "longitude" : 49.44,
            "name" : "Haunter"
        }
    }
}
*/
