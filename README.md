# NekoTomo 🐱

**Learn Japanese. Raise your Neko. Grow together.**

NekoTomo is a mobile app for learning Japanese through caring for a virtual pet.

## Features

- 🇯🇵 Japanese vocabulary and lessons (JLPT N5)
- 🐱 Virtual pet (Neko) that grows with your progress
- 📝 Multiple exercise types
- 🏆 XP, coins, and reward system
- 🍙 Feed and play with your Neko

## Tech Stack

- **Frontend:** Flutter + Riverpod
- **Backend:** Node.js + Express + PostgreSQL
- **ORM:** Prisma

## Getting Started

### Backend

```bash
cd backend
cp .env.example .env
# Edit .env with your database credentials
npm run setup
npm run dev
```

### Frontend

```bash
cd frontend  # or root directory
flutter pub get
flutter run
```

## Project Structure

```
NekoTomo/
├── backend/         # Node.js API
│   ├── prisma/      # Database schema & migrations
│   └── src/         # Express server
└── lib/             # Flutter app
    ├── core/        # Theme, constants
    ├── models/      # Data models
    ├── providers/   # Riverpod state
    ├── screens/     # UI screens
    ├── services/    # API services
    └── widgets/     # Reusable widgets
```

## License

Private project.
