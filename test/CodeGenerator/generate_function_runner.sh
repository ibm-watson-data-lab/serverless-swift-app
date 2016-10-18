#!/bin/bash
absPath() {
    if [[ -d "$1" ]]; then
        cd "$1"
        echo "$(pwd -P)"
    else 
        cd "$(dirname "$1")"
        echo "$(pwd -P)/$(basename "$1")"
    fi
}

strindex() { 
  x="${1%%$2*}"
  [[ $x = $1 ]] && echo -1 || echo ${#x}
}

echo 'Creating FunctionRunner...'
func_runner_file_name=$(echo $KITURA_SAMPLE_HOME/Sources/__FunctionRunner__.swift)
rm -rf $func_runner_file_name
cat $KITURA_SAMPLE_HOME/CodeGenerator/__FunctionRunner__.swift.prefix >> $func_runner_file_name
echo '' >> $func_runner_file_name
cd $SST_FUNCTIONS_HOME
for i in $(ls *.swift); do
	# create class file
	func_class_name=$(echo $i | sed 's/\.[^.]*$//')
	func_src_file_name=$(echo $SST_FUNCTIONS_HOME'/'$i)
	func_dest_file_name=$(echo $KITURA_SAMPLE_HOME'/Sources/__'$func_class_name'__.swift')
	echo 'Processing function '$func_class_name'; src='$func_src_file_name'; dest='$func_dest_file_name
	# remove if exists, then create
	rm -f $func_dest_file_name
	touch $func_dest_file_name
	# add imports outside of class definition
	grep '^import.*$' $func_src_file_name | while read -r line; do
		echo $line >> $func_dest_file_name
	done
	# run src through template engine - output into temp file
	func_tmp_file_name=$(echo $KITURA_SAMPLE_HOME'/CodeGenerator/__'$func_class_name'__.temp')
	pushd $(dirname $(absPath $func_src_file_name))
	j2 $func_src_file_name > $func_tmp_file_name
	popd
	# remove imports
	grep '^import.*$' $func_src_file_name | while read -r line ; do
		sed -i 's/^import.*$//g' $func_tmp_file_name
	done
	# create class
	echo 'public class '$func_class_name' {' >> $func_dest_file_name
	cat $func_tmp_file_name >> $func_dest_file_name
	echo '}' >> $func_dest_file_name
	# remove temp file
	rm $func_tmp_file_name
	# add to __FunctionRunner.swift
	echo '      if (function == "'$func_class_name'") {' >> $func_runner_file_name
	echo '         var params = args' >> $func_runner_file_name
	grep -E '\$DefaultParam\:[ ]*.*' $func_src_file_name | while read -r line; do
		param_name=$(echo $line | sed 's/^.*\:[ ]*\(.*\)$/\1/')
		param_value=$(cat $SST_PARAMS_HOME/default_params_test.txt | sed -n 's/^'$param_name'[^=]*=[ ]*\(.*\)$/\1/p')
		param_value=$(echo $param_value | sed 's/\"/\\\"/g')
		if [ $(strindex "$param_value" "{") == 0 ]
		then
			echo '         params["'$param_name'"] = JSON.parse(string:"'$param_value'").dictionaryObject' >> $func_runner_file_name
		else
			echo '         params["'$param_name'"] = "'$param_value'"' >> $func_runner_file_name
		fi
	done
	echo '         return '$func_class_name'().main(args: params)' >> $func_runner_file_name
	echo '      }' >> $func_runner_file_name
done
cat $KITURA_SAMPLE_HOME/CodeGenerator/__FunctionRunner__.swift.suffix >> $func_runner_file_name
echo 'FunctionRunner created.'