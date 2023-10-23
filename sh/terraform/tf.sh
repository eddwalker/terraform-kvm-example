#!/usr/bin/env bash
# Execute script from sh directory. It have 2 modes:
#   1. Non-interactive : ./tf.sh $1
#       - execute script name from sh folder and exit
#         with a same exit code as script
#   2. Interactive mode: ./tf.sh
#       - prints script unique id number and script name from sh folder
#       - on user input number number or name execute such script from sh,
#         thereafter it expect more input from user, indepent of script exit code
# Notes:
#   - Non-universal scripts prefixed with provider name, like: libvirt_wipe.sh

set -e


### Variables

WORK_DIR=$(pwd)

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

declare -a scripts_array
error_input_text="Wrong input, expected number or script name from the list"
my_filename=$(basename "$0")
list_key=p

### Functions

# des: read sh files from $SCRIPT_DIR
# in:  none
# out: fill global array scripts_array
function find_sh {
    for i in *
    do
        file=${i//..\/sh\/}
        [[ ! $file =~ .sh$ ]] && continue
        [[   $file =~ $my_filename ]] && continue
        scripts_array+=("$file")
    done
}

# des: files in script_dir
# in:  none, read files in dir
# out: multilite text list in format: [0-9] filename
function list_sh {
    for id in ${!scripts_array[@]}
    do
        printf "%s\t%s\n" "$((id+1))" "${scripts_array["$id"]}"
    done
    printf "%s\t%s\n" "$list_key" "print this list again"
}

# des: run script
# in:  $1 = filename of script in $SCRIPT_DIR to execute
# out: output of called script
function exec_sh {
    # return to caller script dir before exec since that dir has a terraform configuration
    cd "$WORK_DIR" > /dev/null

    echo "$my_filename pwd: $(pwd)"
    echo "$my_filename exe: $SCRIPT_DIR/$1"

    set +e
    "$SCRIPT_DIR/$1"
    code=$?
    echo "$my_filename $1: exit code=$code"
    set -e
    return $code
}


### Main

cd $SCRIPT_DIR

find_sh

if [[ -n $1 ]]
then
    exec_sh "$1"
    exit $?
fi

list_sh

while true;
do
    echo -n "number or name>  "
    read number

    if [[ -n $number ]]
    then
        # print list again
        [[ "$number" == "$list_key" ]] && list_sh && continue

        # try execute script by name
        for i in ${!scripts_array[@]}
        do
            if [[ ${scripts_array[$i]} == "$number" ]]
            then
                exec_sh "$number"
	        continue 2
            fi
        done

        # try execute script by id
        [[ ! $number =~ ^[0-9]+$ ]]            && echo "error 1: $error_input_text" && continue
        [[ $number -le 0 ]]                    && echo "error 2: $error_input_text" && continue
        real_id=$((number-1))
        [[ ! -n ${scripts_array[$real_id]} ]]  && echo "error 3: $error_input_text" && continue

        exec_sh "${scripts_array[$real_id]}"
        # break
    fi
done
