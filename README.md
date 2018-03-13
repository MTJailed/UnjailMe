# UnjailMe
A sandbox escape based on:

- the proof-of-concept (CVE-2018-4087) by Rani Idan (Zimperium)
- @cheesecakeufo's securityd overflow proof-of-concept (zeroday, no CVE known, thank you Abraham!)

# About
Rani used a tool from Jonathan Levine to find out what services were accessible for communication from within the sandbox.

He then found under more bluetoothd.

What he then started doing is setting up code that intercepts messages from and to the service.

He then found that he was able to intercept the session port for many daemons by intercepting the communication.

This is how he gained control over memory registers and was able to run code as those system daemons.

<img src="https://github.com/MTJailed/UnjailMe/blob/master/session_hijacking.png?raw=true" height="300">
<i>Source: Zimperium Blog</i>

# Requirements
- Any device running iOS 10 to 11.2.5 (Vulnerability is badly patched in 11.2.5, needs work).

# What is this
- This is NOT a jailbreak
- The project aims to escalate privilige so code can be ran outside the sandbox with system rights
- This does not give you the ability to write to the rootfilesystem
- Do not expect proper code injection (like houdini), currently no code execution yet at all.
- This project is meant for developers and researchers
- Why is this even a thing? If code injection works jailbreak developers can start development for 11.2 to 11.2.5

# Screenshot
<img src="https://github.com/MTJailed/UnjailMe/blob/master/b.png?raw=true" height="300"/>

# HOW-To
- Run the app
- Turn on bluetooth
- Click escape sandbox
- Wait until the log completes and shows FTP credentials
- Use FileZilla to connect to your iphone and browse files.
- For convenience the path to the appcontainer is shown as the FTP server runs currently inside the sandbox.
- The FTP server has currently nothing to do with the exploit, it was written and compiled by me to be a part of MTJailed.
- The FTP server is based on pureftpd
- The FTP server can eventually be used to transfer files for code injection
- Sometimes the exploit also gains a session for SpringBoard so turning bluetooth off again might cause a respring.


# TROUBLESHOOT (not needed, but just in case)
- Delete the app
- Turn off bluetooth
- Reboot

# Features
- FTP Access (sandboxed currently, unsandboxed in the future)
- Visual PoC
- PoC by zerodium (Finally slightly imrpoved, can make call to system() function)
- PoC by Abraham, which should be able to run arbitrary code as root, perfect for ssh.

# Planned
- Full exploit including task_for_pid for other daemons
- Remote SSH shell access (dropbear)

# Future things to think about
- SpringBoardd code injection (Hello there jailbreak lovers)
- launchd???

# Hypothesis (just speculation)
- Find daemon with launchd entitlements / inject entitlements
- Inject code that loads BaseBoard Framework
- Use reverse engineered logic from BaseBoard to make launchd run amfid with arguments and aslr disabled, will also give taskport
- patch amfid
- Use reverse engineered logic from BaseBoard to make afcd run with arguments for / and aslr disabled. (afc2 like).
- Use reverse engineered logic from BaseBoard to run unjaild, a daemon that can be used as a wrapper around launchd and handles task priviliges and code injection
- gain a taskport over launchd with aslr disabled using BaseBoard logic



# To examine
- AMFI patches???
- Entitlement injection???
- Escalate further using private API's (BaseBoard.framework can launch processes with ASLR disabled with system rights)???
- revive and port liblorgnette to iOS <span style="color:green;font-weight:bold>(DONE)</span>a


# Download ipa
https://github.com/MTJailed/UnjailMe/releases/tag/0.1

# Credits
- Abraham (@cheesecakeufo) for his securityd zeroday
- Vulnerability and initial PoC: Rani Idan (Zimperium) <3
- PureFTPd
- liblorgnette project (with my own slight improvements)
- NEWUI by @ringarang

# Donate or contribute
- Sourcecode can be given if asked on twitter via DM (@MTJailed)
- Please donate, I have very little time and means to work on such projects! (http://paypal.me/devsupport)
- Soon sourcecode (Except for ftp) will be here on GitHub.


