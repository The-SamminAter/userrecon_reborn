# UserRecon Reborn

### Status: fully functional, 8 checks implemented, many more planned

This is a re-write of TheLinuxChoice's UserRecon, which is (mostly) broken. This re-write has some extra features, and will (hopefully) be more easy to maintain and add onto.

I suggest using this on on a shell with a black background (for visibility)

### To-do:

- [x] Colors/coloring
- [x] Launch arguments
   - [x] Silent mode
   - [x] Username as a launch argument
      - [x] Set output file creation
      - [x] Accept file creation argument first
   - [x] Set output file creation (on no username entered)
   - [x] Help argument
- [x] Scan function
   - [x] Creation and documentation of the arguments
- [x] Print function
- [ ] Addition/migration of all (original) site/username checks
- [ ] Add name variation option/checking
- [ ] Add terminal size checking (`tput cols`)


----------------

Original README:

----------------

# UserRecon v1.0

# Author: @thelinuxchoice
# https://github.com/thelinuxchoice/userrecon

Find usernames across over 75 social networks
This is useful if you are running an investigation to determine the usage of the same username on different social networks.

![userrecon](./userrecon.png)
