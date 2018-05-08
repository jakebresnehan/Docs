# IslandsWars documentations  
Here you can find all documentations for these IS projects :
- [API/Core](/islands/index.html?overview-summary.html)
- [Hub](/hub/index.html?overview-summary.html) 

# How to add to an IS project's documentation :
1. Create a new script called **``generateDocumentation.sh``**. It should contains **every commands** you need to generation the HTML documentation.
Here's an example : 
```bash
#!/bin/sh
# Javadoc generation with gradle
chmod +x gradlew
./gradlew javadoc
```
2. Update the .travis.yml with :
```yaml
# Documentation variables
env:
  global:
    # The name of the current repo (will publish them to doc.islandswars.fr/MyRepo)
    - GH_REPO_NAME: MyRepo
    # Relative path where the documentations is generated
    - DOC_BUILD_DIR: build/docs/javadoc

# Generate and deploy documentation
after_success:
  # Prevent from moving the user
  - cd $TRAVIS_BUILD_DIR
  # Deploy documentation only for the master branch
  - if [ $TRAVIS_BRANCH = "master" ]; then wget -O - https://raw.githubusercontent.com/islands-wars/documentations/master/deployDocumentation.sh | sh ; fi
```
3. Add github token (only admin)
An admin have to configure the build script to add the github token wich allow Travis to push the documentation.