//
//  FireBaseStorageManager.swift
//  Half Music App
//
//  Created by Apple Macbook Pro 13 on 4.10.22.
//

import Foundation
import FirebaseDatabase
import FirebaseAuth

class FireBaseStorageManager {
    
    static var usersRef = Database.database().reference(withPath: "users")
    static var userRef: DatabaseReference {
        get {
            usersRef.child(getCurrentUserUUIDAm())
        }
    }
    static var audioRef = userRef.child("audio")
    static var albumsRef = userRef.child("albums")
    
    static func getCurrentUserUUIDAm() -> String {
        guard let currentUser = Auth.auth().currentUser else {
            return ""
        }
        return currentUser.uid
    }
    
    static func saveTrackInDB(track: TrackFB) {
        let trackRef = audioRef.child(track.name)
        trackRef.setValue(track.convertInDictionary())
    }
    
    static func isAddedInLibrary(track: TrackFB, completion: @escaping (Bool) -> ()) {
        FireBaseStorageManager.audioRef.getData { error, snapshot in
            guard let snapshot = snapshot else {
                return
            }
            
            for item in snapshot.children {
                guard let snapshot = item as? DataSnapshot,
                      let trackFB = TrackFB(snapshot: snapshot) else { continue }
                if trackFB.name == track.name {
                    completion(true)
                    return
                }
            }
            completion(false)
        }
    }
    
//    static func makeObserver() {
//        audioRef.getData { [weak self] error, dataSnapshot in
//            guard let snapshot = dataSnapshot
//            else {
//                print("error - \(error)")
//                return
//            }
//            for item in snapshot.children {
//                guard let snapshot = item as? DataSnapshot,
//                      let track = TrackFB(snapshot: snapshot) else { continue }
//                self?.audiofff.append(track)
//            }
//        }
//    }
}
