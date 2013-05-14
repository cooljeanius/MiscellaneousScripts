if [ -x $(which clear) ]; then
	clear
fi
for directory in $(find ~/*) ; do
	if [ -d ${directory} ]; then
		echo "Entering ${directory}..."
		cd ${directory}
		if [ -z "$(ls -a ${directory}/* 2>/dev/null)" ]; then
			if [ ! -f ${directory}/.gitignore ]; then
				echo "  VVV"
				echo "• Making ${directory} not empty..."
				echo "  ^^^"
				echo "#" >> ${directory}/.gitignore
			else
				echo "Looks like ${directory} has already been unemptied..."
			fi
		else
			echo "${directory} is not empty, skipping..."
		fi
	fi
done

