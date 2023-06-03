# ABN Amro assignment
for this project I decided to create a mac framework to test drive the networking part and then I will create an iOS framework to test drive the iOS implementation of project. At the end I will add a iOS App in to create the compositional root.

## ABN Locations (mac framework)

### Specs:
- [ ] Get list of places that we can navigate from API.
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
