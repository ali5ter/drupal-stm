# Function: Echo a status message
# Usage: status [<string>|done]
#				 status error <string>
# ----------------------------------------------------------------------------

function status() {
	case "$1" in
		error )
			echo -e "$(color red)Error:$(color) $2";
			exit 1;
			;;
		done )
			if [ -z "$QUIET" ]; then echo " $(color green)Done$(color)"; fi;
			;;
		* )
			if [ -z "$QUIET" ]; then echo -en "$1...\t"; fi;
			;;
	esac;
}

# Function: Display CVS Tag for a context within the Drupal source tree
# Usage: getCVStag [context] [branch] [project]
# ----------------------------------------------------------------------------

function getCVStag() {
	local _context=${1:-module};
	local _project=${3:-devel};
	local _branch=${2:-HEAD};
	local _tag;

	case "$_context" in
		core )
			_tag=`cat $TREE_CORE/$_branch/CVS/Tag`;;
		module )
			_tag=`cat $TREE_MODULE/$_branch/$_project/CVS/Tag`;;
		theme )
			_tag=`cat $TREE_THEME/$_branch/$_project/CVS/Tag`;;
	esac;
	
	echo -n ${_tag:1};
}

# Function: Display module description within the Drupal source tree
# Usage: getInfoFileDescription [context] [branch] [project] 
# ----------------------------------------------------------------------------

function getInfoFileDescription() {
	local _context=${1:-module};
	local _branch=${2:-HEAD};
	local _project=${3:-devel};
	local _dir;
	
	case "$_context" in
		core )		_dir=$TREE_CORE;;
		module )	_dir=$TREE_MODULE;;
		theme )		_dir=$TREE_THEME;;
	esac;
	
	local _desc=`find $_dir/$_branch/$_project -name $_project.info | xargs egrep "^description" | cut -f2 -d '=' | tr -d '\"'`;
	echo -n ${_desc:1};
}