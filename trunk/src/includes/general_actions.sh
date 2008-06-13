# Function: Clean the local Drupal source tree
# ----------------------------------------------------------------------------

function clean() {
	echo -n "I am going to clean the source tree. ";
	echo "All the contents of $BASE will be deleted and a fresh empty tree structure will be created.";
	echo -n "$(color bd)Are you ready to continue (Yes|No) ? $(color off): ";
	read confirmation;
	if [ "$confirmation" != 'Yes' ]; then
		echo "$(color green)$(color bd)Cancelling$(color off)";
		exit 1;
	fi;
	echo;
	status "Cleaning the local source tree...";
	rm -fR $BASE;
	mkdir -p $TREE_CORE $TREE_MODULE $TREE_THEME;
	touch $ERROR_LOG;
	status done;
}

# Function: Build the local Drupal source tree
# ----------------------------------------------------------------------------

function build() {
	get core;
	get module;
	get theme;
}