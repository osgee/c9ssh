# c9ssh

## quick deploy

    $ cd ~
    $ git clone https://github.com/osgee/c9ssh.git
    $ cd c9ssh

on ubuntu

    $ sudo sh deploy_ubuntu.sh

on centos

    $ sudo sh deploy_centos.sh

## preview

###### I come across a idea that if I can remote control the c9 workspace on my laptop. Through several trials, I find a solution to it by using a Dynamic Domain Name Resolving and Port Mapping software called Nat123 to jump over the Google Cloud. The main idea is show as follow:

### step1: 

    create another user account $(USERNAME) in the docker
    
whatever the name, but remember to add it to sudo and root group.
    
### step2: 

    switch to that account, then create a .ssh folder 
    create private and public RSA key for local test.
    
### step3: 

    add RSA public key to ~/.ssh/authorized_keys
    
At present, you can ssh locally if you didn't mess up in previous steps.
    
### step4: 
###### the hard things are:

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

so, this is only a brief concept to solve the problem. The detailed instructions are as follow:

## Detailed Instructions
### step1:
create another user account ('account' for example)

    $ sudo adduser account
    $ sudo usermod account -G root
    $ sudo usermod account -G sudo

### step2:
switch to new account with password('password' for example) and generate ssh rsa key pair

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

    $ sudo apt-get -y update
    
then install mono

    $ sudo apt-get -y install mono-complete
    
check the version of mono

    $ mono -V
    
next install screen

    $ sudo apt-get -y install screen
    
then, download nat123 from http server

    $ cd ~
    $ wget http://www.nat123.com/down/nat123linux.tar.gz

untar the compiled tar file

    $ mkdir ~/nat123
    $ tar -zxvf nat123linux.tar.gz -C ~/nat123

if the file nat123linux.tar.gz can not access, you can directly get the project from <a href="https://github.com/osgee/c9ssh/">c9ssh</a>
	
	$ git clone https://github.com/osgee/c9ssh.git

sign up <a href="http://www.nat123.com/UsersReg.jsp">nat123 sign up</a>
account: $(nat_account)
password: $(nat_password)
run nat service

    $ cd ~/nat123
    $ screen -S nat123
    $ mono nat123linux.sh

sign in with your nat account
push CTRL + a d to set the service run in the background
if you have ever signed in succeed, mono will remeber the account, use command in below instead

    $ mono nat123linux.sh service
    
you can aslo add a script into /etc/init.d, so that nat123 service can run as startup process

### step5:
sign in nat123 website <a href="http://www.nat123.com">nat123</a>
add a Port Mapping

    localhost:22->$(DOMAIN):$(PORT)

### step6:
add SSH public key of your laptop to authorized_keys
in your laptop

    $ cat .ssh/id_rsa.pub

copy the public key text
then in c9 IDE

    $ echo '$LAPTOP_PUBLIC_KEY' >> ~/.ssh/authorized_keys

make sure the file mode as follow

    drwx------ .ssh/
    -rw-r--r-- authorized_keys

or use chomod

    $ sudo chmod 700 ~/.ssh
    $ cd ~/.ssh
    $ sudo chmod 644 authorized_keys
    
### step7:
in your laptop, ssh into c9 workspace

    $ ssh $USERNAME@$DOMAIN -p $PORT

#### wish you can login successfully!

## what you can do with this
1. you can deploy squid3 on cloud9 server, which listen to port 3128 by default, and port mapping to a accessible port. Then use it as a proxy server.
2. this method can aslo applied to other sub-network computers that support mono.







