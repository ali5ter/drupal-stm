# Function: Retrieve/get a context within the Drupal source tree
# Usage: get [core|module|theme] [project] [branch] [version]
# ----------------------------------------------------------------------------

function get() {
	local _context=${1:-$CONTEXT};
	local _project=${2:-$PROJECT};
	local _branch=${3:-$BRANCH};
	local _version=${4:-$VERSION};
	
	case "$_context" in
	
		core )
			if [ "$_branch" ]; then
				cvsCoCore $_branch;
			else
				if [ "$BRANCHES" ]; then
					for ((i=0;i<${#BRANCHES[@]};i++)); do
						cvsCoCore ${BRANCHES[${i}]};
					done;
				else 
					cvsCoCore;
				fi;
			fi;;
			
		module | theme )
		
			if [ "$_context" == 'module' ]; then _cvsCo=cvsCoModule;
			else _cvsCo=cvsCoTheme; fi;
			
			if [ "$_project" ]; then
				if [ "$_branch" ]; then
					$_cvsCo $_project $_branch $_version;
				else
					if [ "$BRANCHES" ]; then
						for ((i=0;i<${#BRANCHES[@]};i++)); do
							if [ `cat $PROFILE | egrep ^ExcludeModule | egrep $_project | egrep ${BRANCHES[${i}]} | wc -l | tr -d ' '` == '0' ]; then
								$_cvsCo $_project ${BRANCHES[${i}]} $_version;
							fi;
						done;
					else 
						$_cvsCo $_project;
					fi;
				fi;
			else
				if [ "$MODULES" ]; then
					for ((i=0;i<${#MODULES[@]};i++)); do
						if [ "$BRANCHES" ]; then
							for ((j=0;j<${#BRANCHES[@]};j++)); do
								if [ `cat $PROFILE | egrep ^ExcludeModule | egrep ${MODULES[${i}]} | egrep ${BRANCHES[${j}]} | wc -l | tr -d ' '` == '0' ]; then
									$_cvsCo ${MODULES[${i}]} ${BRANCHES[${j}]} $_version;
								fi;
							done;
						else 
							$_cvsCo ${MODULES[${i}]};
						fi;
					done;
				else 
					$_cvsCo $_project;
				fi;
			fi;;
						
		profile )
			profile sample;;
			
	esac;
}

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