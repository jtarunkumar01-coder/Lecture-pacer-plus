# Lecture Pacer+ — private CA lecture planner

A responsive web app / installable PWA. It runs locally immediately and can **sync iPad, phone, and laptop** after you connect your **own Supabase project** and deploy it to a web host. It is not yet hosted or connected to a cloud account when you download the ZIP.

## Features included

- Today dashboard with watch time, actual lecture duration, completion percentages, per-subject progress, revision progress and workload limits.
- Record lectures one at a time, in batches, via a pasted list, or from Excel/CSV. Imported columns: `Subject | Chapter | Lecture | Duration (minutes)` (3-column `Chapter | Lecture | Duration` is also accepted).
- Daily automatic scheduling from today to your own completion target, adjusted for watch speed, study days, holidays, revision time and hours available.
- Missing a day doesn't delete unfinished lectures. They get automatically reallocated if capacity exists. If they cannot fit, the app warns you.
- Tick lectures and revision sessions, edit and delete lectures, move classes to a chosen date, drag between days on desktop, and see status.
- Offline local plan, JSON backup and restore, and optional account-based cloud synchronization.
- Home-screen icon and offline-capable PWA shell when hosted securely.

## Fastest way to try the planner — locally

1. Extract this ZIP.
2. Double-click `index.html` in a desktop browser. You can explore the dashboard and add lectures locally. Some browser restrictions on `file://` can limit install/offline features; for those, use a local web server or deploy the site.
3. Your plan is stored in that browser's local storage. **It will not sync devices yet.**

For a local server, open a terminal in this directory and run:

```bash
python -m http.server 8000
```

Then open `http://localhost:8000`.

## How to enable true cross-device sync (one-time setup)

### Step 1 — Create a Supabase project

1. Go to https://supabase.com/ and create a free account and a new project. Keep the project password private.
2. Inside **SQL Editor**, open `schema.sql` from this ZIP, paste the code, and run it. This creates a single-row-per-user table called `study_plans` with Row Level Security (RLS): a user can access only their own record.
3. In project settings, locate the **Project URL** (`https://YOUR-PROJECT.supabase.co`) and the **publishable key** (or legacy `anon` key). DO NOT use a `secret`, `service_role`, database password, or admin key.
4. Email/password sign-in should be enabled in Supabase Authentication. In most projects it is enabled by default. With email confirmation enabled, check your inbox after signing up. If configuring redirect URLs, include the final hosted website URL in Supabase Auth URL Configuration.

### Step 2 — Put the public connection values in `config.js`

Open `config.js` in a text editor and fill the two strings:

```javascript
window.LECTURE_PACER_CONFIG = {
  supabaseUrl: "https://YOUR-PROJECT.supabase.co",
  supabaseKey: "YOUR_PUBLIC_PUBLISHABLE_OR_ANON_KEY"
};
```

These values may appear in your site's publicly visible code; that's expected. Your security comes from the RLS policies in `schema.sql`, your account login, and keeping **secret/service-role** credentials out of the browser. You can alternatively enter the public details in the app's Cloud sync dialog on each device, but embedding them in your hosted `config.js` is easier.

### Step 3 — Host it with GitHub Pages

1. Create a GitHub account if you don't have one, at https://github.com/.
2. Create a new **public** repository called `lecture-pacer-plus` (or another name).
3. Upload the contents of this folder (not the ZIP): `index.html`, `app.js`, `styles.css`, `config.js`, `manifest.webmanifest`, `sw.js`, `schema.sql` (optional), `icons/`, and `.nojekyll`.
4. Open your repo **Settings → Pages**, select **Deploy from a branch**, set branch **main**, folder **/(root)**, then Save.
5. GitHub will give you a link like `https://YOUR-USERNAME.github.io/lecture-pacer-plus/`. Open it with HTTPS.
6. Open **Cloud sync**, then **Create account** and confirm your email if asked. Sign in.
7. Open **that same link** on your iPad, phone, and laptop. Sign in with the **same account** on each device. Your data is stored privately in your Supabase project.

**On iPad / iPhone:** Safari → Share → Add to Home Screen. This is a web app icon, not an App Store installation.

**On Android:** Chrome → menu → Add to Home screen / Install app (wording differs).

**On laptop:** Open the link in your browser; Chrome/Edge may also offer an Install option.

### Step 4 — Test the sync

On Device A: sign in, add a sample lecture, wait until the top bar says **Cloud synced**. On Device B: use the same website, sign in with the same account, then click **Sync now** if needed. The lecture should appear. Tick it on Device B, then return to Device A and bring its browser tab into focus to refresh.

## Important notes

- **Offline:** The app keeps changes locally and tries to sync when back online. If you edit **the same lecture simultaneously on two offline devices**, the most recently timestamped edit wins; clock skew can affect that. It is best not to edit the same record at the same time on both devices.
- **Cloud setup is not automatic:** Until you supply your own Supabase connection details and deploy a hosted URL, different devices will *not* sync. The app deliberately does not contain anyone's private credentials.
- **Free hosting:** GitHub Pages offers free public-repository static hosting; Supabase offers a free tier subject to usage limits and product policies. Pricing/limits may change.
- **Data:** Back up regularly in Settings → Backup JSON. Your study data is stored locally and, when signed in, in the Supabase project you control. Signing out clears the locally cached study plan from that device. Signing into a different user account won't mix users' plans.
- **Privacy:** Only public Supabase keys belong in `config.js`; do not upload your own personal backup data to a public GitHub repository. RLS policies prevent users from reading other users' plans, provided the SQL setup is complete.
- **Import:** `.xlsx` import uses SheetJS loaded from jsDelivr. If the library doesn't load or you're offline, save your Excel sheet as CSV and import that instead.
- **Study-time estimates:** Lecture time is duration divided by playback speed; this does **not** include breaks, pausing, question-solving, or note-taking. Add a realistic buffer to your daily study limit.
- **Scheduling:** The planner allocates each lecture as one indivisible block, rather than splitting lectures across days. Pinned lessons may exceed limits; the app reports an overload. Unfinished lessons pinned to a past day can enter automatic scheduling again. There is no server-side scheduled job; recalculation happens when you open/use the app.
- **Devices:** Browser support and native installation options vary; an HTTPS site works as a regular website even when PWA installation isn't offered.

## Files

- `index.html`, `styles.css`, `app.js` — browser app and planning logic
- `config.js` — optional public Supabase URL and publishable key
- `schema.sql` — cloud database table and user-specific access rules
- `sw.js`, `manifest.webmanifest`, `icons/` — web app installation/offline shell

This is an initial working version, not a formally audited production service. Test it using sample data before relying on it for an exam timetable. Data sync depends on the availability of your internet connection, Supabase and your site hosting.
