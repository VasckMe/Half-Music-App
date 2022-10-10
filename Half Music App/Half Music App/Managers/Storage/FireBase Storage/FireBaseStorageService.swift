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
    static var userRef = usersRef.child(getCurrentUserUUIDAm())
    static var audioRef = userRef.child("audio")
    
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
