# Show resources

echo WORK_DIR=$WORK_DIR

for i in $(find $WORK_DIR $WORK_DIR/../../modules/ -type f -name '*.tf')
do
    printf "%s\n" "$i"
    grep -oP '^resource\s*\K[^{]+' $i \
    | sed -e 's|\"||g' -e 's|\s*$||' -e 's|\ |\.|' \
    | column -t \
    | sed 's|^|    |'
done
