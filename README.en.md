# Community Board App

[🇪🇸 Español](README.md) · 🇬🇧 **English**

A small social network built with **Flutter** and **Supabase**. Users can sign up,
publish posts (with an optional image), like and comment on other people's posts,
search content, and manage their own profile.

The project is organized as a **monorepo** following **Clean Architecture** principles,
with clear separation between the presentation, domain, and data layers.

---

## ✨ Features

- **Authentication** — email/password sign up, login and logout (Supabase Auth).
- **Feed** — paginated list of posts from the whole community.
- **Posts** — create, edit and delete your own posts, each with a title, body and optional image.
- **Likes** — like / unlike posts; counts update in real time.
- **Comments** — comment on posts, edit and delete your own comments.
- **Search** — search posts by keyword.
- **Profiles** — view any user's profile, edit your own username and avatar.
- **Roles** — `user` / `admin` roles stored per profile.

---

## 🏗️ Architecture

The codebase is split into a Flutter app plus three internal Dart packages, wired together
with dependency injection. Dependencies point **inward**: presentation → domain ← data.

```
community_board_app/
├── bloc_app/                # Flutter application (presentation layer)
│   └── lib/
│       ├── core/            # DI, router, event bus, shared widgets & utils
│       └── features/        # auth · post · profile · search · splash
│           └── <feature>/presentation/
│               ├── blocs/   # BLoC state management
│               ├── pages/   # screens
│               └── widgets/ # reusable UI
│
└── packages/
    ├── core/                # UseCase base, Failure/errors, constants, utils
    ├── domain/              # Entities, repository interfaces, use cases (pure Dart)
    └── data_supabase/       # Supabase implementations (data sources, models, repos)
```

**Layers**

| Layer          | Package         | Responsibility                                                        |
| -------------- | --------------- | --------------------------------------------------------------------- |
| Presentation   | `bloc_app`      | UI, screens and BLoCs. Reacts to state, dispatches events.            |
| Domain         | `domain`        | Business rules: entities, use cases and repository **interfaces**.     |
| Data           | `data_supabase` | Concrete repositories, remote data sources and DTO/models for Supabase. |
| Shared kernel  | `core`          | Cross-cutting building blocks (base `UseCase`, error types, utils).    |

### Tech stack

- **State management:** `bloc` / `flutter_bloc`
- **Dependency injection:** `get_it` + `injectable`
- **Routing:** `go_router`
- **Functional error handling:** `fpdart` (`Either`-style results)
- **Backend:** `supabase_flutter` (Auth · Postgres · Storage · RPC)
- **Images:** `image_picker`, `cached_network_image`
- **Config:** `flutter_dotenv`
- **Utilities:** `equatable`, `intl`, `uuid`, `string_validator`, `stream_transform`

---

## 🗄️ Backend (Supabase)

The backend runs entirely on Supabase. The public schema has four tables, all protected
with **Row Level Security (RLS)**:

| Table      | Purpose                                                              |
| ---------- | ------------------------------------------------------------------- |
| `profiles` | Public profile per user (`username`, `avatar_url`, `role`). Linked 1:1 to `auth.users`. |
| `posts`    | Posts (`title`, `content`, `image_url`, `likes_count`, `comments_count`). |
| `comments` | Comments attached to a post and a user.                             |
| `likes`    | One row per (post, user) like.                                      |

**Automation on the database**

- `on_auth_user_created` → creates a `profiles` row automatically when a user signs up
  (username comes from the sign-up metadata).
- `on_like_change_update_post_likes_count` → keeps `posts.likes_count` in sync on like/unlike.
- `on_comment_change_update_post_comments_count` → keeps `posts.comments_count` in sync.
- `set_*_updated_at` triggers maintain `updated_at` columns.

**RPC functions** (called from the app for atomic, view-shaped responses):
`create_post_and_return_post_display_view`, `update_post_and_return_post_display_view`,
`create_comment_and_return_comment_display_view`, `update_comment_and_return_comment_display_view`,
`handle_like`, `get_my_posts`, `search_posts`, `update_user_profile`, `get_user_role`, `is_admin`.

Post images are stored in **Supabase Storage** and referenced by URL from `posts.image_url`.

---

## 🚀 Getting started

### Prerequisites

- Flutter SDK `^3.10.4` (Dart 3)
- A Supabase project (URL + anon key)

### 1. Clone and install

```bash
git clone <your-repo-url>
cd community_board_app/bloc_app
flutter pub get
```

> The app depends on the local packages under `../packages` via path dependencies,
> so `flutter pub get` from `bloc_app/` resolves everything.

### 2. Configure environment

Create a `.env` file inside `bloc_app/` with your Supabase credentials:

```env
SUPABASE_URL=https://YOUR-PROJECT.supabase.co
SUPABASE_ANON_KEY=your-anon-key
```

`.env` is loaded at startup by `flutter_dotenv` and is listed as a Flutter asset in
`pubspec.yaml`. **Do not commit it.**

### 3. Generate code

The DI graph and JSON serialization use code generation:

```bash
dart run build_runner build --delete-conflicting-outputs
```

### 4. Run

```bash
flutter run
```

---

## 🧪 Demo data

The database can be seeded with demo users and posts to make the feed look realistic.
Demo accounts use the shared password `Demo1234!` (for local/testing only — never reuse it
for anything real). Example seed users: `ava_makes`, `marco_lifts`, `pixel_nate`,
`wander_lena`, `quiet_reader`, `jon_brews`.

---

## 📂 Project layout reference

```
bloc_app/lib/features/<feature>/presentation/{blocs,pages,widgets}
packages/domain/lib/src/<feature>/{entities,repositories,usecases}
packages/data_supabase/lib/src/<feature>/{datasources,models,repository}
```

Each feature (auth, post, profile, search) follows the same shape across all three layers,
which makes the codebase predictable to navigate and extend.
