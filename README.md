<p align="center">
  <h1>Augmented Card</h1>
</p>
<p align="center">
    <img src="https://img.shields.io/badge/Swift-4.2-orange.svg?style=flat" />
    <img src="https://img.shields.io/badge/iOS-12.0+-informational.svg?style=flat" />
    <img src="https://img.shields.io/badge/Updated-07.01.2019-red.svg?style=flat" />
    <img src="https://img.shields.io/badge/Release-0.7.1-critical.svg?style=flat" />
</p>

<p align="center">
    <img src="demo.gif" width="400" max-width="90%" alt="Augmented Card Demo Gif" />
</p>

## About

The app will take a photo of the business card, through vision framework I'll get the frame and with the help of ML and TextDetectors I am able to figure out where the name, e-mail adress and phone number is. 

Using email I download user Gravatar, if there isn't any - I'm taking first picture from Google Images.

I am using Firebase Vision framework for OCR work, as this was developed before Apple introduced in-house OCR.
This was a proof of concept for my idea, hence you will find some code smells inside. Please disregard them :)

## Help

If you don't understand the code or there is some other issue that you would like to discuss feel free to drop an e-mail at
`marcelmierzejewski@gmail.com`
