# abort on errors
set -e
# build
npm run build
# navigate into the build output directory
cd dist

git init
git add -A
git commit -m 'deploy'
git push -f git@github.com:13ozOfCats/Exchange_Rates.git master:gh-pages
cd -
