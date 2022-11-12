//
//  FireBaseStorageService.swift
//  Half Music App
//
//  Created by Apple Macbook Pro 13 on 4.10.22.
//

import Foundation
import FirebaseDatabase
import FirebaseAuth

final class FireBaseStorageService {
    
    /// Constants
    static var usersRef = Database.database().reference(withPath: "users")
    static var userRef: DatabaseReference {
        get {
            usersRef.child(getCurrentUserUUIDAm())
        }
    }
    static var audioRef = userRef.child("audio")
    static var albumsRef = userRef.child("albums")
    
    /// Static func
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
        FireBaseStorageService.audioRef.getData { error, snapshot in
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
    
    static func getAlbums(completion: @escaping ([AlbumFB]) -> ()) {
        albumsRef.getData { error, snapshot in
            if let error = error {
                print(error.localizedDescription)
            } else {
                guard let snapshot = snapshot else { return }
                var albums: [AlbumFB] = []
                for item in snapshot.children {
                    guard let snapshot = item as? DataSnapshot,
                          let album = AlbumFB(snapshot: snapshot) else { continue }
                    albums.append(album)
                }
                DispatchQueue.main.async {
                    completion(albums)
                }
            }
        }
    }
    
    static func getTracksWithOptionalArtist(
        artist: String?,
        completion: @escaping ([TrackFB]) -> ()
    ) {
        audioRef.getData { error, snapshot in
            if let error = error {
                print(error.localizedDescription)
            } else {
                guard let snapshot = snapshot else { return }
                var audioTracks: [TrackFB] = []
                for item in snapshot.children {
                    guard let snapshot = item as? DataSnapshot,
                          let audioTrack = TrackFB(snapshot: snapshot) else { continue }
                    if let artist = artist {
                        if audioTrack.artist == artist {
                            audioTracks.append(audioTrack)
                        } else {
                            continue
                        }
                    } else {
                        audioTracks.append(audioTrack)
                    }
                }
                DispatchQueue.main.async {
                    completion(audioTracks)
                }
            }
        }
    }
    
    static func getAlbumsWithPredicade(predicate: String, completion: @escaping ([AlbumFB])->()) {
        albumsRef.getData { error, snapshot in
            if let error = error {
                print(error.localizedDescription)
            } else {
                guard let snapshot = snapshot else { return }
                var albums: [AlbumFB] = []
                for item in snapshot.children {
                    guard let snapshot = item as? DataSnapshot,
                          let album = AlbumFB(snapshot: snapshot) else { continue }
                    if album.name.lowercased().contains(predicate.lowercased()) {
                        albums.append(album)
                    }
                }
                DispatchQueue.main.async {
                    completion(albums)
                }
            }
        }
    }
    
    static func addAlbumsObserver(completion: @escaping ([AlbumFB]) -> () ) {
        albumsRef.observe(.value) { snapshot in
            var albums: [AlbumFB] = []
            for item in snapshot.children {
                guard let snapshot = item as? DataSnapshot,
                      let album = AlbumFB(snapshot: snapshot) else { continue }
                albums.append(album)
            }
            DispatchQueue.main.async {
                completion(albums)
            }
        }
    }
    
    static func addAudioObserver(completion: @escaping ([TrackFB]) -> () ) {
        FireBaseStorageService.audioRef.observe(.value) { snapshot in
            var tracks = [TrackFB]()
            
            for item in snapshot.children {
                guard let snapshot = item as? DataSnapshot,
                      let track = TrackFB(snapshot: snapshot) else { continue }
                tracks.append(track)
            }
            
            DispatchQueue.main.async {
                completion(tracks)
            }
        }
    }
    
    static func addAudioInAlbumObserver(albumName: String, completion: @escaping ([TrackFB]) -> ()) {
        let ref = FireBaseStorageService.albumsRef.child(albumName)
        ref.observe(.value) { snapshot in
            var tracks: [TrackFB] = []
            for item in snapshot.children {
                guard let snapshot = item as? DataSnapshot,
                      let track = TrackFB(snapshot: snapshot) else { continue }
                tracks.append(track)
            }
            DispatchQueue.main.async {
                completion(tracks)
            }
        }
    }
}
