**Update: I've abandoned support of this project in favour of using [drush](http://drupal.org/project/drush). Check it out. You'll love it**

I sometimes use [Drupal](http://drupal.org) for my web development work.

As part of my development workflow, I pull any Drupal Core and Contributed source from [Drupal CVS](http://drupal.org/handbook/cvs/introduction). I call the resulting collection of code my local Drupal source tree and use **make** in my various Drupal projects to build in the Core and Contrib that I need from this tree. This way I can keep  everything in one place, control updates, and use **SVN** for my Drupal projects without effecting the CVS control of the source tree.

**dstm** is a simple bash script I created some time ago to manage this Drupal source tree. **dstm** can update the entire tree using one command. I can keep a **dstm** profile for any version dependencies of Contrib projects within specific Drupal branches (versions) and **dstm** will find the latest version of a module without having to look up the [CVS Tag that controls module versioning](http://drupal.org/handbook/cvs/branches-and-tags/contributions). **dstm** also generates a sample Makefile for new Drupal projects.

Due to interest from others who wanted to use **dstm** in their own workflow, I decided to clean up the script and release it. Please use it if you think it useful.

**Note**: I am aware of the [drush project](http://drupal.org/project/drush). At the time I used it, drush was really great but **dtsm** solved a few different problem for me. However, you should also check it out.

More documentation to come.

## Usage ##
**dstm init** = **dstm clean**; **dstm get profile**; **dstm build**

**dstm build** = **dstm get core**; **dstm get module**; **dstm get theme**

**dstm get** [core | C ](.md) [branch ](.md)

**dstm get** [module | M ](.md) [project ](.md) [branch ](.md) [version ](.md)

**dstm get** [theme | T ](.md) [project ](.md) [branch ](.md) [version ](.md)

**dstm update** = **dstm update all**

**dstm update profile**

**dstm update** [core | C ](.md) [branch | all ](.md)

**dstm update** [module | M ](.md) [project | all ](.md) [branch ](.md)

**dstm update** [theme | T ](.md) [project | all ](.md) [branch ](.md)

**dstm delete** = **dstm delete all**

**dstm delete profile**

**dstm delete** [core | C ](.md) [branch | all ](.md)

**dstm delete** [module | M ](.md) [project | all ](.md) [branch ](.md)

**dstm delete** [theme | T ](.md) [project | all ](.md) [branch ](.md)

**dstm info** = **dstm info all**

**dstm info profile**

**dstm info** [core | C ](.md) [branch | all ](.md)

**dstm info** [module| M ](.md) [project | all ](.md) [branch ](.md)

**dstm info** [theme| T ](.md) [project | all ](.md) [branch ](.md)


### Options ###
-q | --quiet

-v | --verbose

-f | --force


## Examples ##

To automatically create a Drupal source tree for your development environment:
```
  dstm init
```
To view what Drupal core items are in your tree:
```
  dstm info core
```
To view what Drupal 6 modules are in your tree:
```
  dstm info module 6
```
Edit the profile:
```
  dstm update profile
```
To retrieve the most recent Views module for all branches defined in the profile and use the verbose option to see what version is actually retrieved:
```
  dstm -v get module view
```
To retrieve a specific version of the Date module for Drupal 5:
```
  dstm get module date 5 1.8
```
To delete all Drupal 5 core and contrib modules from your source tree:
```
  dstm del C 5; dstm del M 5;
```

## Environment ##
DSTM\_BASE

DSTM\_CVS\_REPO

DSTM\_CVS\_CONTRIB\_REPO

DSTM\_CVS\_CONTRIB\_REPO\_DIR

DSTM\_TREE\_CORE

DSTM\_TREE\_MODULE

DSTM\_TREE\_THEME

DSTM\_PROFILE

DSTM\_ERROR\_LOG

EDITOR