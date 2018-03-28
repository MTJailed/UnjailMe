# UnjailMe
A sandbox escape based on:

- the proof-of-concept (CVE-2018-4087) by Rani Idan (Zimperium)
- @cheesecakeufo's securityd overflow proof-of-concept (zeroday, no CVE known, thank you Abraham!)

# About the ZIMPERIUM PoC
Rani used sbtool from Jonathan Levine to find out what services were accessible for communication from within the sandbox.

He then found under more bluetoothd and set up code for intercepting messages from and to the service.

By doing so he found out he could hijack the session of many daemons and could leak the client port.

This way he found it was possible to add a callback with additional data to the client's connection to bluetoothd.

The consequence of this is that control can be gained over the process counter (callback) and register x3 (additional data) of system deamons from which a client port (session) is intercepted.

Providing the possibility to escape a sandbox app into a priviliged context making it run code with system privileges.

Apple has patched the vulnerabilities in iOS 11.2.5 using an arc4random() for the session id.

It seems not to be possible to gain a client's port anymore but intercepting sessions still is.

It takes aproximately 15 minutes to bruteforce this arc4random() (2^32 possibilities) and therefore I am still looking forward to a final patch.

<img src="https://github.com/MTJailed/UnjailMe/blob/master/session_hijacking.png?raw=true" height="300">
<i>Source: Zimperium Blog</i>

# About Abraham Masri's Poc
As far as I know this is a bufferoverflow in the communication with securityd.

This is done by providing an XPC message, which is a dictionary based value-key message, with an invalid length.

The service receives the message and the underflow occurs.

Abraham seems to have found a way to control many processor registers making code execution with system rights possible for apps running inside the system.

Abraham's PoC shows that Abraham is trying to create an exploit for this vulnerability himself, as code exists for leaking base addresses which is known as the begin of the creation of a ROP-chain.

It is unknown if Abraham is planning to write this exploit himself or pointing us in the right direction.

# Requirements
- A 64-bit iOS device running iOS 10 up to 11.3.1

# About this project
- This project is not a jailbreak nor will contribute to one as this will only operate in userland
- This project can not and never will gain the ability to write to the rootfilesystem as this is mounted as readonly as enforced by the kernel.
- This project will not easily allow arbitrary code execution in the form of dynamic libraries like cydia substrate does.
- The project has as main goal to escallate an sandboxed container app to system rights.
- AMFI enforces that all binaries are validly signed and this project cannot patch AMFI.
- The project aims to gain read and write permission to the userdata partition (/var/root, /var/mobile).
- The project aims to gain access to the protected key chain storage for credential recovery and forensic purposes.
- The project also aims to provide server functionality for running code as root and file transfer.
- The project was intended to be a help for developers and researchers for contribution.
- The project will make it easier for jailbreak developers and security researchers to find bugs in kernel drivers that are only accessible from within a privilige context or userland bugs using fuzzing techniques.
- The project will make it easier for jailbreak tweak developers to research the new iOS 11 features and debug tweak development on a live device.
- This project has the main focus to work for iOS 10 up to 11.2.5 but can in theory support 11.2.5 up to including 11.3 as well when exploits are developed.


# Screenshot
<img src="https://github.com/MTJailed/UnjailMe/blob/master/b.png?raw=true" height="300"/>

# How to use the app
- The app does not add any value to the project but serves as a visual to those asking for it (A lot of hyped-up people from the community asked for this)
- The app will dump information from libraries and frameworks including memory, mach-o information and it's base addresses which is useful for ROP-development.
- The logic in the app can take up to 15 minutes to complete due to the many parsing and prints, this will not be the case in final releases.
- The app will not add any value to your iphone or change the behaviour of the software as it is, some daemons may crash but no permanent damage is done to the system.
- It is recommended for researchers to run this project in Xcode instead


# TROUBLESHOOT (not needed, but just in case)
- Delete the app
- Turn off bluetooth
- Reboot
- Turn on bluetooth
- Turn off bluetooth

# Features
- FTP Access (sandboxed currently, unsandboxed in the future)
- Visual PoC
- PoC by zerodium (Finally slightly imrpoved, can make call to system() function)
- PoC by Abraham, which should be able to run arbitrary code as root, perfect for ssh.
- PoC by Sem Voigtlander (Kernel address space allocation DoS, for reboot device function).

# Planned
- Full exploit including gaining full control over other daemons their address space.
- Remote SSH shell access (dropbear or a derative).

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


