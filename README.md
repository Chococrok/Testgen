# Testgen

A simple script to generate the java tests from the existing java classes.

## How to use:

Your classes need to be in a `src/main/java`.

Then simply run the script  with the path to the folder containing your java classes.

A `-o` argument is available if you wish to override existing test.

### examples:
`./testgen .`

`./testgen '/home/user/path/to/folder'`

`./testgen -o .`

