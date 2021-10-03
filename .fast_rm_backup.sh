# rm -r .*~
# rm -r *~
find . -name \.*~ -type f -delete
find . -name \*~ -type f -delete
echo "Done"
