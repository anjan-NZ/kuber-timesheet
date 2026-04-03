# ⚡ QUICK: Push to GitHub in 2 Minutes

Pick ONE method below 👇

---

## 🏆 Easiest (Recommended)

### GitHub CLI Method
```powershell
# 1. Install GitHub CLI (one time)
winget install GitHub.CLI

# 2. Login (one time - follow prompts)
gh auth login

# 3. Push everything in 1 command!
cd "c:\Users\anjan\Desktop\In progress\Kuber TImesheet"
gh repo create kuber-timesheet --source=. --public --push
```

Done! Your code is on GitHub ✅

---

## 🖱️ No Terminal? Use GitHub Desktop

1. Download: https://desktop.github.com
2. Open → File → New Repository
3. Name: `kuber-timesheet`
4. Path: `c:\Users\anjan\Desktop\In progress\Kuber TImesheet`
5. Create
6. Write commit: "Initial commit"
7. Commit to main
8. Publish repository
9. Done! ✅

---

## 🔧 If You Already Have Git

```powershell
cd "c:\Users\anjan\Desktop\In progress\Kuber TImesheet"
git init
git add .
git commit -m "Initial commit: Kuber Timesheet"
git remote add origin https://github.com/YOUR_USERNAME/kuber-timesheet.git
git branch -M main
git push -u origin main
```

(First create empty repo at https://github.com/new)

---

## 📚 Full Details

See: [`PUSH_TO_GITHUB_OPTIONS.md`](PUSH_TO_GITHUB_OPTIONS.md)

---

**Then:** Deploy to Vercel (see [`VERCEL_DEPLOYMENT.md`](VERCEL_DEPLOYMENT.md))
