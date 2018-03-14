# UnjailMe
A sandbox escape based on:

- the proof-of-concept (CVE-2018-4087) by Rani Idan (Zimperium)
- @cheesecakeufo's securityd overflow proof-of-concept (zeroday, no CVE known, thank you Abraham!)

# About the ZIMPERIUM PoC
Rani used sbtool from Jonathan Levine to find out what services were accessible for communication from within the sandbox.

He then found under more bluetoothd and set up code for intercepting messages from and to the service.

By doing so he found out he could hijack the session of many daemons and could leak the client port.

This way he found it was possible to add a callback with additional data to the client's connection to bluetoothd.

As a result we can gain control over the process counter (callback) and register x3 (additional data) of all the deamons we have a session for.

Making it possible to escalate to their context, escaping the sandbox.

<img src="https://github.com/MTJailed/UnjailMe/blob/master/session_hijacking.png?raw=true" height="300">
<i>Source: Zimperium Blog</i>

# Requirements
- Any device running iOS 10 to <s>11.2.5</s> 11.3 (bluetoothd is partially patched in 11.2.5, securityd isn't)

# What is this
- This is NOT a jailbreak
- The project has as goal to escalate privilige so code can be ran outside the sandbox with system rights.
- This does not give you the ability to write to the rootfilesystem, as for such you need kernel priviliges.
- Do not expect proper code injection (like houdini), currently no code execution is possible until a ropchain is written.
- This project is meant for developers and researchers, and contains useful code for further userland projects.
- Why is this even a thing? If code injection works jailbreak developers can start development for 11.2 to <s>11.2.5</s> 11.3.

# Screenshot
<img src="https://github.com/MTJailed/UnjailMe/blob/master/b.png?raw=true" height="300"/>

# How to use the app
- Run the app
- Turn on bluetooth
- Click escape sandbox
- Wait until it completes. This can take around 10 minutes.
- In the output you should see FTP credentials that you can use to transfer files.
- Use FileZilla to connect to your iphone and browse files.
- For convenience the path to the appcontainer is shown as the FTP server runs currently inside the sandbox.
- The FTP server has currently nothing to do with the exploit, it was written and compiled by me to be a part of MTJailed.
- The FTP server is based on pureftpd.
- The FTP server can eventually be used to transfer files for code injection, download logs, apticket etcetera.
- <s>Sometimes the exploit also gains a session for SpringBoard so turning bluetooth off again might cause a respring.</s>


# TROUBLESHOOT (not needed, but just in case)
- Delete the app
- Turn off bluetooth
- Reboot

# Features
- FTP Access (sandboxed currently, unsandboxed in the future)
- Visual PoC
- PoC by zerodium (Finally slightly imrpoved, can make call to system() function)
- PoC by Abraham, which should be able to run arbitrary code as root, perfect for ssh.
- PoC by Sem Voigtlander (Kernel address space allocation DoS, for reboot device function).

# Planned
- Full exploit including task_for_pid for other daemons.
- Remote SSH shell access (dropbear).

# Future things to think about
- SpringBoardd code injection (Hello there jailbreak lovers)
- <s>launchd</s> (Not possible as we cannot gain a session for it).


# Hypothesis (just speculation)
- Find daemon with launchd entitlements / inject entitlements.
- <s>Inject code that loads BaseBoard Framework</s>
- Leak addresses of libraries in the dyld_shared_cache.
- Find a ropgadget in any library in the dyld_shared_cache.
- Call the ropchain by setting the callback and the callback additional data.
- Use reverse engineered logic from BaseBoard to make launchd run amfid with arguments and aslr disabled.
- patch amfid
- Use reverse engineered logic from BaseBoard to make afcd run with arguments for / and aslr disabled. (afc2 like).
- Use reverse engineered logic from BaseBoard to run unjaild, a daemon that can be used as a wrapper around launchd and handles task priviliges and code injection
- gain a taskport over launchd with aslr disabled using BaseBoard logic



# To examine
- AMFI patches (Not easy, we cannot gain sessions over amfi, but we can escalate using other daemons perhaps).
- Entitlement injection (Not quite necessary, we have control over so many daemons that we don't need this).
- Escalate further using private API's (BaseBoard.framework can launch processes with ASLR disabled with system rights)???
- revive and port liblorgnette to iOS <span style="color:green;font-weight:bold">(DONE)</span>

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


