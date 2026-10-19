# Otaku Studio — Gift Box Catalog + Admin Dashboard

A responsive static website with a public gift-box catalog and an admin area to create, edit, publish/unpublish, and delete gift box designs. Uses HTML/CSS/JavaScript and can be deployed to GitHub Pages, Vercel, or Cloudflare Pages without a build step.

## Included
- Public gift box catalog with cover image, theme, description, included items, price in MMK, and optional contact/order link.
- Admin sign-in UI and gift-box management form.
- Image upload and direct image URL support.
- Published/draft visibility controls, search/filter, edit and delete.
- Local demo mode to test the UI without setting up a backend.
- Optional Supabase Auth + Database + Storage for persistent, cross-device use.

## Important security note
The built-in demo mode uses the password `demo1234` and browser `localStorage`. This is only for testing. It is **not secure** and changes are stored only in that browser. Do not deploy publicly for real use until you configure Supabase.

## Configure Supabase for real use
1. Create a project at https://supabase.com/.
2. Open **SQL Editor** in Supabase, paste the contents of `supabase-schema.sql`, and run it.
3. In Supabase **Authentication → Users**, create your admin user with your email and a strong password. Disable public sign-ups if you want only yourself to have an account.
4. Open **Project Settings → API** and copy the Project URL and publishable/anon key.
5. In `index.html`, find these lines near the top of the script:
   ```js
   const SUPABASE_URL = "YOUR_SUPABASE_URL";
   const SUPABASE_ANON_KEY = "YOUR_SUPABASE_ANON_KEY";
   ```
   Replace the placeholders with your project's URL and publishable/anon key. The anon key is designed for browser use when Row Level Security is correctly configured. **Never put a service-role key in frontend code.**
6. Deploy the files. The app will switch out of demo mode and require your Supabase admin email/password.

### Security note about admin access
The SQL policies let any authenticated Supabase user edit gift boxes. Keep only trusted admin accounts in Authentication and turn off public sign-ups. For a multi-admin or public registration setup, tighten the policies with an explicit admin-role table/policy.

## Deploy to GitHub Pages
1. Create a new GitHub repository.
2. Upload `index.html`, `supabase-schema.sql`, and `README.md` to the repository root.
3. Go to **Settings → Pages**.
4. Choose **Deploy from a branch**, select `main` and `/(root)`, then save.
5. Wait for the published URL in the Pages settings.

You can alternatively import the repository into Vercel or deploy it to Cloudflare Pages as a static site. No build command is required.

## Limitations in this starter
- No payment processing, inventory tracking, or automated print fulfilment.
- No customer accounts or saved customizer projects yet.
- Order/contact links are simple outbound links; they do not create a tracked order in this version.
- The product illustrations are generic; upload cover images you have permission to use. Character art is not automatically free for commercial use.
- The image uploader accepts PNG/JPG/WEBP up to 5MB. The public image bucket is intentionally public so catalog covers can be shown to visitors.
