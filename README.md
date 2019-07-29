# Nom - OpenBD CLI Tool
Nom is a commandline tool for OpenBD CFML projects.

[OpenBD Website](http://openbd.org/) - [OpenBD GitHub](https://github.com/OpenBD/openbd-core)

![OpenBD Banner](https://github.com/OpenBD/openbd-core/blob/master/openBD_logo_788x150px.png?raw=true "OpenBD banner")

Nom is built in FreePascal (Object Pascal)

[![Built with Freepascal logo](built_with_fpc_logo.png?raw=true "Built with Freepascal logo")](https://www.freepascal.org/)

## What can it do?
* Install CFLib UDFs
* Run up the server
* Create project
* Show info about the current project (Only Nom info at the moment)
* Download and install MXUnit
* Deploy to Heroku

## What's it going to be able to do?
* See the [Projects](https://github.com/MFernstrom/nom/projects) page

## Installing
Nom is a CLI program and needs to be added to your Path.

Mac: http://osxdaily.com/2014/08/14/add-new-path-to-path-command-line/

Windows: http://www.itprotoday.com/management-mobility/how-can-i-add-new-folder-my-system-path

In the future I'll make proper installers.

### Create a new project
<pre>$ nom -c MyNewProject</pre>
This will create the MyNewProject folder, download the latest OpenBD version, and create a nomolicious.ini file.

### Adding CFLib UDFs
[CFLib](https://cflib.org/) has a lot of useful UDFs, for ease-of-use Nom has the ability to install them for you.

Let's say you want to have the CFLib UDF [IsWeekDay](https://cflib.org/udf/IsWeekday), just run this command
<pre>$ nom -i IsWeekDay</pre>
It will download the UDF from CFLib.org, wrap it as a cfcomponent, and save it to the WEB-INF/customtags/cflib/IsWeekDay.cfc directory with the same name as the UDF.

### Running the project
To run the project just CD to the project root and run
<pre>$ nom -r</pre>
This will launch a local Jetty server with the port and maxmemory you set up during the project creation, just hit CTRL-C to shut it down.

You can also tell Nom to open your browser once it's ready by adding the `--open` option
<pre>$ nom -r --open</pre>

### Deploying to Heroku
Heroku deployment is simple.

Requirements
* Herok CLI - https://devcenter.heroku.com/articles/heroku-cli
* CLI deployment plugin - https://devcenter.heroku.com/articles/war-deployment

Process
* Create a new app in your Heroku account
* Log into Heroku CLI on your computer (Otherwise Nom can't use Heroku)
* Enter the name of your app when creating the local project with `Nom -c` or add a [Heroku] section to the nomolicious.ini file in the project directory: 

```
[Heroku]
ProjectName={The name you picked in Heroku}
```
Then you can use "nom --deploy --heroku" and it will create a WAR file of the project and deploy to your Heroku account.

## OS Compatibility
The code is fairly cross-platform, once Nom's out of Beta status there will be releases for Windows, Mac, and Linux.

## Current State
Here's the current nom -h output to give you an idea of what's there and what to expect.

<pre>

 <-. (`-')_            <-. (`-')  
    \( OO) )     .->      \(OO )_ 
 ,--./ ,--/ (`-')----. ,--./  ,-.)
 |   \ |  | ( OO).-.  '|   `.'   |
 |  . '|  |)( _) | |  ||  |'.'|  |
 |  |\    |  \|  |)|  ||  |   |  |
 |  | \   |   '  '-'  '|  |   |  |  Version 0.2.0
 `--'  `--'    `-----' `--'   `--'
 
 -c <project name>         Creates a new project with the latest release of OpenBD
--create <project name>
 
 -r                        Runs the project
--run

--open                    Used with -r/--run to open the browser when the server is ready
 
--website                 Opens the projects Git repo
 
--deploy                  Deploys application with target, only Heroku implemented at the moment
--heroku                  Deployment target - Requires you to be logged into Heroku CLI tools
                              and have a [Heroku] section with a ProjectName=appname in the Nomolicious file
 
 -h                        Shows this wonderful help
--help
 
 -i <UDF name>             Downloads and installs a CFLib UDF to WEB-INF/customtags/cflib/<udfname>.cfc with the same function name
--install <UDF name>      Example: nom -i IsWeekend. It's then available as a cfc from CFML
 
 -s                        Creates nomolicious.ini file for the current project
--setup
 
 -p                        Show information about the current project
--project

</pre>

## General Information

### Language
Nom is written in Object Pascal using Freepascal and Lazarus

### License
GPL3

### Roadmap/Plan
There's no specific roadmap for this project, it's mostly on an 'I want this functionality so I'm adding it' type of schedule.

I'm happy to listen to ideas though, please feel free to get in touch if there are things you'd like to see in Nom.
