# QuietVoice

#### Video Demo: <https://youtu.be/cMVLrJ_NAS4?si=quqAeDsBLABKfSQ2>

#### Description:

### What is QuietVoice?

QuietVoice is an iOS app that teaches American Sign Language (ASL) through flashcards, quizzes, and fingerspelling practice. The app is designed to be accessible, free, and easy to use for anyone who wants to learn basic ASL vocabulary. All sign demonstrations in this app are performed by me, and all handshape images (fingerspelling alphabet and numbers) were generated using Google Gemini AI, then verified for accuracy against ASL University (lifeprint.com) resources.

### Content Note

The sign demonstrations in this application feature me performing the signs. Handshape images for fingerspelling were generated using AI (Google Gemini) and verified against authoritative ASL resources. For a production version, professional recording and additional verification would be recommended. The current submission demonstrates a functional ASL learning platform with original content.


### Who It Helps

- Hearing individuals who want to communicate with deaf or hard-of-hearing family members, coworkers, or friends
- Students taking ASL courses who need a supplemental study tool
- Complete beginners who don't know where to start learning sign language
- Anyone who prefers visual, self-paced learning on their mobile device

### App Structure

QuietVoice has five main sections accessible from a custom glass tab bar at the bottom of the home screen.

**1. Home (Insights/Articles)**
This section displays informational articles about ASL and deaf culture. Topics include the history of ASL, ASL in education, deaf culture, fingerspelling, language deprivation, ethics in sign language technology, the 5 parameters of ASL, and iconicity in sign language. Article content is formatted with paragraph breaks using `\n\n` separators. Tapping an article opens a sheet with the full text.

**2. Study**
The study section contains topic-based flashcard decks. Five topics are arranged around a center star icon: Greetings, Family, Food, Basic Actions, and Common Phrases. Each topic has a square card with an SF Symbol icon. Completed topics glow yellow with a shadow effect.

When a user taps a topic, they enter flashcard mode where each card shows:
- A video of me performing the sign
- The written word
- Swipe gestures to navigate between cards

After viewing all signs in a topic, a "Topic Finished" screen appears with a star icon, the topic name, and a "Practice" button that opens a quiz for that specific topic. A back button allows return to the topics grid.

**3. Fingerspelling**
This section teaches the ASL alphabet (A-Z) and numbers (0-10). A custom tab bar with three tabs (Alphabet, Numbers, Learn) allows switching between views. The Alphabet and Numbers tabs display AI-generated handshape images (verified for accuracy) in a 3‑column grid. The Learn tab contains "Practice Alphabet" and "Practice Numbers" buttons that open the fingerspelling quiz directly.

**4. Quizzes**
The quiz section is organized as a 2‑column grid of six quiz modes:
- **Sign of the Day** – One random sign that changes daily
- **Quick Quiz** – 5 random questions from the combined pool
- **Random Set Quiz** – 10 random questions
- **Missed Signs Quiz** – Only signs the user answered incorrectly in other quizzes
- **Practice Topics** – User selects a topic, then quizzes on that topic's signs
- **Practice Fingerspelling** – User selects Alphabet or Numbers, then quizzes on those

All quiz screens share a consistent design: yellow header with question counter, animated progress bar, media display (video or image), four multiple-choice options, and a Next button. Options turn green for correct answers and red for wrong answers. When a user answers incorrectly, the correct answer also highlights in green. The Score screen shows the result with dynamic messages ("Excellent!", "Good job!", "Keep practicing!") and offers a "Practice Again" button.

**5. Progress**
The progress section has two tabs with animated underline indicators. The Fingerspelling tab shows progress for alphabet and numbers using capsule-style progress bars with counts (e.g., "11/26"). The Flashcards tab shows total sign progress and a grid of completed topics with glowing icons.

### Technical Implementation

**Language and Frameworks:**
- Swift for programming logic
- SwiftUI for user interface
- AVKit and AVFoundation for video playback
- UserDefaults for progress storage via StorageManager

**Architecture:**
The project follows a separation of concerns pattern:
- **Models Folder:** Contains pure Swift structs (Sign, Topic, Letter, SampleData, QuizLogic, Color+Hex, DotRow) with no SwiftUI imports. Handles all business logic and reusable components.
- **Views Folder:** Contains all SwiftUI screens which only display data and send user actions to the models.
- **Data Folder:** Contains StorageManager.swift which handles all UserDefaults read/write operations for completed topics, viewed signs, and missed sign counts.
- **Assets:** Contains AI-generated fingerspelling images (JPG), app icons, onboarding illustration, and app logo for splash screen.

### Key Files

| File | Purpose |
|------|---------|
| `QuietVoiceApp.swift` | App entry point, manages splash screen and onboarding flow |
| `HomeView.swift` | Main tab bar container with Insights, Study, Fingerspelling, Quizzes, Progress tabs |
| `StudyView.swift` | Topics grid around center star, flashcard navigation, topic completion tracking |
| `FingerspellingView.swift` | Alphabet/numbers grid with custom tab bar and learn section |
| `QuizzesView.swift` | Six-quiz grid with sheet presentation for each mode |
| `QuizLogic.swift` | Core quiz engine generating questions with random distractors |
| `StorageManager.swift` | UserDefaults wrapper for progress persistence |


### Design Choices

- **No login required:** All progress saves locally to respect user privacy
- **Topics arranged around star:** Visual differentiation from standard list layouts
- **Glow effects for completion:** Immediate visual feedback for user progress
- **Custom tab bar:** Maintains brand consistency across all sections
- **Swipe gestures for flashcards:** Natural, intuitive navigation between signs

### Design Resources

The complete UI/UX design for QuietVoice was created in Figma. The design file includes all screen layouts, component specifications, color palette, and typography decisions. [View the Figma design here](https://www.figma.com/design/OW8FW00Q6ifwvDIJySvwUr/QV?node-id=15-488&t=3GaYM08LTcqB33fX-1)

### Future Enhancements

- Additional topics (animals, colors, emotions)
- User accounts with cloud sync
- Camera-based sign detection using Core ML
- More advanced quiz customization options

### Author

Alima Karimova


### Acknowledgments

- **CS50 Team** – For teaching me programming fundamentals and inspiring this project
- **Paul Hudson (Hacking with Swift)** – The "100 Days of SwiftUI" course taught me everything I needed to know to build this iOS app
- **ASL University (Lifeprint.com)** – Used for verification of sign accuracy for AI-generated images
- **Google Gemini AI** – Used to generate fingerspelling alphabet and number handshape images, which were then verified against authoritative sources

### Design Tools

- **Figma** – For designing all app screens, components, and visual assets

### Content Sources

- Sign language videos feature me performing the signs
- Fingerspelling images generated with Google Gemini AI, verified against ASL University resources
- Article content written by me with assistance from ChatGPT for research and structuring
