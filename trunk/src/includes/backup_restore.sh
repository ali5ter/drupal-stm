# Function: Read the local source tree to generate a profile
# Usage: backup [file]
# ----------------------------------------------------------------------------

function backup() {
	local _timestamp=`date +"%H-%M_%Y-%b-%d"`;
	local _file=${1-$PWD/dstm-$_timestamp.backup};
	local _tag;
	local _version;
	local _revision;
	status "Backing up source tree description to $_file";
	cat > $_file <<_END_OF_HEADER_;
# ----------------------------------------------------------------------------
# @file Drupal source tree manager (dstm) backup
# Created by dstm backup as a description of the entire source tree.
# @created $_timestamp
# ----------------------------------------------------------------------------
_END_OF_HEADER_
	cd $TREE_CORE;
	for i in `ls`; do
		echo "IncludeBranch $i" >> $_file;
		cd $TREE_MODULE/$i;
		for j in `ls`; do
			_tag=$(getCVStag module $i $j);
			_version=`echo $_tag | cut -d'-' -f4`;
			_revision=`echo $_tag | cut -d'-' -f5`;
			if [[ "$_revision" != '' && "$_tag" != 'HEAD' ]]; then
				_version=$_version'-'$_revision;
			fi;
			echo "LockModuleVersion $j $i $_version" >> $_file;
		done;
	done;
	status done;
}


# Function: Read a backup profile to build a local source tree
# Usage: restore [file]
# ----------------------------------------------------------------------------

function restore() {
	local _file=$PWD/$1;
	if [ -e $_file ]; then
		status "Restoring source tree from $_file";
		PROFILE=$_file;
		QUIET=1;
		FORCE=1;
		profileBranches;
		profileModules;
		build;
		QUIET=;
		status done;
	else
		status error "Unable to find $_file to restore from";
	fi;
}