# Function: Information for a context within the Drupal source tree
# Usage: info [core|all] [branch|-]
# Usage: info [module|theme|all] [project|-] [branch]
# ----------------------------------------------------------------------------

function info() {
	local _context=${1:-$CONTEXT};
	local _project;
	local _branch;
	local _line;
	
	if [[ "$_context" == "core" ]]; then
		_branch=${2:-$BRANCH};
	else
		_project=${2:-$PROJECT};
		_branch=${3:-$BRANCH};
	fi;
	
	case "$_context" in
	
		'' | all )
			info core ${2:-$BRANCH};
			info module ${2:-$PROJECT} ${3:-$BRANCH};
			info theme ${2:-$PROJECT} ${3:-$BRANCH};
			;;
			
		core )
			cd $TREE_CORE;
			echo;
			echo "$(color bd)Drupal core...$(color)";
			case "$_branch" in
				'' | - )
					for _dir in `ls`; do
						getCVStag core $_dir; echo;
					done;;
				* )
					getCVStag core $_branch; echo;
			esac;;
			
		module | theme )
			if [ "$_context" == 'module' ]; then
				_dir=$TREE_MODULE;
			else 
				_dir=$TREE_THEME;
			fi;
			cd $_dir;
			
			echo;
			echo "$(color bd)Drupal $_context contrib...$(color)";
			echo;
			echo "$(color bd)Name              Branch  Tag            Description$(color)";
			_line="%-15s   %-5s   %-13s  $(color cyan)%-22s$(color)\n";
			case "$_project" in
				'' | - )
					if [[ -d $_branch && "$_branch" ]]; then
						cd $_branch;
						for _project in `ls`; do
							printf "$_line" $_project $_branch $(getCVStag $_context $_branch $_project) "$(getInfoFileDescription $_context $_branch $_project)";
						done;
					else
						for _i in `ls`; do
							cd $_dir/$_i;
							for _project in `ls`; do
								printf "$_line" $_project $_i $(getCVStag $_context $_i $_project) "$(getInfoFileDescription $_context $_i $_project)";
							done;
						done;
					fi;;	
				* )
					if [ "$_branch" ]; then
						printf "$_line" $_project $_branch $(getCVStag $_context $_branch $_project) "$(getInfoFileDescription $_context $_branch $_project)";

					else
						for _i in `find . | egrep $_project\\.info | cut -d'/' -f2`; do
							printf "$_line" $_project $_i $(getCVStag $_context $_i $_project) "$(getInfoFileDescription $_context $_i $_project)";
						done;
					fi;; 
			esac;;
			
		profile )
			profile show;;
			
	esac;
}