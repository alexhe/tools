#!bin/sh
for proj in `cat sync.ini`
do
    echo 'Start sync'$proj
    cd $proj
    repo sync -j8
done
