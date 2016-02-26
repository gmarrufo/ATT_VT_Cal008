for i in `cat vietnamese_phr`
do
echo "f fsu /usr/local/www/audio/cal008/vietnamese/$i=../../audio/vietnamese/$i 0644 wevs wevs" >>prototype
done
