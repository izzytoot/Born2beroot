# Born2beroot Tutorial - Virtual Machine Setup

## 0. Introduction

This is a basic tutorial for setting up the Virtual Machine requested by the 42 project Born2beroot (nov 2024). For further information on concepts and reasons for these instructions check Gemartin99's tutorial: https://github.com/gemartin99/Born2beroot-Tutorial .

## 1. Choose and download Operating System to be used (Debian or Rocky)

1.1. For Debian: https://www.debian.org/download.en.html

## 2. Download Virutal Box and basic setup

2.1. Download Virtual Box: https://www.virtualbox.org/

2.2. Click on Add (+) and choose the folder where you want to install your VM (sgoinfre);

2.3. Choose a name (it can be any name) and the OS you want to use (Debian (64-bit));

2.4. Set base memory to 1024mb;

2.5. Set disk size to 8Gb and finish;

2.6. Open settings -> Storage -> Empty -> Optical Device -> Choose Debian OS from your downloads.

## 3. Install Debian

3.1. `Install`;

3.2. Language -> `English`;

3.3. Country -> `other - Europe - Portugal`;

3.4. `United States of America`;

3.5. Keymap -> `American English`;

3.6. Hostname -> your 42 username followed by 42 *(in my case `icunha-t42`)*;

3.7. Domain Name -> `                 ` *leave it blank*;

3.8. Root password (2x) -> choose a password to use as root PW following pasword rule policy (check subject)

3.9. New user -> your 42 login *(in my case `icunha-t`)*;

3.10. User password (2x) -> choose a password to use as user PW following pasword rule policy (check subject)

3.11. Timezone -> `Lisbon`;

