# 🚛 Farm Sync

## 📘 Application Overview

Farm Sync is a mobile application designed to streamline logistics and route optimization for field teams, including drivers, loaders, and merchandisers. The app enables users to view and manage shipment details assigned to optimized routes, load items accordingly, and navigate commercial delivery paths with precision using HERE Maps. Drivers can start routes, follow real-time navigation, and manage operations more efficiently across delivery points.

## ⚙️ Tech Stack

### Frontend

* **Framework**: Flutter (Cross-platform for Android & iOS)
* **State Management**: GetX, Provider
* **Routing & Navigation**: HERE Map SDK (Commercial Navigation)
* **Backend Communication**: RESTful API Integration using `dio`
* **Authentication**: Custom API-based
* **Push Notifications**: Firebase Cloud Messaging (FCM)

### Other Tools & Integrations

* **Image & Hand Signature Upload**: `image_picker`, `hand_signature`
* **PDF Handling**: `dio`, `open_file` (for downloading and opening documents)
* **Maps & Location Services**: `here_sdk`, `geolocator`, `location`, `geocoding`
* **Real-Time Communication**: `pusher_client` (for socket-based updates)
