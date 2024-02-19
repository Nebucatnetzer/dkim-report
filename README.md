# DKIM Reports

This repository helps you to convert DKIM reports to HTML and then serve them with a web server.
This way you can easily look at the reports and see if there are any issues with your DKIM setup.

## How to use

You need to have Nix installed with Flakes enabled.
Then you can clone this repository, cd into it and run the following command:

```sh
nix run .#dkim-report
```

The script will create an **html** and a **xml** directory.
The **xml** directory is used to store the DKIM reports and the **html** directory is used to store the converted reports.
You can add .zip and .tar.gz files to the **xml** directory and the script will automatically extract them.
After the script converted the reports iptables will open port 8080 and then the webserver will serve the reports.
