# Function: Update a context within the Drupal source tree
# Usage: update [core|all] [branch]
# Usage: update [module|theme|all] [project|all] [branch]
# ----------------------------------------------------------------------------

function update() {
	local _context=${1:-$CONTEXT};
	local _project=${2:-$PROJECT};
	local _branch=${3:-$BRANCH};
	
	case "$_context" in
	
		'' | all )
			update core;
			update module;
			#update theme;
			;;
			
		core )
			cd $TREE_CORE;
			case "$_branch" in
				'' | all )
					for _dir in `ls`; do
						cvsUpCore $_dir; 
					done;;
				* )
					cvsUpCore $_branch;;	
			esac;;
			
		module | theme )
			if [ "$_context" == 'module' ]; then 
				_dir=$TREE_MODULE;
				_cvsCo=cvsCoModule;
			else 
				_dir=$TREE_THEME;
				_cvsCo=cvsCoTheme; 
			fi;

			cd $_dir;
			case "$_project" in
				'' | all )
					if [[ -d $_branch && "$_branch" ]]; then
						cd $_branch;
						for _project in `ls`; do
							$_cvsCo $_project $_branch;
						done;
					else
						for _i in `ls`; do
							cd $_dir/$_i;
							for _project in `ls`; do
								$_cvsCo $_project $_i;
							done;
						done;
					fi;;	
				* )
					if [ "$_branch" ]; then
						$_cvsCo $_project $_branch;
					else
						for _i in `find . | egrep $_project\\.info | cut -d'/' -f2`; do
							$_cvsCo $_project $_i; 
						done;
					fi;; 
			esac;;
			
		profile )
			profile update;;
			
	esac;
}