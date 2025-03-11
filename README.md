# GitHub Repositories App
This iOS app displays a list of GitHub repositories for Square Inc, fetched from the GitHub API. It supports pagination, local storage using CoreData, and a bookmarking feature to save favorite repositories locally. The app is built using UIKit, Combine, and CoreData.

#Features
#Task 1: Display a List of GitHub Repositories
Repositories Screen:

• Fetches repositories from the GitHub API (https://api.github.com/orgs/square/repos).
• Displays repository name and star count in a UITableView.
• Supports pagination to load additional repositories as the user scrolls.
• Stores data locally using CoreData for offline access.
• Handles loading, success, and error states with a loading spinner and error messages.
• Repository Details Screen:
• Displays repository name and star count.
• Uses Combine for reactive data handling (no data passed via bundles).

# Task 2: Bookmarks
Add/Remove Bookmarks:

• A bookmark button in the details screen allows users to save or remove repositories locally.

Bookmark Icon:

• A bookmark icon (e.g., a filled star) is shown next to bookmarked repositories in the list.

# Additional Features
Micro-Interactions:

• Bounce animation for the bookmark button.
• Scale animation for the profile button.

Haptic Feedback:

• Light feedback on button taps.

# Code Structure
Models
Repository: Represents the repository data fetched from the API.

RepositoryEntity: Represents the CoreData entity for local storage.

ViewModels
RepositoriesViewModel: Manages the list of repositories and handles pagination.

RepositoryDetailsViewModel: Manages the repository details and bookmark state.

ViewControllers
RepositoriesViewController: Displays the list of repositories.

RepositoryDetailsViewController: Displays the repository details and handles bookmarking.

# Networking
GitHubService: Handles API requests and JSON parsing.

# CoreDataManager
Manages local storage operations, including saving and fetching repositories and bookmarks.

#Setup Instructions
Prerequisites
• Xcode 13 or later.
• iOS 15 or later.

# Steps to Run the Project
Clone the repository:

bash
Copy
git clone https://github.com/your-username/github-repositories-app.git
Open the project in Xcode:

Navigate to the project folder and open GitHubRepositoriesApp.xcodeproj.

# Build and run the app:
• Select a simulator or physical device and click the Run button in Xcode.

# Explore the app:
• The app will fetch repositories from the GitHub API and display them in a list.
• Tap on a repository to view its details and toggle the bookmark button.

# Documentation
• Each class, method, and property is documented with clear descriptions.
• MARK comments are used to organize the code into logical sections (e.g., // MARK: - Lifecycle).

# Screenshots
# Repositories Screen	
![Simulator Screenshot - iPhone 16 Pro - 2025-03-12 at 03 14 34](https://github.com/user-attachments/assets/099932e5-dd20-4fa6-b04f-85a8ed088ea8)

# Repository Details Screen
![Simulator Screenshot - iPhone 16 Pro - 2025-03-12 at 03 14 36](https://github.com/user-attachments/assets/6a056e62-c410-48a2-b5a1-fa10ded03917)


# Future Enhancements
• Add search functionality to filter repositories by name.

• Implement pull-to-refresh for the repositories list.

• Add unit tests for ViewModels and networking layer.

# License
This project is licensed under the MIT License. See the LICENSE file for details.

Feel free to reach out if you have any questions or feedback!
