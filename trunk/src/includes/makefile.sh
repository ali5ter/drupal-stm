# Function: Create a sample Makefile and Makefile.local for a Drupal project
# ----------------------------------------------------------------------------

function makefile() {
	status "Creating sample Makefile and Makefile.local for your Drupal project";
	cat > Makefile.sample <<'_END_OF_MAKEFILE_';
# ----------------------------------------------------------------------------
# @file
# Makefile to build a DOCUMENT_ROOT for your Drupal project.
# NOTE: Edit the parameters in your Makefile.local file before running 'make'
# ----------------------------------------------------------------------------

include ./Makefile.local

RSYNC := rsync -a -L --log-format='%f' --exclude '.svn' --exclude 'CVS' \
--exclude '.DS_Store' --exclude '*~' --exclude 'bluemarine' \
--exclude 'chameleon' --exclude 'pushbutton'

EXT := drupal drupal-contrib

sync: sync-ext

sync-ext: $(addprefix sync-,$(EXT))

sync-drupal: setup
	$(RSYNC) $(SRC_ROOT)/$(DRUPAL_SRC)/ $(TGT_ROOT)

sync-drupal-contrib: $(addprefix sync-drupal-contrib_,$(CONTRIB_MODULES))

sync-drupal-contrib_%: setup
	$(RSYNC) $(SRC_ROOT)/$(DRUPAL_CONTRIB_SRC)/$* \
	$(TGT_ROOT)/sites/all/modules/contrib/

setup:
	mkdir -p $(TGT_ROOT)/sites/all/modules/contrib
	mkdir -p $(TGT_ROOT)/sites/all/themes
	mkdir -p $(TGT_ROOT)/sites/all/backup
	mkdir -p $(TGT_ROOT)/sites/all/files

refresh: sync
_END_OF_MAKEFILE_
	cat > Makefile.local.sample <<_END_OF_MAKEFILE_LOCAL_;
# ----------------------------------------------------------------------------
# @file 
# Make parameters to customize your build
# @author $USER
# ----------------------------------------------------------------------------

#
# Base directory under which to find build trees
#
SRC_ROOT := /

#
# Document root of the web server you wish to build
#
TGT_ROOT := [Change to your chosen DOCUMENT_ROOT]

#
# The Drupal core tree you wish to build against 
#
DRUPAL_SRC := $TREE_CORE/[Add your branch here]

#
# The Drupal contrib tree you wish to build against
#
DRUPAL_CONTRIB_SRC := $TREE_MODULE/[Add your branch here]

#
# The Drupal contrib modules you'd like to build into this doc root
# This is a space delimited list of module project names,
# e.g. devel logintoboggan pngfix simplemenu
#
CONTRIB_MODULES :=	\
  [Add your project module names here]
_END_OF_MAKEFILE_LOCAL_
	status done;
}