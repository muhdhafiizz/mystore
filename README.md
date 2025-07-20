# Mystore Assessment

This Flutter app is built as part of the MyStore assessment. It showcases fetching product and category data, managing state using Provider, implementing reusable widgets, and handling loading and error states gracefully.

## Setup Instructions

1. **Clone the repository:**
   ```bash
   git clone https://github.com/muhdhafiizz/mystore-assessment.git
   cd mystore-assessment
2. **Install dependencies**
   ```bash
   flutter pub get
3. **Run**
   ```bash
   flutter run
   
## Project Architecture

- The app follows a simple MVVM-inspired structure.

- State Management: Done using Provider and ChangeNotifier.

- API Calls: Using http package with error handling.

- UI: Declarative widgets, category filtering, pagination, shimmer loading, and cart management.


## Assumptions & Notes

- Categories and products are fetched from https://dummyjson.com.

- The app uses users data from dummyjson
  
- If product list is empty, a "No data available" message is shown.

- Empty states, loading indicators, and errors are all handled in the UI.

- Password visibility toggle uses LoginProvider for state sharing across widgets.

## Time Spent

- Estimated total time: ~8–9 hours

- Project setup: ~1 hour

- State management and services: ~2 hours

- UI layout & styling: ~3 hours

- Features (pagination, category filter, cart): ~2 hours

- Bug fixing & testing: ~1–2 hours

### Thank you for reviewing the submission. Please let me know if you have any questions or feedback
