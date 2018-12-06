#!/bin/bash

#get the number of datasets you will download
#-p is project id
#-d is datatype id
file='neuro/life'
type='ensemble'
project='5bf41966bad64d03978cd5eb'




count=$(bl dataset query -p $project -d $file --json | jq -r '.[].meta.subject' | wc -l)



for ((i=0;i<$count;i++));

do


        id=$(bl dataset query -p $project -d $file --json | jq --argjson arg $i -r '.[$arg]._id')
        subj=$(bl dataset query -p $project -d $file --datatype_tag $type --json | jq --argjson arg $i -r '.[$arg].meta.subject')
        rmse=$(bl dataset query -i $id --json | jq  -r '.[0].product.brainlife[2].data[13].x[0]')
        num_fib=$(bl dataset query -i $id --json | jq  -r '.[0].product.brainlife[2].data[13].y[0]')

        #append="r"
        #subj="$subj$append"
        echo $subj

        > tmp2.txt
        echo $rmse > tmp2.txt
        echo $num_fib >> tmp2.txt
        mv tmp2.txt ./$subj/life.txt


done