3.12. Partition disks:
\
Choose encrypted LVM -> `Guied - use entire disk and set up encrypted LVM`. *If you want to do the bonus select Manual and check this tutorial: ([url](https://github.com/gemartin99/Born2beroot-Tutorial/blob/6e9ad550add6e0e7723b7570b5c5df8d047653a0/README_EN.md#8--bonus-%EF%B8%8F)).*
\
Choose disk -> there's only 1 option;
\
Choose partitioning scheeme -> `Separate/home partition`;
\
Choose `yes`;
    
3.13. Erasing data -> `cancel`;

3.14. Password encryption -> choose a password to use at the machine startup following pasword rule policy (check subject);

3.15. Amount of volume group -> `8.1Gb` *(leave what's there)*;

3.16. Finish -> `Finish partitioning and write changes to disk`;

3.17. Write changes -> `yes`;

3.18. Package Manager:
\
3.18.1. Country -> `Portugal`;
\
3.19.2. Archive mirror -> `deb.debian.org`;
\
3.19.3. Http proxy -> leave blank;

3.20. Popularity contest -> `no`;

3.21. Software selection -> unselect what's there and leave none;

3.22. GRUB boot loader -> `yes`; `dev/sda`; `continue`;

## 4. Virtual Machine Setup

### 4.1. SUDO, GROUPS & USER

4.1.1. Select `Debian GNU/Linux`;

4.1.2. Introduce the encryptation password previously created;

4.1.3. Introduce the username and password previously created;

4.1.4. Change user to root-> run `su` and introduce root password previously created;

4.1.5. Install packages for sudo -> run `apt install sudo`;

4.1.6. Reboot machine to apply changes -> run `sudo reboot`;

4.1.7. Login with username and password and check if sudo is installed -> run `sudo -V`;

4.1.8. Add user (in case it hasn't been previously created) -> run `sudo adduser username`;

4.1.9. Create new group called user42 -> run `sudo addgroup user42`;

4.1.10. Check group and user -> run `getent group user42`;

4.1.11. Include user in group sudo and user42:
\
run `sudo adduser username user42`;
\
run `sudo adduser username sudo`;

### 4.2. SSH - SECURE SHELL

4.2.1. Update the system -> run `sudo apt update`

4.2.2. Install OpenSSH package -> run `sudo apt install Openssh-server` followed by `y`;

4.2.3. Install vim -> run `sudo apt install vim` followed by `y`;

4.2.4. Edit ssh_config file:
\
open file -> run `vim /etc/ssh/ssh_config`;
\
substitute `Port 22` for `Port 4242`;
\
substitute `PermitRootLogin prohibit-password` for `PermitRootLogin no`;

### 4.3. UFW FIREWALL

4.3.1. Install UFW packages: run `sudo apt install ufw` followed by `y`;

4.3.2. Start UFW firewall -> run `sudo ufw enable`;

4.3.3. Allow firewall to accept port 4242 connections -> run `sudo ufw allow 4242`;

4.3.4. Check UFW status -> run `sudo ufw status`;

### 4.4. SUDO POLICIES

4.4.1. Create file to store sudo policy -> run `vim /etc/sudoers.d/sudo_config`;

4.4.2. Create  directory in var/log -> run `mkdir /var/log/sudo`;

4.4.3. Edit sudo_config and add policy:
\
open file: ru `vim /etc/sudoers.d/sudo_config`;
\
Insert policy configurations:
\
`Defaults passwd_tries=3` -> limit of pw tries;
\
`Defaults badpass_message="Error"` -> Error message for wrong PW;
\
`Defaults logfile="/var/log/sudo/sudo_config"` -> File to keep sudo logs;
\
`Defaults log_input, log_output` -> register every input (command) and output (result);
\
`Defaults iolog_dir="/var/log/sudo"` -> Directory to keep sudo logs;
\
`Defaults requiretty` -> Requires TTY (terminal) usage;
\
`Defaults secure_path="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/snap/bin"` -> Restricts sudo usage to these directories.

### 4.5. STRONG PASSWORD POLICY

4.5.1. Open login.defs file -> run `vim /etc/login.defs`

4.5.2. Set password days policy P1:
\
Substitute `PASS_MAX_DAYS 99999` for `PASS_MAX_DAYS 30` (change PW every 30 days);
\
Substitute `PASS_MIN_DAYS 0` for `PASS_MIN_DAYS 2` (minimum PW chage interval);
\
Substitute `PASS_WARN_AGE 0` for `PASS_WARN_AGE 7` (warning before changing PW);

4.5.3. Install quality PW package: run `sudo apt install libpam-pquality` followed by `y`;

4.5.4. Open password file -> run `vim /pam.d/common-password`;

4.5.5. Set password days policy P2:
\
`minlen=10` (minimum length of 10 characters);
\
`ucredit=-1` (at least 1 uppercase letter);
\
`dcredit=-1` (at least 1 lowercase letter);
\
`lcredit=-1` (at least 1 digit);
\
`maxrepeat=3` (cannot have the same char 3 times in a row);
\
`reject_username` (cannot contain username);
\
`difok=7` (at least 7 different characters of last PW);
\
`enforce_for_root` (inforce policy in root);

4.5.6. Change time setting of days for root as well:
\ 
run `sudo chage -m 2 root`;
run `sudo chage -M 30 root`;
run `sudo chage -m 2 root`;
run `sudo chage -M 30 root`;

### 4.6. CONNECT TO VIRTUAL MACHINE FROM REAL MACHINE

4.6.1. In Virtual Box: `settings` -> `Network` -> `Advanced` -> Change `NAT` to `Bridged Adapter` and save;

4.6.2. Find Virtual Machine IP -> run `hostname -I` 

*Keep VM running*

4.6.3. In your Real Machine terminal -> run `ssh username@ip.number -p 4242` followed by `yes` and the user password;

*To leave VM use ctrl+D*

### 4.7 SCRIPT

4.7.1. Create script file in username directory -> run `vim monitoring.sh`;

4.7.2. This script (https://github.com/izzytoot/Born2beroot/blob/main/monitoring.sh) commands the display of a set of information about our VM (check the subject).

4.7.3. Check Gemartin99's section about the script. It contains detailed information about each macro: https://github.com/gemartin99/Born2beroot-Tutorial/blob/main/README_EN.md#5--script-

### 4.8. CRON

4.8.1. Open crontab -> run `sudo crontab -u root -e`

4.8.2. Add `*/10 * * * * sh /home/icunha-t/monitoring`

### 4.9. SIGNATURE FILE TO SUBMIT

4.9.1. In your computer, go to the directory where the VM is stored (sgoinfre) and open terminal to find out the number of the VM -> run `shasum Born2beroot.vdi`

4.9.2. Copy the number and paste it on a .txt file;

4.9.3. Submit this file to the Intra project repository.
