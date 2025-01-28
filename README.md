# Particle Animation

**A stunning particle animation effect inspired by text and user interaction, built with Flutter.**

This project demonstrates how to create a visually appealing particle animation where particles form a text shape and respond to user gestures. It’s a perfect example of combining Flutter's animation, gesture detection, and custom painting capabilities to create dynamic and interactive visuals.

## Features

- **Text-to-Particle Animation**: Particles dynamically form the shape of a given text.
- **Interactive Gestures**: Particles react to user drag gestures, creating a fluid and engaging experience.
- **Customizable Parameters**: Adjust particle count, density, and animation behavior to suit your needs.
- **Haptic Feedback**: Provides subtle haptic feedback during user interaction for a tactile experience.
- **Cross-Platform**: Built with Flutter, it works seamlessly on iOS, Android, and the web.

## How It Works

The animation uses Flutter's `CustomPainter` to render particles on a canvas. Particles are generated based on the alpha values of a rendered text image, ensuring they align perfectly with the text shape. The particles then animate back to their base positions or respond to user drag gestures, creating a mesmerizing effect.

## Installation

1. Clone the repository:
   ```bash
   https://github.com/SLBDEVELOPERS/Particle-Animation.git

2. Navigate to the project directory:
   ```bash
   cd particle-animation

3. Install dependencies:
   ```bash
   flutter pub get
4. Run the app:
   ```bash
   flutter run

## Usage

Replace the text parameter in the ParticleAnimation widget with your desired text:
  ```bash
  ParticleAnimation(text: "Your Text Here")
