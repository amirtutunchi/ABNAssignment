# ABN Amro assignment
for this project I decided to create a mac framework to test drive the networking part and then I will create an iOS framework to test drive the iOS implementation of project. At the end I will add a iOS App in to create the compositional root.

## ABN Locations (mac framework)
This layer contains most of the logic, I used mac framework to have better test speed, because this layer is platform agnostic and we can reuse it every where, it makes more sense to use Mac framwork in order to not run the iOS simulator for tests in this layer.

### Specs:
- [x] Get list of places that we can navigate from API.
- [ ]  Show list of places
- [ ] Users can add to this list manually

### API Specs:
Url: GET [https://raw.githubusercontent.com/abnamrocoesd/assignment-ios/main/locations.json](https://raw.githubusercontent.com/abnamrocoesd/assignment-ios/main/locations.json)

response: on 200 response (✅) 
```json
{
  "locations": 
  [
    {
      "name": "Amsterdam",
      "lat": 52.3547498,
      "long": 4.8339215
    },
    {
      "name": "Mumbai",
      "lat": 19.0823998,
      "long": 72.8111468
    },
    {
      "name": "Copenhagen",
      "lat": 55.6713442,
      "long": 12.523785
    },
    {
      "lat": 40.4380638,
      "long": -3.7495758
    }
  ]
}
```

### Place

|Property|Type|
|-----|-----|
|`name`| `String(optional)`|
|`lat`|`Double`|
|`long`|`Double`|

## Location Presentation
The presentation layer is platform agonostic, it can be reuse for any platform(mac, iOS, watchOS) and any technology (UIKit, SwiftUI).

## ABNLocationiOS
This layer is iOS specific implementation, In this layer we can use Swift UI or UIKit to implement iOS releated codes.

