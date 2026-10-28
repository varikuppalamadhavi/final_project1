# Rental Property Listing and Tenant Management System

A beginner-friendly full-stack web application for maintaining rental property listings, tenant contact records, and lease agreements. The interface uses plain HTML, CSS and JavaScript; the server uses Node.js and Express; persistent storage uses Supabase PostgreSQL.

## 1. Problem statement and objectives

Landlords and property managers often keep property availability, tenant details and rental agreements in separate records. RentNest brings these details into one dashboard so they can review listings, search records, update availability and track active leases.

### Users
- **Property manager (demo operator):** creates and updates properties, tenants and leases.
- **Tenant (record):** a person whose contact information is maintained by the property manager. Tenant self-service login is not included in this MVP.

### Features
- Responsive dashboard with property, tenant, active-lease and monthly-rent summaries.
- Property create, view, update, delete, search and availability filtering.
- Tenant create, view, update, delete and search.
- Lease creation and editing linked to a property and tenant.
- Server-side input validation, database constraints, error handling, health endpoint and request rate limiting.

## 2. Technology stack
- HTML5, CSS3, Vanilla JavaScript
- Node.js LTS, Express.js
- Supabase PostgreSQL and `@supabase/supabase-js`
- Git and GitHub

## 3. Folder structure
```text
rental-property-listing-and-tenant-management-system/
├── frontend/ (index.html, styles.css, app.js)
├── backend/ (server.js, supabase.js, routes/api.js, package.json, .env, .env.example, .gitignore)
├── database/ (schema.sql)
├── .gitignore
└── README.md
```

