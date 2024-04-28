# script-wizard
A fully automated installer for python scripts.

# Requirements
- The shell should be `bash`
- MacOS or Linux
- The system package manager must be `apt` or `yum` for Linux environments and `brew` for MacOS enviroments
- The python script must be a single file inside placed under the `src/` directory of the project

# Usage
1) Copy the `install.sh` script to your project root directory
2) Edit the script replacing the 3 variables as described below:
    - `PROGRAMNAME` is the **full program name** such as "My Project"
    - `DEVELOPERNAME` is the **developer name** such as "My Name"
    - `SHORTPROGRAMNAME` is the **git like project name** such as "my-project"

