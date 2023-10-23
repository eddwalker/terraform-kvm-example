#!/usr/bin/env bash

echo debug: pwd=$(pwd)

if [[ $1 =~ pull ]]
then
    echo === State pull
    terraform state pull
elif [[ -n $1 ]]
then
    echo "=== Current state of saved plan for $1:"
    terraform state show $1
else
    echo "=== Workspace list"
    terraform workspace list

    echo "=== States list"
    terraform state list
fi

echo "=== Help"
echo "./state.sh                       # list propertios"
echo "./state.sh some_resource_or_data # dump properties of this"
echo "./state.sh pull                  # whole state pull"

