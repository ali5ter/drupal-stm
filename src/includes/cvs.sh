# Function: Check out Drupal core
# Usage: cvsCoCore [branch]
# ----------------------------------------------------------------------------

function cvsCoCore() {
	local _tag;
	local _dir;
	
	case "$1" in
		HEAD | '' ) _tag=HEAD; _dir=HEAD;;
		* )					_tag=DRUPAL-$1; _dir=$1;;
	esac;
	
	cd $TREE_CORE;
	status "Fetching $_tag";
	cvs $CVS_REPO -Q co -d $_dir -r $_tag drupal 2>>$ERROR_LOG;
	status done;
}

# Function: Check out Drupal module project
# Usage: cvsCoModule project [branch] [version]
# ----------------------------------------------------------------------------

function cvsCoModule() {
	local _project=${1:-devel};
	local _branch=${2:-HEAD};
	local _version=$3;
	
	if [[ -e $PROFILE && `cat $PROFILE | egrep ^LockModuleVersion | egrep $_project | egrep $_branch | wc -l | tr -d ' '` != '0' ]]; then
		_version=`cat $PROFILE | egrep ^LockModuleVersion | egrep $_project | egrep $_branch | awk {'print $4'}`;
	fi;

	if [ ! -d $TREE_MODULE/$_branch ]; then 
		mkdir -p $TREE_MODULE/$_branch;
	fi;
	cd $TREE_MODULE/$_branch;
	
	local _tag;
	case "$_branch" in
		HEAD )	_tag=HEAD; _dir=HEAD;;
		* )			_tag=DRUPAL-$_branch; _dir=$_project;;
	esac;
	
	if [ "$_version" ]; then
		# @todo _version =~ s/./-/g
		_tag=$_tag--$_version;
	fi;
	
	status "Fetching $_project module ($_tag)";

	if [ "$FORCE" ]; then
		rm -fR $_project;
	fi;
	
	if [ -d $_project ]; then 
		status "already exists locally";
		status done;
		return;
	fi;

	if [ "$_version" ]; then
	
		# Check out a specific version...
	
		status " ($_tag)";
		cvs $CVS_CONTRIB_REPO -Q co -d $_project -r $_tag $CVS_MODULE_REPO_DIR/$_project
		if [ ! -d $_project ]; then
			status "unable to checkout this module project";
			status done;
			return;
		fi;
	
	else
	
		# Find latest version...
		
		local _checkout_by_version=0
		local _checkout_by_branch=1
		local _checkout_head=2
		local _project_not_found;
		local _tag_not_found;
		local _try_tag;
		local _exit=NO;
		local _log=.tmp_log;
		
		touch $_log;
		
		if [ "$_tag" == 'HEAD' ]; then _checkout=$_checkout_head;
		else _checkout=$_checkout_by_version;
		fi;
		
		until [[ -d $_project || "$_project_not_found" != '' || "$_project_disappeared" != '' || "$_exit" == 'YES' ]]; do
		
			case "$_checkout" in
			
				"$_checkout_by_version" )
					if [ -z "$_try_tag" ]; then
						_version=8;	# not spotted any versions higher than 7
						_try_tag=$_tag--$_version;
					fi;
					if (("$_version" > "1")); then
						_version=$[$_version -1];
						_try_tag=$_tag--$_version;
					else 
						_checkout=$_checkout_by_branch;
					fi;
					;;
					
				"$_checkout_by_branch" )
					if [ "$_try_tag" == "$_tag" ]; then
						_checkout=$_checkout_head;
					else
						_try_tag=$_tag;
					fi;
					;;
					
				"$_checkout_head" )
				  if [ "$_try_tag" == 'HEAD' ]; then
						_exit=YES;
					else
						_try_tag=HEAD;
					fi;
				  ;;
				  
				* )
					_exit=YES;
					;;
			esac;
			
			cvs $CVS_CONTRIB_REPO -Q co -d $_project -r $_try_tag $CVS_MODULE_REPO_DIR/$_project 2>$_log;
			
			_project_not_found=`cat $_log | grep 'could not read RCS file'`;
			_project_disappeared=`cat $_log | grep 'has disappeared'`;
			_tag_not_found=`cat $_log | grep 'no such tag'`;
			
			if [[ "$VERBOSE" && -z "$QUIET" ]]; then
				echo -n '.';
			fi;
			
		done;
	
		cat $_log >> $ERROR_LOG;
		rm $_log;
		
		if [[ "$_project_not_found" != '' || "$_project_disappeared" != '' ]]; then
			status "unable to find this module project";
			status done;
			return;
		fi;
		
		if [[ "$VERBOSE" && -z "$QUIET" ]]; then
			echo -n "$_try_tag";
		fi;
		
	fi;
	

	status done;
}

# Function: Check out Drupal theme project
# Usage: cvsCoTheme project [branch] [version]
# ----------------------------------------------------------------------------

