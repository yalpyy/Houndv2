# HOUND — TODO / Remaining Tasks

## High Priority

### Integration
- [ ] Connect all screens to live Supabase data (currently using mock/placeholder data)
- [ ] Wire up auth flow with Supabase Auth (email/password)
- [ ] Replace mock data in discovery screen with `discoveryDogsProvider`
- [ ] Replace mock data in requests inbox with `receivedIntrosProvider` / `sentIntrosProvider`
- [ ] Connect Add Dog form to `DogRepository.createDog()`
- [ ] Connect Edit Dog form to `DogRepository.updateDog()`
- [ ] Wire chat screen to `ChatRepository` with live Supabase Realtime
- [ ] Connect walk planning form to `WalkRepository.createProposal()`

### Navigation Guards
- [ ] Implement route guards using `appNavigationStateProvider`
- [ ] Auto-redirect to waitlist/add-dog/discovery based on user state
- [ ] Block discovery access if no dog profile exists
- [ ] Disable intro buttons when dog is under review

### Image Upload
- [ ] Implement dog photo upload with `image_picker`
- [ ] Implement verification document upload with `file_picker`
- [ ] Implement avatar upload on profile page

## Medium Priority

### Missing Application Steps
- [ ] Complete application steps 2-5 (currently step 1 is detailed, 2-5 are placeholder)
- [ ] Add city/circle dropdown with data from `circles` table
- [ ] Add form validation across all forms

### UI Polish
- [ ] Add shimmer loading states for all data-dependent screens
- [ ] Add pull-to-refresh on discovery and requests screens
- [ ] Add empty state illustrations
- [ ] Add error state handling with retry buttons
- [ ] Implement dark mode toggle
- [ ] Add page transitions and animations (flutter_animate)
- [ ] Add haptic feedback on key interactions

### Chat Enhancements
- [ ] Image sharing in chat
- [ ] Typing indicators
- [ ] Unread message count badge on bottom nav
- [ ] Message read receipts (blue checkmarks)
- [ ] Push notifications for new messages

### Walk Planning
- [ ] Interactive map integration for circle selection
- [ ] Walk proposal notifications
- [ ] Walk history view
- [ ] Calendar integration

## Low Priority

### Admin
- [ ] Admin panel for application review
- [ ] Admin panel for dog verification
- [ ] Admin analytics dashboard
- [ ] Content moderation tools

### Premium Features
- [ ] In-app purchase integration (RevenueCat or similar)
- [ ] Premium feature gating logic
- [ ] Premium profile badges

### Testing
- [ ] Unit tests for repositories
- [ ] Unit tests for providers
- [ ] Widget tests for key screens
- [ ] Integration tests for core flows

### Performance
- [ ] Image caching optimization
- [ ] Pagination for discovery feed
- [ ] Pagination for chat messages
- [ ] Lazy loading for lists

### Localization
- [ ] Extract hardcoded Turkish strings to localization files
- [ ] Add English locale support
- [ ] RTL support consideration

### DevOps
- [ ] CI/CD pipeline setup
- [ ] Automated testing in CI
- [ ] App signing configuration
- [ ] Play Store / App Store submission preparation
- [ ] Crashlytics / error reporting setup
- [ ] Analytics integration

## Technical Debt
- [ ] Replace `ConsumerStatefulWidget` with proper Riverpod `AsyncNotifier` patterns where appropriate
- [ ] Add proper error handling in all repository methods
- [ ] Implement retry logic for network calls
- [ ] Add input sanitization
- [ ] Code generation with `riverpod_generator` + `build_runner`
