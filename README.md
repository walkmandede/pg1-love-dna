# pg1

A new Flutter project.



## first deploy
# Build the web app
flutter build web --release --base-href "/pg1-love-dna/"

# Deploy to gh-pages branch
git checkout --orphan gh-pages
git rm -rf .
cp -r build/web/* .
git add .
git commit -m "Deploy to GitHub Pages"
git push origin gh-pages --force
git checkout main


## further deploy

# Make sure you're on the main branch
git checkout main

# Build the web app
flutter build web --release --base-href "/pg1-love-dna/"

# Switch to gh-pages branch
git checkout gh-pages

# Remove old files and copy new build
git rm -rf .
 # Keep .gitignore
git checkout main -- .gitignore 
cp -r build/web/* .

# Commit and push
git add .; git commit -m "Redeploy web app"; git push origin gh-pages

# Go back to main branch
git checkout main