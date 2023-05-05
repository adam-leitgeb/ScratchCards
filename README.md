# Scratch Cards

This is an iOS application built in Swift, which models a scratch card and its usage. Scratch card has three states: unopened, opened, and activated. The UI of the application has three screens. The first screen displays the current state of the scratch card, and two buttons to navigate to the next two screens. The second screen has a button to simulate the act of scratching the card, revealing a randomly generated UUID code. The third screen has a button to activate the card, which sends the revealed code to an API endpoint for verification. The API response is used to determine whether the scratch card is activated or not.

# Screens

## Home Screen

This is the first screen of the application, which displays the current state of the scratch card and two buttons to navigate to the next two screens.

## Scratch Screen / Activate Screen

This screen has a button to scratch the card and reveal a UUID code, and another button to activate the card by sending the code to an API endpoint. The API response determines whether the card is activated or not. The app has unit tests covering critical parts of the code.

# Architecture

This iOS application follows the MVVM (Model-View-ViewModel) architecture pattern. The Model layer consists of the ScratchCard struct, while the ViewModel layer contains the business logic and the View layer is implemented using SwiftUI. The scratch card states are stored in a SharedStorage class using Combine subject. The API client is implemented using Combine to handle asynchronous operations. 

The application is designed for testability, with critical parts covered by unit tests using XCTest and SwiftUI's built-in preview functionality.

# API

The API endpoint for scratch card activation has the following details:

    URL: "https://api.o2.sk/version"
    Method: GET
    Parameter: "code"
    Authentication: None
    Example response: {"ios": "6.24"}

If the value of "ios" in the response is greater than 6.1, the scratch card in the application transitions to the activated state. Otherwise, an error message is displayed in the notification bar of the device.

# Unit Tests

The critical parts of the application are covered by unit tests.