function cvsCoTheme() {
	local _project=${1:-devel};
	local _branch=${2:-HEAD};
	local _version=$3;
	
	if [[ -e $PROFILE && `cat $PROFILE | egrep ^LockThemeVersion | egrep $_project | egrep $_branch | wc -l | tr -d ' '` != '0' ]]; then
		_version=`cat $PROFILE | egrep ^LockThemeVersion | egrep $_project | egrep $_branch | awk {'print $4'}`;
	fi;

	if [ ! -d $TREE_THEME/$_branch ]; then 
		mkdir -p $TREE_THEME/$_branch;
	fi;
	cd $TREE_THEME/$_branch;
	
	local _tag;
	case "$_branch" in
		HEAD )	_tag=HEAD; _dir=HEAD;;
		* )			_tag=DRUPAL-$_branch; _dir=$_project;;
	esac;
	
	if [ "$_version" ]; then
		# @todo _version =~ s/./-/g
		_tag=$_tag--$_version;
	fi;
	
	status "Fetching $_project theme ($_tag)";

	if [ "$FORCE" ]; then
		rm -fR $_project;
	fi;
	
	if [ -d $_project ]; then 
		status "already exists locally";
		status done;
		return;
	fi;

	if [ "$_version" ]; then
	
		# Check out a specific version...
	
		status " ($_tag)";
		cvs $CVS_CONTRIB_REPO -Q co -d $_project -r $_tag $CVS_THEME_REPO_DIR/$_project
		if [ ! -d $_project ]; then
			status "unable to checkout this theme project";
			status done;
			return;
		fi;
	
	else
	
		# Find latest version...
		
		local _checkout_by_version=0
		local _checkout_by_branch=1
		local _checkout_head=2
		local _project_not_found;
		local _tag_not_found;
		local _try_tag;
		local _exit=NO;
		local _log=.tmp_log;
		
		touch $_log;
		
		if [ "$_tag" == 'HEAD' ]; then _checkout=$_checkout_head;
		else _checkout=$_checkout_by_version;
		fi;
		
		until [[ -d $_project || "$_project_not_found" != '' || "$_project_disappeared" != '' || "$_exit" == 'YES' ]]; do
		
			case "$_checkout" in
			
				"$_checkout_by_version" )
					if [ -z "$_try_tag" ]; then
						_version=8;	# not spotted any versions higher than 7
						_try_tag=$_tag--$_version;
					fi;
					if (("$_version" > "1")); then
						_version=$[$_version -1];
						_try_tag=$_tag--$_version;
					else 
						_checkout=$_checkout_by_branch;
					fi;
					;;
					
				"$_checkout_by_branch" )
					if [ "$_try_tag" == "$_tag" ]; then
						_checkout=$_checkout_head;
					else
						_try_tag=$_tag;
					fi;
					;;
					
				"$_checkout_head" )
				  if [ "$_try_tag" == 'HEAD' ]; then
						_exit=YES;
					else
						_try_tag=HEAD;
					fi;
				  ;;
				  
				* )
					_exit=YES;
					;;
			esac;
			
			cvs $CVS_CONTRIB_REPO -Q co -d $_project -r $_try_tag $CVS_THEME_REPO_DIR/$_project 2>$_log;
			
			_project_not_found=`cat $_log | grep 'could not read RCS file'`;
			_project_disappeared=`cat $_log | grep 'has disappeared'`;
			_tag_not_found=`cat $_log | grep 'no such tag'`;
			
			if [[ "$VERBOSE" && -z "$QUIET" ]]; then
				echo -n '.';
			fi;
			
		done;
	
		cat $_log >> $ERROR_LOG;
		rm $_log;
		
		if [[ "$_project_not_found" != '' || "$_project_disappeared" != '' ]]; then
			status "unable to find this theme project";
			status done;
			return;
		fi;
		
		if [[ "$VERBOSE" && -z "$QUIET" ]]; then
			echo -n "$_try_tag";
		fi;
		
	fi;
	
	status done;
}

# Function: Update Drupal core
# Usage: cvsUpCore [branch]
# ----------------------------------------------------------------------------

function cvsUpCore() {
	local _tag;
	local _dir;
	
	case "$1" in
		HEAD | '' ) _tag=HEAD; _dir=HEAD;;
		* )					_tag=DRUPAL-$1; _dir=$1;;
	esac;
	
	if [ -d $TREE_CORE/$_dir ]; then
		cd $TREE_CORE/$_dir;
		status "Updating $_tag";
		cvs -Q up -d -P 2>>$ERROR_LOG;
		status done;
	else
		status error "Oops! It seems core $_dir does not exist. Perhaps you should use the dstm get core $_dir command.";
	fi;
}

# Function: Update Drupal module project
# Usage: cvsUpModule [project] [branch]
# ----------------------------------------------------------------------------

function cvsUpModule() {
	local _project=${1:-devel};
	local _branch=${2:-HEAD};
	
	if [ -d $TREE_MODULE/$_branch/$_project ]; then
		cd $TREE_MODULE/$_branch/$_project;
		status "Updating $_project module ($_branch)";
		cvs -Q up -d -P 2>>$ERROR_LOG;
		status done;
	else
		status error "Oops! It seems module $_project $_branch does not exist. Perhaps you should use the dstm update module $_project $_branch command.";
	fi;
}

# Function: Update Drupal theme project
# Usage: cvsUpTheme [project] [branch]
# ----------------------------------------------------------------------------

function cvsUpTheme() {
	local _project=${1:-devel};
	local _branch=${2:-HEAD};
	
	if [ -d $TREE_THEME/$_branch/$_project ]; then
		cd $TREE_THEME/$_branch/$_project;
		status "Updating $_project theme ($_branch)";
		cvs -Q up -d -P 2>>$ERROR_LOG;
		status done;
	else
		status error "Oops! It seems theme $_project $_branch does not exist. Perhaps you should use the dstm update theme $_project $_branch command.";
	fi;
}