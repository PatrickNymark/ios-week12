//
//  FirebaseRepo.swift
//  MapProject
//
//  Created by Patrick Nymark on 04/08/2020.
//  Copyright © 2020 Patrick Nymark. All rights reserved.
//

import Foundation
import Firebase

class FirebaseRepo {
    
    private static let db = Firestore.firestore() // gets the Firebase instance
    
    static func startListener(vc: MapViewController){
        db.collection("annotations").addSnapshotListener { (snap, error) in
            if error != nil {  // check if there is an error. If so, then return
                print("error")
                return
            }
            
            var annotations = [Annotation]()
            
            for doc in snap!.documents {
                let data = doc.data()
                
                let title = data["title"] as! String
                let user = data["user"] as! String
                let lat = data["lat"] as! Double
                let long = data["long"] as! Double
                
                let annotation = Annotation(title: title, user: user, lat: lat, long: long)
                
                annotations.append(annotation)
                
            }
            
            vc.updateAnnotations(annotations: annotations)
        }
    }
    
    static func addAnnotation(title: String, user: String, lat: Double, long: Double, completion: (Bool) -> ()) {
        let ref = db.collection("annotations")
        let newAnnotation = Annotation(title: title, user: user, lat: lat, long: long)
//        let newRef = ref.addDocument(data: newAnnotation.dictionary)
        
        let newRef = ref.addDocument(data: newAnnotation.dictionary)
        
        if newRef.documentID != nil {
            completion(true)
        } else {
            completion(false)
        }
    }
    
    static func deleteAnnotation(title: String) {
        let documentRef = db.collection("annotations").whereField("title", isEqualTo: title)
        
        documentRef.getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents; \(err)")
            } else {
                for document in querySnapshot!.documents {
                    document.reference.delete()
//                    mapView.removeAnnotation(selectedAnnotation)
                    return
                    
                }
            }
        }
    }
}
