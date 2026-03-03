Documentation Link: https://github.com/smitja21/group-a-oe2/wiki/%5B-Lab-2.1-%5D-Systemd

Team / Individual Name: Erika Stuart and Joshua Smith

Server Hostname: backup-a

Reflection (what problems does systemd solve
that your hello.service exercise exposed): 

The hello.service exercise exposed the importance of a well created and robust service. With there the diskmon service had a dedicated user to control permisions. Where the hello.service lacked this and ran as root which introduces secuirty issues. Where if a script has a vulnerablity it could lead to a hacker having root access to the machine. 

hello.service missed a restart policy which if it was to crash, the service wouldn't restart automatilcy and would require someone to manualy restart the service.

The hello.service missed any configuration file (.env) which meant any settings couldn't be serpated out where with the diskmon they could allowing a user just to look the .env to change log level and disk warning threshold. 








