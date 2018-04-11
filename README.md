# Nom - the OpenBD Utility
Nom is a CLI tool for working with OpenBD CFML project.

## Current Functionality
As of right now, Nom can:
* Update an existing project to the latest version of OpenBD (Beta-quality)
* Install CFLib UDFs
* Run server
* Create project
* Show info about the current project (Only Nom info at the moment)
* Download and install MXUnit
* Deploy to Heroku (See details below)

## Planned Functionality
* See the Projects page

## Using it
Nom is a CLI utility, download a release and add it to your PATH, and you should be good to go.

### Create a new project
<pre>$ nom -c MyNewProject</pre>
This will create the MyNewProject folder, download the latest OpenBD version, and create a nomolicious.ini file.

### Adding CFLib UDFs
CFLib has lots of useful UDFs, for ease-of-use Nom has the ability to install them for you.

Let's say you want to have the CFLib UDF "IsWeekDay", just run this command
<pre>$ nom -i IsWeekDay</pre>
It'll download the UDF from CFLib.org, wrap it as a cfcomponent, and save it to the WEB-INF/customtags/cflib/IsWeekDay.cfc directory with the same name as the UDF.

### Running the project
To run the project just CD to the project root and run
<pre>$ nom -r</pre>
This will launch a local Jetty server with the port and maxmemory you set up during the project creation, just hit CTRL-C to shut it down.

### Deploying to Heroku
Heroku deployment is simple.
Just create a new app in your Heroku account, make sure you have Heroku CLI set up and have logged into it, edit the nomolicious.ini file by adding a [Heroku] section like so: 

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
</pre>

## General Information

### Language
Nom is written in Object Pascal using Lazarus

### License
GPL3

### Roadmap/Plan
There's no specific roadmap for this project, it's mostly on an 'I want this functionality so I'm adding it'-type of schedule.

I'm happy to listen to ideas though, please feel free to get in touch if there are things you'd like to see in Nom.
