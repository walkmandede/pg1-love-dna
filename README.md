# pg1

A new Flutter project.


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