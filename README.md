# Nom - the OpenBD Utility
Nom is a small project to create a commandline tool work working with the OpenBD CFML project.

I wanted a simple way to manage projects, install CFLib UDFs, update to the latest version, and so on.

## Current Functionality

As of right now, Nom can:
* Update an existing project to the latest version of OpenBD
* Create nomolicious files
* Install CFLib UDFs
* Run server
* Create project
* Show info about the current project (Only Nom info at the moment)
* Show a little info about Nom

## Planned Functionality
* Run MXUnit tests and display results
* Update itself to the latest version

## OS Compatability
The code is pretty much cross-platform, mostly just have to take edgecases into account.

I'm developing this on a Mac, but I'll try to make sure to have releases for Mac, Windows, and Linux when I do releases.

## Current State
Here's the current nom -h output to give you an idea of what's there and what to expect.

<pre>

 <-. (`-')_            <-. (`-')  
    \( OO) )     .->      \(OO )_ 
 ,--./ ,--/ (`-')----. ,--./  ,-.)
 |   \ |  | ( OO).-.  '|   `.'   |
 |  . '|  |)( _) | |  ||  |'.'|  |   Nom, the OpenBD utility
 |  |\    |  \|  |)|  ||  |   |  |
 |  | \   |   '  '-'  '|  |   |  |   Version 0.1.0
 `--'  `--'    `-----' `--'   `--'
 
nom -c      Create a new OpenBD project
            Example: nom -c AwesomeProject creates a new folder AwesomeProject and installs the latest OpenBD version
 
nom -r      Runs the project with a Jetty server
 
nom -u      Update the projects version of OpenBD to the current Nightly
 
nom -h      Shows this wonderful help
 
nom -x      Runs your unit tests at /mxunit/tests
 
nom -i      Downloads and installs a CFLib UDF to WEB-INF/customtags/cflib/
            Example: nom -i IsWeekend. It's then available by calling IsWeekend() from CFML
 
nom -s      Turn existing project into Nom project
 
nom -p      Show information about the current project
 
nom --nom   Update Nom to the latest version
</pre>

## General Information

### Language
Nom is written in Object Pascal using Lazarus

### License
Nom is open sourced, licensed under GPL3

### Roadmap/Plan
There's no specific roadmap for this project, it's mostly on an 'I want this functionality so I'm adding it'-type of schedule.

I'm happy to listen to ideas though, please feel free to get in touch if there are things you'd like to see in Nom.
