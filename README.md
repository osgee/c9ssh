# c9ssh
## preview

###### I come across a idea that if I can remote control the c9 workspace on my laptop. Through several trials, I find a solution to it by using a Dynamic Domain Name Resolving and Port Mapping software called Nat123 to jump over the Google Firewall. The main idea is show as follow:

### step1: 

    create another user account $(USERNAME) in the docker
    
whatever the name, but remember to add it to sudo and root group.
    
### step2: 

    switch to that account, then create a .ssh folder 
    create private and public RSA key for local test.
    
### step3: 

    add RSA public key to ~/.ssh/authorized_keys. 
    
At present, you can ssh locally if you didn't mess up in previous steps.
    
### step4: 
###### the hard thing is :

###### 1. Ip of the docker changes constantly
###### 2. Docker is in a subnetwork
###### 3. Google only open limited port for users

so we can install a software which can update the domain name's A record dynamically(binding docker's IP to a specific domain name automatically and constantly ). There is a proper software, which can do this work. However, this software's webpage only in Chinese. But it is sure that you can find an alternate one, or you can follow the detailed instructions in below.

### step5:

    port mapping: localhost:22->$(DOMAIN):$(PORT) 

### step6:

    add SSH public key of your laptop to authorized_keys

### step7: 

    ssh $(USERNAME)@$(DOMAIN) -p $(PORT)

so,this is only a brief instruction to solve the problem.

## Detailed Instructions
### step1:
create another user account ('account' for example)

    $ sudo adduser account
    $ sudo adduser account root
    $ sudo adduser account sudo

### step2:
switch to new account with password('password' for example)

    $ su account
    $ mkdir ~/.ssh
    $ ssh-keygen -t rsa -b 2048 -P '' -f ~/.ssh/id_rsa
    
### step3:

    $ cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
    
try to ssh into account

    $ ssh account@localhost

if succeed, match forward

### step4:
install nat123
fist update apt-get repository

    $ sudo apt-get update
    
then install mono

    $ sudo apt-get install mono
    
check the version of mono

    $ mono -V
    
next install screen

    $ sudo apt-get install screen
    
then, download nat123 from http server

    $ cd ~
    $ wget http://www.nat123.com/down/nat123linux.tar.gz

if the file nat123linux.tar.gz can not work, you can get the package from c9ssh github

untar the compiled tar file

    $ mkdir ~/nat123
    $ tar -zxvf nat123linux.tar.gz -C ~/nat123
    
sign up <a href="http://www.nat123.com/UsersReg.jsp">nat123 sign up</a>
account: $(nat_account)
password: $(nat_password)
run nat service

    $ cd ~/nat123
    $ screen -S nat123
    $ mono nat123linux.sh

sign in with your nat account
push CTRL + a d to set the service run in the background
if you have sign in succeed, mono will remeber the account, use command in below instead

    $ mono nat123linux.sh service
    
you can aslo add a script into /etc/init.d, so that nat123 service can run as startup 

### step5:
sign in nat123 website <a href="http://www.nat123.com">nat123</a>
add a Port Mapping

    localhost:22->$(DOMAIN):$(PORT)

### step6:
add SSH public key of your laptop to authorized_keys
in your laptop

    $ cat .ssh/id_rsa.puby

copy the public key text
then in c9 IDE

    $ echo '$LAPTOP_PUBLIC_KEY' >> ~/.ssh/authorized_keys

### step7:
in your laptop, ssh into c9 workspace

    $ ssh $USERNAME@$DOMAIN -p $PORT

#### wish you can login successfully!







