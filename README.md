# Vagr
## What is Vagr?
It is a pretty badly coded implementation of how the software Vagrant works using **Batch** and **Python**. I made this because my old computer at home ran Vagrant really slowly and it got to the point where it would sometimes freeze my computer. 

NOTE: *The version [here](https://github.com/aaronlam1004/vagr-definitive) is made with just **Python** and (in my opinion) better and the one I am currently using.*
## Requirements
- Windows Operating System
- VirtualBox
- Vagr Compatible OVAs
    -  Can create custom based on [the Vagr OVAs guidelines](https://github.com/aaronlam1004/vagr/blob/master/ovas/vagr_ovas_notes.txt)
    -  Can be downloaded from [the Vagr OVAs downloads](https://mega.nz/#F!fslWECaS!ff9DvPb9DRk7nIcA85ZNLQ)
## Commands
For more information on what commands do, look at [the "official" manual.](https://github.com/aaronlam1004/vagr/blob/master/vagr_manual)
```
Usage:
    vagr [command]
Commands:
    init [ovfname/ovaname] [vmname]
    rename [vmname/uuid] [new name]
    destroy 
    start     
    pause 
    resume    
    down      	
    reload    
    add_shared [name] [host folder path]
    add_port  [rulename] [host ip] [host port] [guest ip] [guest port]
    del_port  [rulename]
    ssh
    putty [-x]
    exec [command] 
    list [--running] [--networks] [--name] [--ports] 
    manual
```
