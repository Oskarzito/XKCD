# XKCD
iOS app using the XKCD API

The project unfortunately took way longer than expected due to badly timed (and prolonged) sickness :(


Deployment target: iOS 15.
Only "fancy" new tech used is Combine. No SwiftUI or async/await.*

Overarching feature documentation:
- Browse random XKCD comics.
- Comics have a detailed view where their transcripts are displayed.
- Comics can be shared.
- There's a button that navigates the user to an explanation of the current comic.
- Comics can be searched for by their ID / number.


The app currently has no particular error handling UI/UX-wise. Although, it has been structured in such a way that error states can be easily added.


Overall UX isn't optimal in my opinion. E.g. the keyboard covers the textfield where input is entered, and custom made buttons don't 
have any explicit selected states.

In other words, pure developer design :)



\* Even though I wanted to use SwiftUI and async/await, due to illness, I wanted to priorotize a working MVP over taking a deep-dive into 
frameworks I'm not as familiar with.
