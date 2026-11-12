# 🍔 CampusBites – College Canteen Ordering App

**CampusBites** is a Flutter-based mobile application designed to simplify the food-ordering experience within a college campus. It provides students with a convenient way to explore canteen food items, manage their cart, select pickup or delivery, place orders, and view their previous orders through a clean and user-friendly mobile interface.

The application aims to make traditional college canteen ordering more organized, accessible, and convenient by bringing essential food-ordering functionalities into a single mobile application.

<p align="center">
  <strong>Built with Flutter & Dart</strong><br>
  A smarter and simpler way to order campus food!
</p>

---

## 📌 Table of Contents

- [Project Overview](#-project-overview)
- [Problem Statement](#-problem-statement)
- [Project Objectives](#-project-objectives)
- [Key Features](#-key-features)
- [Application Screens](#-application-screens)
- [Application Workflow](#-application-workflow)
- [Technology Stack](#-technology-stack)
- [Project Architecture](#-project-architecture)
- [Data Management and Persistence](#-data-management-and-persistence)
- [Order Calculation Logic](#-order-calculation-logic)
- [Application Design](#-application-design)
- [Installation and Setup](#-installation-and-setup)
- [Running the Application](#-running-the-application)
- [Building the APK](#-building-the-apk)
- [Testing and Validation](#-testing-and-validation)
- [Project Limitations](#-project-limitations)
- [Future Enhancements](#-future-enhancements)
- [Project Repository](#-project-repository)
- [APK Download](#-apk-download)
- [Author](#-author)
- [Acknowledgements](#-acknowledgements)

---

## 📖 Project Overview

CampusBites is a mobile application developed using the Flutter framework and Dart programming language.

The application is designed specifically for a college canteen environment, where students can browse available food items, check their prices and ratings, add products to their cart, choose their preferred order type, and place orders.

The application provides a structured ordering experience through different screens, including Home, Menu, Cart, Checkout, Order Confirmation, Order History, and Profile.

CampusBites also incorporates local data persistence using SharedPreferences, allowing important application information such as cart items, placed orders, and profile details to remain available even after closing and reopening the application.

The application follows a modern orange-and-white visual theme with clean layouts, rounded cards, intuitive navigation, and user-friendly controls.

## 🎯 Problem Statement

Traditional college canteen ordering can involve several inconveniences, including:

- Students having to visit the canteen physically to explore available food items.
- Difficulty in managing food selections and calculating the total bill.
- Lack of an organized interface for managing orders.
- Limited convenience when choosing between pickup and delivery.
- Difficulty accessing previously placed order information.

CampusBites addresses these challenges by providing a centralized mobile interface through which students can browse food items, manage their selections, calculate order costs, and maintain their order history.

## 🎯 Project Objectives

The primary objectives of CampusBites are:

1. To develop a user-friendly mobile application for college canteen food ordering.
2. To provide an organized menu with food categories, descriptions, prices, and ratings.
3. To implement cart functionality with quantity management.
4. To provide pickup and delivery order options.
5. To calculate item totals, delivery charges, packaging fees, and final order amounts.
6. To provide a checkout interface with multiple payment-method selections.
7. To maintain order records and display previous orders.
8. To allow users to manage their profile information.
9. To implement persistent local storage so important information remains available after application restarts.
10. To create a responsive and visually appealing application using Flutter.

---

## ✨ Key Features

### 1. Home Screen

The Home Screen acts as the main dashboard of the application.

Features include:

- Personalized greeting using the saved profile name.
- CampusBites branding and application title.
- Food search interface.
- Promotional banner displaying an introductory discount offer.
- Food categories such as Snacks, Meals, Drinks, and Desserts.
- Popular food items displayed on the home screen.
- Quick navigation to the main application sections.

### 2. Food Menu

The Menu Screen allows students to explore the available food items.

Features include:

- Display of food items with images or food illustrations.
- Food names and descriptions.
- Individual item prices.
- Food ratings.
- Category-based filtering.
- Add-to-cart functionality.
- Navigation to the cart.

### 3. Shopping Cart

The Cart Screen allows users to review and manage their selected food items.

Features include:

- Display of all selected food items.
- Product name, description, and price.
- Quantity adjustment using increment and decrement controls.
- Removal of individual cart items.
- Clear-cart functionality.
- Selection between Pickup and Delivery.
- Automatic calculation of delivery and packaging charges.
- Display of the total payable amount.
- Proceed-to-checkout functionality.

### 4. Checkout

The Checkout Screen provides a summary of the order before confirmation.

Features include:

- Detailed order summary.
- Individual food item quantities and prices.
- Item subtotal.
- Delivery fee calculation.
- Packaging fee calculation.
- Final order amount.
- Pickup and Delivery selection.
- Payment-method selection.

The available payment-method options are:

- UPI
- Credit/Debit Card
- Cash

**Note:** The current version implements payment-method selection in the application interface. It does not include a live payment gateway or actual online payment processing.

### 5. Order Confirmation

After an order is placed, the application displays an Order Success Screen.

Features include:

- Order placement confirmation.
- Unique order identification number.
- Total order amount.
- Selected payment method.
- Selected order type.
- Estimated food preparation time.
- Navigation back to the Home Screen.
- Option to continue shopping.

### 6. Order History

The Order History Screen allows users to access previously placed orders.

Features include:

- Display of previously placed orders.
- Unique order IDs.
- Order dates.
- Ordered food items.
- Total order amounts.
- Order status information.
- Order status filters:
  - All
  - Preparing
  - Delivered
  - Cancelled
- View Details option for individual orders.
- Reorder functionality to add previously ordered items back to the cart.

### 7. User Profile

The Profile Screen provides a dedicated area for managing user information.

Features include:

- Display of the user's profile information.
- Editable profile name.
- Editable email address.
- Editable phone number.
- Save Profile functionality.
- Persistent storage of updated profile information.
- Access to the user's order history.

---

## 📱 Application Screens

The following screens represent the major modules of CampusBites.

| Screen | Description |
|---|---|
| Home Screen | Displays personalized greeting, promotional banner, categories, search, and popular food items. |
| Menu Screen | Displays available food items with prices, ratings, descriptions, and category filters. |
| Cart Screen | Manages selected items, quantities, order type, and bill calculation. |
| Checkout Screen | Displays order summary, order type, and payment-method selection. |
| Order Success Screen | Confirms successful order placement and displays order details. |
| Order History Screen | Displays previous orders, status filters, details, and reorder functionality. |
| Profile Screen | Displays and manages user profile information. |

---

## 🔄 Application Workflow

The application follows a simple food-ordering workflow:

1. The user opens the CampusBites application.
2. The Home Screen displays food categories and popular items.
3. The user navigates to the Menu Screen.
4. The user explores available food items.
5. Selected food items are added to the shopping cart.
6. The user reviews the cart and modifies item quantities if required.
7. The user selects Pickup or Delivery.
8. The application calculates the order amount, including applicable charges.
9. The user proceeds to the Checkout Screen.
10. The user reviews the order summary and selects a payment method.
11. The user confirms the order.
12. The application generates an order ID and displays the Order Success Screen.
13. The placed order is stored locally and becomes available in Order History.
14. The user can view previous order details or reorder items.

---

## 🛠️ Technology Stack

| Technology | Purpose |
|---|---|
| Flutter | Cross-platform mobile application framework |
| Dart | Primary programming language |
| Material Design | UI components and interface design |
| Android Studio | Development environment |
| SharedPreferences | Persistent local data storage |
| Provider-style ListenableBuilder integration | Updating UI based on shared application state |
| flutter_launcher_icons | Generating the custom Android launcher icon |
| Git and GitHub | Version control and project hosting |

### Development Environment

- Operating System: macOS
- Development IDE: Android Studio
- Flutter SDK: 3.47.0
- Dart SDK: 3.13.0
- Testing Platform: Android Emulator and Android device
- Build Format: Android APK

---

## 🏗️ Project Architecture

CampusBites follows a modular Flutter project structure. Application screens, shared state management, and application configuration are organized separately to improve readability and maintainability.

### Important Project Directories

```text
CampusBites/
│
├── android/
│   └── Android-specific project configuration
│
├── assets/
│   └── icons/
│       └── app_icon.png
│
├── lib/
│   │
│   ├── main.dart
│   │
│   ├── state/
│   │   └── app_state.dart
│   │
│   └── screens/
│       ├── home_screen.dart
│       ├── menu_screen.dart
│       ├── cart_screen.dart
│       ├── order_confirmation_screen.dart
│       ├── order_history_screen.dart
│       └── profile_screen.dart
│
├── test/
│   └── widget_test.dart
│
├── pubspec.yaml
├── pubspec.lock
├── analysis_options.yaml
└── README.md
```

*Note: The tree highlights the main application files and directories; additional project files may be present.*

### Main Components

**main.dart**

- Entry point of the Flutter application.
- Initializes Flutter bindings.
- Initializes the application state and local storage.
- Configures the application theme and navigation.

**app_state.dart**

- Contains shared application state.
- Defines cart and order data models.
- Manages cart operations.
- Manages order placement.
- Handles order history.
- Loads and saves persistent application data.

**screens/**

Contains the individual UI screens responsible for displaying and managing different application modules.

---

## 💾 Data Management and Persistence

CampusBites uses SharedPreferences to store selected application data locally on the device.

The application maintains shared state through an `AppState` singleton that extends `ChangeNotifier`.

### Cart Data Management

The cart supports:

- Adding food items.
- Updating item quantities.
- Removing items.
- Clearing the cart.
- Saving and restoring cart information.

The cart is stored using the following SharedPreferences key:

```dart
_c​​artKey = 'campusbites_cart';
```

### Order Data Management

The application defines a `CampusOrder` data model to represent placed orders.

Order information includes:

- Order ID.
- Ordered food items.
- Total order amount.
- Order type.
- Payment method.
- Order status.
- Order placement date and time.

Orders are serialized into JSON format before being stored locally.

The order history is maintained using:

```dart
_ordersKey = 'campusbites_orders';
```

### Profile Data Management

The user's profile information is stored using SharedPreferences.

The following keys are used:

```text
profile_name
profile_email
profile_phone
```

When the user updates profile information, the changes are saved locally and loaded again when the application is reopened.

### Application Initialization

During application startup:

1. Flutter bindings are initialized.
2. SharedPreferences data is loaded.
3. Existing cart information is restored.
4. Previously placed orders are restored.
5. The application is launched after initialization is completed.

**Storage Scope:** The current implementation uses local device storage. Data is not synchronized across multiple devices or users through an online backend.

---

## 🧮 Order Calculation Logic

CampusBites automatically calculates the order amount based on the selected items and order type.

### 1. Item Total

The item total is calculated by multiplying each food item's price by its selected quantity.

**Formula:**

`Item Total = Sum of (Item Price × Quantity)`

### 2. Delivery Fee

The application applies the following delivery-fee rules:

- Pickup: Free delivery.
- Delivery with an item subtotal of ₹300 or more: Free delivery.
- Delivery with an item subtotal below ₹300: ₹30 delivery fee.

### 3. Packaging Fee

- ₹10 packaging fee is applied when the cart contains items.

### 4. Final Order Amount

`Final Amount = Item Total + Delivery Fee + Packaging Fee`

### Example Calculation

| Description | Amount |
|---|---:|
| Veg Pizza × 2 | ₹240 |
| Veg Burger × 1 | ₹60 |
| Item Total | ₹300 |
| Delivery Fee | FREE |
| Packaging Fee | ₹10 |
| **Final Amount** | **₹310** |

The actual total is recalculated based on the user's cart contents and selected order type.

---

## 🎨 Application Design

CampusBites follows a modern and minimal design approach.

### Color Palette

| Color | Hex Code | Usage |
|---|---|---|
| Primary Orange | `#FF6B00` | Primary buttons and highlights |
| White | `#FFFFFF` | Cards and backgrounds |
| Light Background | `#FAFAFA` | Main screen background |
| Pale Orange | `#FFF0E1` | Category cards and highlighted sections |

### Design Principles

- Simple and intuitive navigation.
- Consistent orange-and-white color theme.
- Rounded cards and buttons.
- Clear typography and readable text.
- Appropriate spacing between UI components.
- Consistent icons and food illustrations.
- User-friendly interaction controls.
- Consistent styling across application screens.

### Custom Application Icon

A custom CampusBites launcher icon was designed using the application's branding and orange color theme.

The `flutter_launcher_icons` package was used to generate the Android launcher icon and replace the default Flutter application icon.

---

## ⚙️ Installation and Setup

Follow the instructions below to run CampusBites locally.

### Prerequisites

Install the following tools:

- Flutter SDK
- Dart SDK
- Android Studio
- Android SDK
- Git

Verify the Flutter installation:

```bash
flutter doctor
```

### Step 1 – Clone the Repository

```bash
git clone https://github.com/harikiran-8679/Campus-Bites.git
```

### Step 2 – Navigate to the Project Directory

```bash
cd Campus-Bites
```

### Step 3 – Install Dependencies

```bash
flutter pub get
```

### Step 4 – Run the Application

Connect an Android device or start an Android emulator.

```bash
flutter run
```

---

## 📦 Building the APK

To generate a release version of the Android application, execute:

```bash
flutter build apk --release
```

After the build completes successfully, the generated APK will be available at:

```text
build/app/outputs/flutter-apk/app-release.apk
```

The APK can be transferred to a compatible Android device and installed for testing.

---

## 🧪 Testing and Validation

The application was tested using an Android emulator and an Android device.

The following functionalities were checked:

| Test Case | Expected Result |
|---|---|
| Application Launch | Application opens successfully. |
| Home Screen | Home dashboard and food categories are displayed. |
| Menu Navigation | Menu screen displays food items. |
| Add to Cart | Selected food items are added to the cart. |
| Quantity Management | Item quantities can be increased or decreased. |
| Remove Cart Item | Selected cart item is removed. |
| Order Type Selection | Pickup and Delivery options can be selected. |
| Bill Calculation | Item total and applicable charges are calculated correctly. |
| Checkout | Order summary and payment options are displayed. |
| Order Placement | Order confirmation is displayed with an order ID. |
| Order History | Previously placed orders are displayed. |
| View Order Details | Selected order information is displayed. |
| Reorder | Previously ordered items can be added to the cart again. |
| Profile Editing | User profile details can be updated. |
| Data Persistence | Cart, orders, and profile information remain available after restarting the application. |
| Launcher Icon | Custom CampusBites icon is displayed. |

### Code Analysis

The Flutter analyzer was executed to check the application for code issues.

```bash
flutter analyze
```

**Result:**

```text
Analyzing campusbites...
No issues found!
```

The release APK was also generated and tested successfully.

---

## ⚠️ Project Limitations

The current version of CampusBites is a client-side mobile application with local data persistence.

The following limitations apply:

- No online backend or cloud database is integrated.
- Cart, order, and profile information are stored locally on the device.
- Data is not synchronized between multiple devices.
- UPI and Card are payment-method selections only; no real payment gateway is integrated.
- Cash is recorded as a selected payment method; no actual payment collection system is integrated.
- Order status is maintained within the application's local order records and is not updated by a live canteen management system.
- The application does not include a live delivery tracking service.
- Food availability is not synchronized with an actual canteen inventory system.

---

## 🚀 Future Enhancements

CampusBites can be extended with additional features to make it suitable for real-world college canteen deployment.

Potential enhancements include:

1. **Backend Integration:** Integrate Firebase, Supabase, or a custom backend for centralized data management.
2. **User Authentication:** Implement secure student registration, login, and account management.
3. **Real-Time Menu Updates:** Allow canteen administrators to manage food items, prices, and availability.
4. **Payment Gateway Integration:** Integrate secure UPI and card payment processing.
5. **Order Tracking:** Provide real-time order status updates.
6. **Canteen Admin Dashboard:** Develop an administrative interface to manage incoming orders.
7. **Push Notifications:** Notify users when their orders are accepted, prepared, or ready for pickup.
8. **Coupon Management:** Implement functional promotional codes and discount calculations.
9. **Order Analytics:** Provide insights into popular food items and order trends.
10. **Multi-Canteen Support:** Extend the application to support multiple canteens within a campus.

---

## 🔗 Project Repository

**GitHub Repository:**

[https://github.com/harikiran-8679/Campus-Bites](https://github.com/harikiran-8679/Campus-Bites)

The repository contains the CampusBites Flutter application source code and project configuration.

## 📥 APK Download

**Download CampusBites for Android:**

[Download CampusBites APK](https://drive.google.com/file/d/1Ybmjx7UpGoLt5UqBqXhNx-RF_TPWsnbi/view?usp=drive_link)

Download the APK using the link above and install it on a compatible Android device.

---

## 👨‍💻 Author

**Boda Venkata Hari Kiran**

- **Project Name:** CampusBites
- **Roll Number:** 25PA5A0507
- **Department:** Computer Science and Engineering
- **Section:** CSE-A
- **Institution:** Vishnu Institute of Technology, Bhimavaram

**GitHub:** [harikiran-8679](https://github.com/harikiran-8679)

---

## 🙏 Acknowledgements

I would like to express my sincere gratitude to **Vishnu Institute of Technology, Bhimavaram**, the Department of Computer Science and Engineering, and our course instructor for providing the opportunity to develop this project as part of the User Interface Design using Flutter course.

I also acknowledge the Flutter and Dart communities for providing the tools, documentation, and resources that supported the development of CampusBites.

---

<p align="center">
  <strong>CampusBites – Your Campus. Your Cravings. One App.</strong>
  <br>
  <sub>Developed with ❤️ using Flutter and Dart.</sub>
</p>