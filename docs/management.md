# Management

Deployment of the website is now handled using drone ci.

To do a new build, go to [the drone page](https://drone.fsfe.org/FSFE/fsfe-website).

If you have the correct permission, you will see a blue new build button in the upper right corner.

After it is pressed, a popup for the new build will appear on-screen. Select the branch the wish to build, `master` or `test`.

To pass extra arguments to the build script add a parameter with key `EXTRA_FLAGS` and the values being an unquoted list of arguments. For example to do a full build one would do `--full`. Be sure and hit the add message on the right after setting to actually enable the parameter for the build. Then hit create, and away we go.
