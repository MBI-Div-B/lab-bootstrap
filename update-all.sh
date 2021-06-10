for folder_to_go in $(find . -mindepth 1 -maxdepth 1 -type d \( -name "pytango*" \) ) ; 
                                    # you can add pattern insted of * , here it goes to any folder 
                                    #-mindepth / maxdepth 1 means one folder depth   
do
cd $folder_to_go
  echo $folder_to_go "########################################## "
  git pull
cd ../ 
done
