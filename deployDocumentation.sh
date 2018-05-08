#!/bin/sh
################################################################################
# Title         : deployDocumentation.sh
# Date created  : 2018/05/08
# Notes         : ./generateDocumentation.sh have to be on the root of the project
#                 $GH_REPO_NAME : The name of the repository (work on)
#                 $DOC_BUILD_DIR : The path where the documentation is generated (full path from the root of the project)
#                 GH_REPO_TOKEN : Token to push on documentation repository
__AUTHOR__="Vinetos"
# Useful variables
DOCUMENTATION_PATH=code_docs/documentations/$GH_REPO_NAME
GH_REPO_REF=github.com/islands-wars/documentations.git
################################################################################

################################################################################
##### Setup this script and get the current gh-pages branch.               #####
echo "Setting up th script..."
# Exit with nonzero exit code if anything fails
set -e

# Create a clean working directory for this script.
mkdir code_docs
cd code_docs/

# Clone documentations repository (only master branch)
git clone --depth=1 -b master https://git@${GH_REPO_REF}
cd documentations/

# Create folder for the current project if not exist
mkdir -p $GH_REPO_NAME
cd $GH_REPO_NAME

##### Configure git.
# Set the push default to simple i.e. push only the current branch.
git config --global push.default simple
# Pretend to be an user called IslandsWars Documentation.
git config user.name "IslandsWars Documentation"
git config user.email "admin@islandswars.fr"

# Remove everything currently in the project documentation's folder.
# GitHub is smart enough to know which files have changed and which files have
# stayed the same and will only update the changed files. So the gh-pages branch
# can be safely cleaned, and it is sure that everything pushed later is the new
# documentation.
rm -rf *

################################################################################
#####                    Generate the code documentation                   #####
echo 'Generating Documentations...'

# Execute the documentation build script
cd $TRAVIS_BUILD_DIR
chmod +x generateDocumentation.sh
./generateDocumentation.sh

################################################################################
#####              Upload the documentation to the repository.             #####
if [ -d $DOC_BUILD_DIR ]; then

    echo 'Copying and Uploading documentation...'

    cp -R $DOC_BUILD_DIR/* ${DOCUMENTATION_PATH}
    cd ${DOCUMENTATION_PATH}

    # Add everything in this directory (the documentation) to the gh-pages branch.
    # GitHub is smart enough to know which files have changed and which files have
    # stayed the same and will only update the changed files.
    git add --all

    # Commit the added files with a title and description containing the Travis CI
    # build number and the GitHub commit reference that issued this build.
    git commit -m "Deploy ${GH_REPO_NAME} documentation." -m "Travis build: ${TRAVIS_BUILD_NUMBER}" -m "Commit: ${TRAVIS_COMMIT}"

    # Force push to the remote gh-pages branch.
    # The output is redirected to /dev/null to hide any sensitive credential data
    # that might otherwise be exposed.
    git push --force "https://${GH_REPO_TOKEN}@${GH_REPO_REF}" > /dev/null 2>&1

    # Reset location of user and travis info
    cd $TRAVIS_BUILD_DIR
    git checkout $TRAVIS_BRANCH

else
    echo '' >&2
    echo 'Warning: No documentation files have been found!' >&2
    echo 'Warning: Not going to push the documentation to GitHub!' >&2
    exit 1
fi
