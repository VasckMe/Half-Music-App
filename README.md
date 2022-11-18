# Half-Music-App

## Information

Half Music is an open source app
This is my own project at the beginning of my development journey

<p align="center">
<img src="https://user-images.githubusercontent.com/110229952/202712486-002ca097-bb4b-4368-8c80-69d7b17612b2.gif" alt="OnBoarding">
</p>

## Features

- Sign In and Sign up flows with email and password verifycation service
- Onboarding based on SwiftUI
- Small account view with possibility to modify your account data
- MVC Architecture
- Custom UI elements and controllers
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

- Ability to update Stations from server or locally. (Update stations anytime without resubmitting to app store!)
- Displays Artist, Track & Album Art on Lock Screen
- Custom views optimized for SE, 6 and 6+ for backwards compatibility
- Compiles with Xcode 14 & Swift 5
- Parses JSON using Swift Codable protocol
- Background audio performance
- Search Bar that can be turned on or off to search stations
- Supports local or hosted station images
- "About" screen with ability to send email & visit website
- Pull to Refresh stations
- Uses the AVPlayer wrapper library [FRadioPlayer](https://github.com/fethica/FRadioPlayer): 
  * Automatically download Album Art from iTunes API
  * Parses metadata from streams (Track & Artist information)
- Uses [Spring](https://github.com/MengTo/Spring) library:
  * Animate UI components
  * Download and cache images using ImageLoader class

## Requirements

- Xcode 14
- IOS 16
