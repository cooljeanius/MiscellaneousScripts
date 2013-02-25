for directory in `find ~/*` ; do
	if [ -d ${directory} ]; then
		if [ -z "`ls -a ${directory}/*`" ]; then
			echo "Making ${directory} not empty"
			echo "#" >> ${directory}/.gitignore
		fi
	fi
done
