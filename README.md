[![CI](https://github.com/amirtutunchi/ABNAssignment/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/amirtutunchi/ABNAssignment/actions/workflows/CI.yml)

# ABN Amro Assignment

To ensure a smooth experience and avoid any potential issues, please use Xcode 14.3 for this assignment.


## Instructions:

To get started with the ABNLocationApp, please follow these steps:

1. Clone and run the Wikipedia app from this [repository](https://github.com/amirtutunchi/wikipedia-iOS) on your simulator. If you would like to see my modifications to the Wikipedia repository, you can visit this [link](https://github.com/amirtutunchi/wikipedia-iOS/commit/f6645d4ed7784f9f4268fe91d5ac4241146cb1ce).

2. Once you have the Wikipedia app set up, open the ABN.wcworkspace file in Xcode. Then, select the ABNLocationAPP scheme and run it on your simulator.

3. In the ABNLocationApp, you can navigate from the location list to Wikipedia by tapping on the desired location.

4. Alternatively, you can send a deep link to the Wikipedia app by running the following command in your terminal:

```bash
xcrun simctl openurl booted "wikipedia://places/?latitude=34.0335387&longitude=-118.8366035"
```

### Specifications:

- [x] Fetch a list of places from the API.
- [x] Display the list of places.
- [x] Allow users to manually navigate to a specific location.

This project demonstrates my skills in creating modular solutions. It consists of three modules responsible for displaying a list of locations. Below is a brief introduction on how I organized the codebase.

## ABNLocation Module
This module contains two frameworks: ABNLocations and ABNLocationiOS. Although they are kept in one project for simplicity, they can be easily separated into individual projects.

### ABNLocations Framework
This framework is designed for macOS and offers faster build and test times. All the code in this layer is platform-agnostic, meaning it can be reused across various platforms such as macOS, iOS, iPadOS, and more. The presentation layer within this framework is not tightly coupled with any specific UI framework (e.g., SwiftUI or UIKit), providing flexibility for reuse with different UI frameworks.

### ABNLocationiOS Framework
This iOS-specific framework contains code tailored for the iOS platform. It includes UIKit views that implement protocols from the presentation layer in the ABNLocations framework. In addition, this layer incorporates snapshot tests. I used an iPhone 14 running iOS 16.4 to record these tests. By using snapshot tests, I test-drove the UI and ensured that the snapshots support both dark mode and light mode.

Please note that this structure allows for easy expansion and adaptation to other platforms while maintaining code consistency and reusability across different frameworks.

## ABNLocationApp

The ABNLocationApp serves as the compositional root, bringing together all the frameworks to create a fully functional executable app. This layer plays a crucial role in managing the application's dependencies and ensures smooth integration between various components.

One notable feature of the ABNLocationApp is the implementation of important integration tests. These tests thoroughly examine the app's behavior and validate that all expected functionalities are working as intended. By conducting these tests, any potential issues or bugs can be identified and resolved promptly.

In this layer, I leveraged the Combine framework to create an adaptor for seamless communication between the presentation layer and the API layer.

Please note that this compositional root showcases the culmination of all the modules, frameworks, and their interactions, providing a robust foundation for the ABNLocationApp.


### API Specifications:
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

## CI

For continuous integration, I have created a schema that encompasses all the test suites from each framework. This schema ensures that all tests are executed and validates the correctness of the codebase. To automate this process, I utilize GitHub Actions, which runs the schema for each pull request (PR). This ensures that any changes introduced in the PR do not break existing functionality.

To keep track of the test status, you can refer to the badge at the beginning of this document. The badge provides a visual indication of the current test status, allowing you to quickly assess the health of the codebase.

## Final Thoughts

During the course of this project, I may have implemented certain architectural designs that could be perceived as slightly over-engineered. However, my intention behind these decisions was to demonstrate my proficiency in designing various solutions and addressing complex challenges.

I would like to extend my heartfelt thanks for reviewing this project. I highly value your feedback and would greatly appreciate hearing your thoughts.
