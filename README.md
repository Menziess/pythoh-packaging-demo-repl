# python-packaging

Just a simple demo, demonstrating the advantages of packaging python code.

[![Run on Repl.it](https://repl.it/badge/github/menziess/python-packaging)](https://repl.it/github/menziess/python-packaging)

## Introduction

This is a very basic, bare bone example of (white-label) packaging python code by running a build pipeline.

1. Fork this repository, change the `package.name` variable in the `azure-pipelines.yml` file
2. Commit and push the change to your new remote repository
3. The build pipeline will run and produce an artifact
4. Click on the build pipeline runs page, and select the latest run
5. In the run summary page press `Ctrl + f`, then type in "published", and click on the highlighted result, and download the published artifact on the artifact page
6. Open your terminal in your downloads folder, and run the following command to install your downloaded artifact:

   ```bash
   pip install *.whl
   ```

7. Then run the package to prove that it works:

   ```bash
   python -m <package name> <args>
   ```
