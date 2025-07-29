# Multi Timer App

## Overview
The Multi Timer App is a Flutter application designed to manage multiple timers simultaneously. Each timer can be configured as either a "Timed" timer or a "Hit" timer, providing flexibility for various timing needs. Users can start, stop, and reset timers, as well as add time with the HIT control for Hit timers.

## Features
- Multiple timers with individual controls
- Dropdown selection for "Timed" or "Hit" modes
- Start, stop, and reset controls for Timed timers
- HIT control for Hit timers that adds 1.5 seconds to the timer
- Editable labels for each timer
- Total time counter that sums the elapsed time of all timers
- Ability to add more timers dynamically

## Project Structure
```
multi_timer_app
├── lib
│   ├── main.dart
│   ├── models
│   │   └── timer_model.dart
│   ├── widgets
│   │   ├── timer_widget.dart
│   │   ├── timer_list_widget.dart
│   │   └── total_time_widget.dart
│   └── utils
│       └── time_formatter.dart
├── pubspec.yaml
└── README.md
```

## Setup Instructions
1. Clone the repository:
   ```
   git clone <repository-url>
   ```
2. Navigate to the project directory:
   ```
   cd multi_timer_app
   ```
3. Install the dependencies:
   ```
   flutter pub get
   ```
4. Run the application:
   ```
   flutter run
   ```

## Usage
- Launch the application to view the main screen with timers.
- Use the dropdown next to each timer to select between "Timed" and "Hit."
- For Timed timers, use the start, stop, and reset buttons to control the timer.
- For Hit timers, press the HIT button to add 1.5 seconds to the timer.
- Edit the timer labels by clicking on them.
- Add new timers using the provided button.

## Contributing
Contributions are welcome! Please feel free to submit a pull request or open an issue for any enhancements or bug fixes.

## License
This project is licensed under the MIT License. See the LICENSE file for more details.