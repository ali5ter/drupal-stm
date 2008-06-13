# Base directory of local Drupal source tree
# ----------------------------------------------------------------------------

BASE=${DSTM_BASE:-~/.dstm};

# Drupal CVS core repository
# ----------------------------------------------------------------------------

CVS_REPO=${DSTM_CVS_REPO:-'-d:pserver:anonymous:anonymous@cvs.drupal.org:/cvs/drupal'};

# Drupal CVS contrib repository
# ----------------------------------------------------------------------------

CVS_CONTRIB_REPO=${DSTM_CVS_CONTRIB_REPO:-'-d:pserver:anonymous:anonymous@cvs.drupal.org:/cvs/drupal-contrib'};

# Drupal contrib module directory in the CVS repository
# ----------------------------------------------------------------------------

CVS_MODULE_REPO_DIR=${DSTM_CVS_MODULE_REPO_DIR:-contributions/modules};

# Drupal contrib theme directory in the CVS repository
# ----------------------------------------------------------------------------

CVS_THEME_REPO_DIR=${DSTM_CVS_THEME_REPO_DIR:-contributions/themes};

# Core location in the Drupal source tree
# ----------------------------------------------------------------------------

TREE_CORE=${DSTM_TREE_CORE:-$BASE/core};

# Contrib module location in the Drupal source tree
# ----------------------------------------------------------------------------

TREE_MODULE=${DSTM_TREE_MODULE:-$BASE/contrib/modules};

# Contrib themes location in the Drupal source tree
# ----------------------------------------------------------------------------

TREE_THEME=${DSTM_TREE_THEME:-$BASE/contrib/themes};

# Profile desciption of the Drupal source tree
# ----------------------------------------------------------------------------

PROFILE=${DSTM_PROFILE:-$BASE/profile};

# Error log location
# ----------------------------------------------------------------------------

ERROR_LOG=${DSTM_ERROR_LOG:-$BASE/error.log};

# Defined editor
# ----------------------------------------------------------------------------

EDITOR=${EDITOR:-vi};

# Time stamp format
# ----------------------------------------------------------------------------

TIMESTAMP=`date +"%H-%M_%Y-%b-%d"`;
