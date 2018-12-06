#!/bin/bash

#get the number of datasets you will download
#-p is project id
#-d is datatype id
file='generic/images'
type='wmc_figures'
project='5bf2f359910945002799f77d'


if [ -z "$type" ]; then

        count=$(bl dataset query -p $project -d $file --json | jq -r '.[].meta.subject' | wc -l)
else
        count=$(bl dataset query -p $project -d $file --datatype_tag $type --json | jq -r '.[].meta.subject' | wc -l)
fi

#for 0 to $count, get the dataset id and subject id for each subject
#download the dataset (in this case a 'raw' dataset)
#extract the specific files wanted, rename them and move them to the current directory
#remove the downloaded directory which is full of extraneous files

for ((i=0;i<$count;i++));

#for i in `seq 1 `
do


        if [ -z "$type" ]; then
      

                
                id=$(bl dataset query -p $project -d $file --json | jq --argjson arg $i -r '.[$arg]._id')
                subj=$(bl dataset query -p $project -d $file --json | jq --argjson arg $i -r '.[$arg].meta.subject')
                dataset_name=$(bl dataset query -p $project -d $file  --json | jq --argjson arg $i -r '.[$arg].desc')

        else

                id=$(bl dataset query -p $project -d $file --datatype_tag $type --json | jq --argjson arg $i -r '.[$arg]._id')
                subj=$(bl dataset query -p $project -d $file --datatype_tag $type --json | jq --argjson arg $i -r '.[$arg].meta.subject')
                dataset_name=$(bl dataset query -p $project -d $file --datatype_tag $type --json | jq --argjson arg $i -r '.[$arg].desc')

        fi

        append="r"
        subj="$subj$append"
        echo "downloading dataset $subj"
        bl dataset download $id
        mkdir $subj
        dataset_new=${dataset_name// /_}
        dataset_new="WMC_Tract_figures"
        mv $id ./$subj/$dataset_new
        echo $dataset_new




        #mv $id/volumes.json ./"${subj}_volumes.json"
        #mv $id/volumes_icvproportion.json ./"${subj}_volumes_icvproportion.json"
        #rm -rf $id
done