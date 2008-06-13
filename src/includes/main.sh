# Pre process
# ----------------------------------------------------------------------------

profileBranches;
profileModules;
	
# Parse input arguments
# ----------------------------------------------------------------------------

if [ -z "$1" ]; then help; fi;

while (( "$#" )); do

	case "$1" in
		
		# Options
		-q | --quiet )		QUIET=1;;
		-v | --verbose )	VERBOSE=1;;
		-f | --force )		FORCE=1;;
		
		# General actions
		help )						help;;
		init )  					clean; profile sample; build;;
		clean )						clean;;
		build )						build;;
		backup )					backup;;
		makefile )				makefile;;
		
		# Context for an action
		core | C )				CONTEXT=core;;
		module | M )			CONTEXT=module;;
		theme | T )				CONTEXT=theme;;
		profile )					CONTEXT=profile;;
		all )							CONTEXT=all;;
		
		# Action based on context
		retrieve | get )	ACTION=get;;
		update | up )			ACTION=update;;
		delete | del )		ACTION=delete;;
		info | i )				ACTION=info;;
		import | im )			ACTION=import;;
		export | ex )			ACTION=export;;
		restore )					ACTION=restore;;
		
		# Parse project, branch and version based on context
		*)
			case "$CONTEXT" in
					
				core )
					if [ -z "$BRANCH" ]; then 
						BRANCH=$1;
					else status error "The core context only takes the branch argument.";
					fi;;
					
				module | theme )
					if [ -z "$PROJECT" ]; then 
						PROJECT=$1; 
					else 
						if [ -z "$BRANCH" ]; then 
							BRANCH=$1;
						else 
							if [ -z "$VERSION" ]; then 
								VERSION=$1;
							else status error "The module and theme context only take the project, branch and version arguments.";
							fi;
						fi;
					fi;;
				
				profile | restore )
					if [ -z "$FILE" ]; then
						FILE=$1;
					fi;;
					
			esac; # case $CONTEXT
			
			case "$ACTION" in
			
				restore )
					if [ -z "$FILE" ]; then
						FILE=$1;
					fi;;
					
			esac;; # case $ACTION
				
			
	esac # case $1
	
	shift;

done;

# Invoke and action
# ----------------------------------------------------------------------------

case "$ACTION" in
	get )			get $CONTEXT $PROJECT $BRANCH $VERSION;;
	update )	update $CONTEXT $PROJECT $BRANCH;;
	delete )	delete $CONTEXT $PROJECT $BRANCH;;
	info )		info $CONTEXT $PROJECT $BRANCH;;
	import )  profile import $FILE;;
	export )  profile export;;
	restore ) restore $FILE;;
esac