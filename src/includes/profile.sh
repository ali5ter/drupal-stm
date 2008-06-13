# Function: Create a list of branches from the profile
# ----------------------------------------------------------------------------

function profileBranches() {
	if [[ -e $PROFILE && `cat $PROFILE | egrep ^IncludeBranch | wc -l | tr -d ' '` != '0' ]]; then
		local _index=0;
		for _branch in `cat $PROFILE | egrep ^IncludeBranch | awk {'print $2'}`; do
			BRANCHES[$_index]=$_branch;
			(( _index += 1 ));
		done;
	fi;
}

# Function: Create a list of include modules from the profile
# ----------------------------------------------------------------------------

function profileModules() {
	if [[ -e $PROFILE && `cat $PROFILE | egrep ^IncludeModule | wc -l | tr -d ' '` != '0' ]]; then
		local _index=0;
	 	for _project in `cat $PROFILE | egrep ^IncludeModule | awk {'print $2'}`; do
	 		MODULES[$_index]=$_project;
			(( _index += 1 ));
	 	done;
	fi;
}

# Function: Example data for a dstm profile
# Usage: profile [show|update|delete]
#        profile import file
#        profile export [file]
# ----------------------------------------------------------------------------

function profile() {
	local _action=${1:-show};
	local _timestamp=`date +"%H-%M_%Y-%b-%d"`;
	local _file=${2-./dstm-$_timestamp.profile};
	
	case "$_action" in
		sample )
			status "Creating sample profile...";
			if [ ! -e $PROFILE ]; then
				cat > $PROFILE <<_END_OF_SAMPLE_PROFILE_;
# ----------------------------------------------------------------------------
# @file Drupal source tree manager (dstm) Profile
# @created $_timestamp
# @modified $_timestamp
# ----------------------------------------------------------------------------

# INCLUDE BRANCHES TO THE SOURCE TREE
# ----------------------------------------------------------------------------
# Add the branches that should appear in the local Drupal source tree. By 
# default the HEAD branch will be built if nothing is defined here.
# e.g. IncludeBranch 6 
IncludeBranch 5
IncludeBranch 6

# INCLUDE MODULES WHEN BUILDING THE SOURCE TREE
# ----------------------------------------------------------------------------
# Add the modules that should be included for each branch defined above. These
# are checked out of CVS when the source tree is built. 
# e.g. IncludeModule devel
IncludeModule backup_migrate
IncludeModule devel
IncludeModule simplemenu
IncludeModule logintoboggan
IncludeModule pngfix

# EXCLUDE MODULES WHEN BUILDING THE SOURCE TREE 
# ----------------------------------------------------------------------------
# Define which of the modules defined about should not be included into a
# branch.
# e.g. ExcludeModule backup_migrate 6
ExcludeModule backup_migrate 6

# INCLUDE THEME WHEN BUILDING THE SOURCE TREE
# ----------------------------------------------------------------------------
# Add the themes that should be included for each branch defined above. These
# are checked out of CVS when the source tree is built. 
# e.g. IncludeTheme zen
IncludeTheme zen

# LOCK A MODULE TO A SPECIFIC VERSION
# ----------------------------------------------------------------------------
# To help define module version dependencies within branches, use the
# LockModuleVersion stanza to specify a version for a branch. This is override
# any 'dstm get' command for the defined module, effectively locking down its
# version.
# e.g. LockModuleVersion date 5 1-8
LockModuleVersion image 5 1-8
LockModuleVersion date 5 1-8
LockModuleVersion actions 5 2-4
LockModuleVersion workflow 5 2-2

# LOCK A THEME TO A SPECIFIC VERSION
# ----------------------------------------------------------------------------
# To help define theme version dependencies within branches, use the
# LockThemeVersion stanza to specify a version for a branch. This is override
# any 'dstm get' command for the defined module, effectively locking down its
# version.
# e.g. LockThemeVersion zen 5 1-1
_END_OF_SAMPLE_PROFILE_
			fi;
			status done;;
			
		update )
			if [ ! -e $PROFILE ]; then
				echo -n "I could not find an existing profile. ";
				echo "As a starting point, I can create a sample profile for you to edit.";
				echo -n "$(color bd)Should I create a sample profile (Yes|No) ? $(color off): ";
				read confirmation;
				if [ "$confirmation" == 'Yes' ]; then
					echo;
					profile sample;
				fi;
				echo;
			fi;
			status "Updating dstm profile...";
			$EDITOR $PROFILE 2>>$ERROR_LOG;
			# @todo $_timestamp
			status done;;
		
		delete )
			if [[ -e $PROFILE && -z "$FORCE" ]]; then
				echo -n "I am about to delete your existing dstm profile. ";
				echo "Doing this removes my memory of default branches in your source tree, version dependencies, etc.";
				echo -n "$(color bd)Are you ready to continue (Yes|No) ? $(color off): ";
				read confirmation;
				if [ "$confirmation" != 'Yes' ]; then
					echo "$(color green)$(color bd)Cancelling$(color off)";
					exit 1;
				fi;
				echo;
			fi;
			status "Deleting dstm profile...";
			rm -fR $PROFILE 2>>$ERROR_LOG;
			status done;;
			
		show )
			status "This is your current dstm profile...";
			echo;
			echo;
			cat $PROFILE;;
			
		export )
			status "Exporting your dstm profile to $_file";
			cp $PROFILE $_file 2>>$ERROR_LOG;
			status done;;
		
		import )
			if [ -e $_file ]; then
				status "Importing $_file to your dstm profile";
				cp $_file $PROJECT 2>>$ERROR_LOG;
				status done;
			else
				status error "I need a file to import. Could you include the filename in the command next time. Thanks!";
			fi;;
			
	esac;
}
