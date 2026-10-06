# SocietyHub - Complete Gated Community & Society Management App

> **Master Blueprint (A to Z):** Full-fledged housing society & building maintenance app for Residents, Admins, Managers, Accountants, Committee Members, and Security Guards.  
> **Backend API URL:** `https://bahikhata.webenhancehub.com/api/v1`  
> **Repository:** [opgupta1993-code/societyhub](https://github.com/opgupta1993-code/societyhub.git)

---

## 🌟 Key Features & Supported Roles

- **🔐 OTP Authentication & Role-Based Access Control (RBAC):**
  - Live OTP request & verification via `POST /api/v1/auth/request-otp` and `POST /api/v1/auth/verify-otp`.
  - Supports 6 App Roles: **Resident** (Default), **Society Admin**, **Estate Manager**, **Accountant**, **Committee Member**, and **Security Guard**.
  - Dynamic Role Switcher on Dashboard allowing users to switch active views seamlessly.

- **📱 56 Mapped Screen Inventory:**
  - **Common (A1 - A5):** OTP Login, Registration, Dynamic Home Dashboard, Notifications Center, Profile & Settings.
  - **Resident (B1 - B14):** My Accounts/Dues, Complaints, Gate Pass & Visitor Invites, Notices, Polls, Amenity Booking, Directory, Contacts.
  - **Rent & Records Sharing (C1 - C11):** Rent Payments, Charges Breakup, Receipts Generator, Landlord Read-only Access & Link Revoking.
  - **Admin Panel (D1 - D7):** HR Users List, Role Assignment, Roles & Permissions Matrix, Society Settings, Audit Log.
  - **Estate Manager Desk (E1 - E5):** Complaint Queue Dispatch, Amenity Approvals, Notice Publisher.
  - **Accountant Console (F1 - F5):** Batch Maintenance Bill Generator, Collections & Cash Entries, Expense Logger, P&L/Defaulter Reports.
  - **Committee (G1 - G4):** Governance Polls, AGM Meetings & Minutes of Meeting (MoM).
  - **Security Guard Desk (H1 - H5):** Camera QR Scanner, Walk-in Entry Desk, Live Resident Approval Monitor, Gate Logbook, Vehicle Check.

---

## 🛠️ Architecture & Tech Stack

- **Framework:** Flutter (Material 3)
- **State Management:** Riverpod (`flutter_riverpod`)
- **Navigation & Guarding:** GoRouter (`go_router`)
- **HTTP Client:** Native `http` package
- **Typography & Theme:** Google Fonts (`Inter`)

---

## 🚀 Getting Started

### Prerequisites
- Flutter SDK `^3.12.2` or later
- Dart SDK `^3.12.0`

### Installation & Run

```bash
# 1. Clone repository
git clone https://github.com/opgupta1993-code/societyhub.git
cd societyhub

# 2. Get dependencies
flutter pub get

# 3. Run application
flutter run
```

---

## 🧪 Testing & Code Quality

```bash
# Run static code analysis
flutter analyze

# Run unit & widget tests
flutter test
```