## 4. Prerequisites
Install [Node.js LTS](https://nodejs.org/), [Visual Studio Code](https://code.visualstudio.com/) and [Git](https://git-scm.com/). Create a free Supabase project at [supabase.com](https://supabase.com/).

Verify in a new terminal:
```bash
node --version
npm --version
git --version
```

## 5. Supabase setup
1. Sign in to Supabase and create a project. Save the database password securely.
2. Open the project dashboard and go to **SQL Editor**.
3. Open `database/schema.sql` in VS Code, copy the entire script, paste it into a new Supabase SQL query and click **Run**.
4. Open **Table Editor** and verify that `properties`, `tenants` and `leases` exist.
5. Open **Project Settings → API** (or the project's API keys page). Copy the Project URL and the server-side service role/secret key. The exact label may differ by Supabase dashboard version.
6. Keep the secret key private. It must never be put in frontend files, GitHub, screenshots, or shared documents.

The backend uses a privileged server-side key and currently exposes management routes without login. This is suitable only for a local classroom demonstration. **Do not deploy this version publicly** until authentication and role-based authorization are implemented and tested. Do not expose this server to untrusted networks.

## 6. Configure the backend
Open a terminal in the project root, then:
```bash
cd backend
npm install
```
Edit `backend/.env` and replace the two placeholders with your own values:
```env
PORT=3000
NODE_ENV=development
SUPABASE_URL=https://YOUR_PROJECT_ID.supabase.co
SUPABASE_SERVICE_ROLE_KEY=YOUR_SERVER_SIDE_SECRET_KEY
```
`.env` contains local secrets and is ignored by Git. `.env.example` documents variable names with placeholders only. Never upload actual credentials.

## 7. Run the application
From the `backend` directory:
```bash
npm run check
npm start
```
Expected terminal message: `RentNest running at http://localhost:3000`. Open [http://localhost:3000](http://localhost:3000) in your browser. The `/api/health` endpoint should return JSON with `ok: true`.

Keep the terminal open while using the app. If you edit server code, stop it with Ctrl+C and run `npm start` again. `npm run dev` uses Node's watch mode on supported Node versions.

## 8. API endpoints
All endpoints return JSON except successful deletes, which return HTTP 204. The routes are not authenticated in this MVP; treat them as local demo endpoints only.

| Method | Path | Purpose | Body / result |
|---|---|---|---|
| GET | `/api/health` | Check server | `{ "ok": true, "service": "RentNest API" }` |
| GET | `/api/dashboard` | Get properties, tenants, leases | Aggregated dashboard data |
| GET | `/api/properties` | List properties | Optional `?search=term` |
| POST | `/api/properties` | Create property | Property fields |
| PUT | `/api/properties/:id` | Update property | Fields to update |
| DELETE | `/api/properties/:id` | Delete property | No body; fails if a lease references it |
| GET/POST | `/api/tenants` | List/create tenants | Tenant fields; email must be unique |
| PUT/DELETE | `/api/tenants/:id` | Update/delete tenant | Delete fails if lease references tenant |
| GET/POST | `/api/leases` | List/create leases | Lease fields and valid date range |
| PUT/DELETE | `/api/leases/:id` | Update/delete lease | Lease fields / no body |

Successful create returns HTTP 201; invalid input returns 400; duplicate unique values return 409; missing records return 404; unconfigured database returns 503. Other database errors are returned as a generic message to avoid exposing internal details.

## 9. Main workflows
1. Add a property and set its availability.
2. Add a tenant with a unique email address.
3. Create a lease by selecting a property and tenant, entering rent and dates, and choosing its status.
4. Review active lease count and monthly rent on the dashboard.
5. Use search/filter controls to find records; edit or delete records using the action buttons.

## 10. Testing checklist
- [ ] `GET /api/health` responds with `ok: true`.
- [ ] With correct Supabase configuration, the dashboard loads without an API error.
- [ ] Create a property with all required fields; it appears in the property grid.
- [ ] Search properties by title/city and filter by availability.
- [ ] Create a tenant; search by name or email.
- [ ] Try a duplicate tenant email; expect a friendly error.
- [ ] Create a lease after adding a property and tenant; it appears in the lease table.
- [ ] Try a lease whose end date precedes its start date; expect validation failure.
- [ ] Edit a record and verify the changes persist after refreshing.
- [ ] Delete a record with confirmation; property/tenant deletion should be rejected if referenced by a lease.
- [ ] Check layout at desktop and mobile widths.
- [ ] With missing credentials, confirm the UI reports that the API/database is unavailable rather than displaying fake data.

Only the Node syntax-check command is included; the remote Supabase connection and browser workflows must be tested using your own credentials.

## 11. Troubleshooting
- **Database is not configured:** ensure `backend/.env` exists and has real values, then restart the server.
- **Invalid API key / fetch failed:** re-copy the Supabase Project URL and server-side key; do not add quotes or spaces around values.
- **Table not found:** run `database/schema.sql` in the correct Supabase project.
- **Port already in use:** change `PORT` in `.env` (for example `3001`) and open the matching localhost URL.
- **Dashboard says API unavailable:** make sure the server is running and visit `/api/health`.
- **Delete fails:** a lease may reference the property or tenant. Delete or reassign the lease first.

## 12. Git and GitHub
Create an empty repository on GitHub, then run these commands from the project root (replace the URL with your own):
```bash
git init
git status
git add .
git status
git commit -m "Build rental property and tenant management system"
git branch -M main
git remote add origin YOUR_GITHUB_REPOSITORY_URL
git push -u origin main
```
Check `git status` before committing. Confirm `.env` and `node_modules/` are not staged, while `.env.example` is included. `.gitignore` does not remove a secret that was committed earlier; rotate any exposed credentials immediately and clean repository history as needed.

## 13. Limitations and future improvements
- No sign-in or role-based access yet; do not expose this MVP publicly.
- No payment gateway, automated reminders, document uploads or tenant portal.
- Future work could add Supabase Auth, per-user authorization, RLS policies, rent-payment history, maintenance requests and downloadable reports.

## 14. Architecture
Browser (HTML/CSS/Vanilla JS) → `fetch()` → Express REST API → Supabase client (server only) → PostgreSQL tables. The browser never receives the privileged Supabase key.
