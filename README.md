# Half-Music-App

## Attention

1. This project need to be updated with new FireBase Realtime DB token
2. The rapid music API also have to be updated

## Information

Half Music is an open source app. 
This is my own project at the beginning of my development journey

<p align="center">
<img src="https://user-images.githubusercontent.com/110229952/202712486-002ca097-bb4b-4368-8c80-69d7b17612b2.gif" alt="OnBoarding" width="200px" height="400px">
  <img src="https://user-images.githubusercontent.com/110229952/203529956-5b9f9b43-3e1e-45c4-9f04-5f1b025f9851.gif" alt="Main App" width="200px" height="400px">

## Possibilities

In my app you can:
- search music
- add music in library
- create albums
- create account
- use working music player for listening, skipping audio tracks

## Features

- Sign In and Sign up flows with email and password verifycation service
- Onboarding based on SwiftUI
- Small account view with possibility to modify your account data
- VIPER Architecture
- Custom UI elements and controllers
- Multithreading (GCD)
- Network Requests
- Cache Managers (For images and url)
- Search bar for audio tracks
- Possibility to create albums with selected audio tracks
- Uses the AVPlayer:
  * Automatically download Audio tracks from open Spotify API https://rapidapi.com/Glavier/api/spotify23/
- Uses Alamofire (https://github.com/Alamofire/Alamofire) and Alamofire Image (https://github.com/Alamofire/AlamofireImage) library:
  * Get data with GET method using AlamoFire Requests
  * Download and Cache images
- Uses FireBase (https://console.firebase.google.com) libraries:
  * Authentication
  * Database for Audio Tracks and Albums
