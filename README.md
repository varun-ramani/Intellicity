# Intellicity
A croudsourcing based risk management system built for PennApps 2019

![App Screenshot](./screenshot.jpg)

*A screenshot of the Flutter-based application*

## Inspiration
Each living in a relatively suburban area, we are often quite confused when walking through larger cities. We can each associate with the frustration of not being able to find what seems to be even the simplest of things: a restroom nearby or a parking space we have been driving around endlessly to find. Unfortunately, we can also associate with the fear of danger present in many of these same cities. IntelliCity was designed to accommodate each one of these situations by providing users with a flexible, real-time app that reacts to the city around them.

## What it does
IntelliCity works by leveraging the power of crowdsourcing. Whenever users spot an object, event or place that fits into one of several categories, they can report it through a single button in our app. This is then relayed through our servers and other users on our app can view this report along with any associated images or descriptions, conveniently placed as a marker on a map.

## How we built it
Intellicity relies on a variety of different technologies to function effectively. 
The native Android application was constructed using Flutter and the Google Maps plugin, while the secondary frontend,
a mobile website, swapped Flutter for Bootstrap and web technologies. The backend was written entirely in Python 3 - Flask, MongoDB, and AWS Rekognition served as our web framework, database, and image recognition platform. Instead of using Firebase Cloud Messaging for notifications, we opted to handle them with straightforward SMS messages sent using the Twilio API.

## Challenges we ran into
Although we are quite happy with our final result, there were definitely a few hurdles we faced along the way. One of the most significant of these was properly optimizing our app for mobile devices, for which we were using Flutter, a relatively new framework for many of us. A significant challenge related to this was placing custom, location-dependent markers for individual reports. Another challenge we faced was transmitting the real-time data throughout our setup and having it finally appear on individual user accounts. Finally, a last challenge we faced was actually sending text messages to users when potential risks were identified in their area.