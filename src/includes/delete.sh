# Function: Delete a context within the Drupal source tree
# Usage: delete [core|module|theme] [project] [branch]
# ----------------------------------------------------------------------------

function delete() {
	local _context=${1:-$CONTEXT};
	local _project=${2:-$PROJECT};
	local _branch=${3:-$BRANCH};
	
	case "$_context" in
	
		'' | all )
			delete core;
			delete module;
			#delete theme;
			;;
			
		core )
			cd $TREE_CORE;
			case "$_branch" in
				'' | all )
					status "Deleting all core";
					rm -fR ./* 2>>$ERROR_LOG;
					status done;;
				* )
					if [ "$_branch" == 'HEAD' ]; then
						status "Deleting core $_branch";
					else
						status "Deleting DRUPAL-$_branch";
					fi;
					rm -fR ./$_branch 2>>$ERROR_LOG;
					status done;;
			esac;;
			
		module | theme )
			if [ "$_context" == 'module' ]; then 
				_dir=$TREE_MODULE;
			else 
				_dir=$TREE_THEME;
			fi;
			
			cd $_dir;
			case "$_project" in
				'' | all )
					if [[ -d $_branch && "$_branch" ]]; then
						status "Deleting all ${_context}s from $_branch";
						rm -fR ./$_branch 2>>$ERROR_LOG;
					else
						status "Deleting all ${_context}s";
						rm -fR ./ 2>>$ERROR_LOG;
					fi;
					status done;;
				* )
					if [ "$_branch" ]; then
						if [ "$_branch" == 'HEAD' ]; then
							status "Deleting $_project $_context ($_branch)";
						else
							status "Deleting $_project $_context (DRUPAL-$_branch)";
						fi;
						rm -fR ./$_branch/$_project 2>>$ERROR_LOG;
						status done;
					else
						for _dir in `find . | egrep $_project\\.info | cut -d'/' -f2`; do
							if [ "$_dir" == 'HEAD' ]; then
								status "Deleting $_project $_context ($_dir)";
							else
								status "Deleting $_project $_context (DRUPAL-$_dir)";
							fi;
							rm -fR ./$_dir/$_project 2>>$ERROR_LOG;
							status done;
						done;
					fi;;
			esac;;
			
		profile )
			profile delete;;
			
	esac;
}