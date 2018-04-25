# DailyCommute

## Daily commute utilizes the Strava API to authorize an Athlete and upload an Activity.

### Libraries used: Alamofire, SwiftyJSON
### Partial libraries used: StravaSwift - I extracted only what I needed from this library to keep the code base light. The main benefits of using this was the intial configuration when authorizing an Athlete.

### Going forward I would improve the callbacks in the StravaSwift library so they are more defined for success/failure cases. Add more failure case for no network, or upload failures.

## Running the App

### Clone the repository and open the `DailyCommute.xcworkspace` project. The use case is fairly straight forward. First authorize via the Strava login. From there you should see a detailed list of your past activities. Create a new activity or daily commute by pressing the `Track` button. You will be prompted to allow location services (I kept them as `only when the app is in use` for this simple use case), after allowing location services start your commute. 

When finished press `Stop Commute` and save your activity. The view will dismiss and refresh the main list of activities.


