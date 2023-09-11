Welcome to the Efficiency Booster PowerShell project!

Efficiency Booster PowerShell Project is a library of my own CmdLets that we will just about to install.

Installation Prerequisites
============================

Here are the most important prerequisites:

1) Enable execution of PowerShell scripts (read more article About Execution Policies in PowerShell documentation)
2) Enable PowerShell remoting on each server in your network in order to run CmdLets on remote servers ( Read more articles: About Remote, About Remote Requirements, About Remote FAQ, About Remote Troubleshooting in PowerShell documentation)
3) Open the ports on the firewall in order for PowerShell remoting to be able to listen to the remote command (port 5985 and 5986 for connections over HTTP and HTTPS, respectively)
4) Check with the Network Infrastructure department about other network segmentation that can have a consequence for PowerShell code.  

Installation
=================

You can read installation instructions on my blog in the post: https://improvescripting.com/how-to-install-and-configure-powershell-cmdlets-modules-profiles/

I will cover two ways how you can install the project files after downloading the zip:

1) The first way covers the situation when you do not have any PowerShell module previously installed in your local profile and it is very easy and straight forward.
2) The second installation covers of course situation when you do have some PowerShell modules already installed on your profile and this installation demands some more steps but do not worry I will walk you through the whole process step by step.

How To Install And Configure PowerShell: CmdLets, Modules, Profiles (Step By Step)
====================

IMPORTANT: If you have installed Efficiency Booster PowerShell project files and you want to refresh/update installation with the latest files that you have just downloaded then take a backup of your WindowsPowerShell folder first just in case then overwrite all the files in My Documents and everything should be updated.

NOTE: If you want to install these CmdLets to PowerShell v 6.0 then copy the files to the “PowerShell” folder since this is the home folder for this version of PowerShell and not WindowsPowerShell.

Step 1 – Check-in My documents folder whether you have a folder with the exact name “WindowsPowerShell”.
If you do have such a folder in your My Documents than please bear with me and I will explain installation in a minute. This is the second installation scenario that I have just mentioned.
If you do not have such folder in your My Documents then the installation is pretty easy and straight forward since this is a clean installation of PowerShell files

Step 2 – Just unzip the content of Efficiency Booster zip file in My Documents and you have all the necessary project files.


Customization
-------------------

Now we need to do small customization in one CSV file so when you run Efficiency Booster CmdLets on your own machine it will show you accurate data about your machine name and IP address.

Step 3 – Open file OKFINservers.csv in ...Documents\WindowsPowerShell\Modules\01servers folder and change the following data:

- in the second line write your local machine’s name instead of localhost
- in the second line write your local machine’s IP address instead of 192.125.1.1
- APP3 means Application server number 3 (no need to change for now)
- PROD means Production environment (no need to change for now)

you can change the last two data according to the role of your local machine or you can leave them as it is for now. I will explain these columns in more detail in further posts.

The installation has been finished for this scenario.

Well Done!!!

------------------------------------------------------------------------------

You can move on to the testing section that I will show in a minute.

Now let’s install the project files in the second scenario when you do have the “WindowsPowerShell” folder in My Documents folder. Basically, that means that you probably either already have some other 3rd party CmdLets installed previously that you use it or you may be just customized your profile files to your needs and we do not want to mess them up by overwriting with our project files with the same name.

Step 4 – So unzip the Efficiency Booster zip file in some temp folder.

Step 5 – copy all the files and folders from the Modules folder into the Modules folder within your …\Documents\WindowsPowerShell\Modules folder.

Now we have all the PowerShell CmdLets from Efficiency Booster project except PowerShell profile files.

Step 6 – Open the Profile.ps1 file in your temp folder and copy the content of that file.

Step 7 – Go to …\Documents\WindowsPowerShell and open Profile.ps1 file there and paste the content that you have just copied. Now we have linked Efficiency Booster modules to your existing PowerShell profile plus you keep the content of your profile that has some other 3rd party modules that you have previously installed or some other profile customization. So next time when you open your PowerShell shell your profile will load Efficiency Booster modules as well.

Step 8 – Open Microsoft.PowerShellISE_profile.ps1 file in your temp folder and copy the content of that file.

Step 9 – Go to …\Documents\WindowsPowerShell and open Microsoft.PowerShellISE_profile.ps1 file there (if you do not have it then copy the whole file from a temp folder) and paste the content that you have just copied.

NOTE: – While we run the CmdLets that are part of the Efficiency Booster PowerShell project the following folders will be created in My documents folder:

- PSbaselines (keeps XML files)
- PSlogs (writes all the errors within CmdLets run into Error_Log.txt file)
- PSreports (Excell sheet reports are written here)

In future posts, I will explain the use of each folder so you understand the reason for their existence but for now does not worry too much about them.

Repeat step 3 – We need to do the same customization for this scenario as we did with the first scenario installation and that is to edit the CSV file.

Testing
------------------

Let’s quickly test our installation and customization to make sure that everything has been correctly done.

First, we can test that all the modules load in PowerShell Console Environment:

Get-Module -ListAvailable

Second, we want to check that command of all the modules has been loaded as well in PowerShell Console Environment:

Get-Command -Module 03common 

Finally, we want to test one of the CmdLets in the installed project. Copy the following code and run from PowerShell Console.

Get-CPUInfo -client "OK" -solution "FIN"

As a result of running Get-CPUInfo CmdLet, we should get CPU properties for the local machine. Check that the value for Server Name is correct for your local machine and IP address is exactly as the one that we have done in the customization section.

===============================
Congratulations and Well Done!
===============================

----------------------------------

Disclaimer
==========

All code examples shown in the Efficiency Booster PowerShell project have been tested by the developer and every effort has been made to ensure that they are error-free, but since every environment is different, they should not be run in a production environment without thoroughly testing them first. It is recommended that you use a non-production or lab environment to thoroughly test code examples used throughout this project. All data and information provided in this code are for educational purposes only. The developers make no representations as to accuracy, completeness, correctness, suitability, or validity of any information in this project and will not be liable for any errors, omissions, or delays in this information or any losses, injuries, or damages arising from its display or use. All information is provided on an as-is basis.

This disclaimer is provided simply because someone, somewhere will ignore this disclaimer and in the event that they do experience problems or a “resume generating event”, they have no one to blame but themselves. Don’t be that person!

Feedback
Let me know if I can improve this project in anyway by writing to support@improvescripting.com

Please do not spam me! Thank you.

Enjoy! 

Dejan Mladenović

IMPROVESCRIPTING.COM