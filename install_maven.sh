#
# Install Maven
#
echo -e "\n#### Installing Maven"
cd /tmp
wget -N http://apache.cs.utah.edu/maven/maven-3/3.5.0/binaries/apache-maven-3.5.0-bin.tar.gz
tar -xzvf apache-maven-3.5.0-bin.tar.gz -C /usr/local/bin
export M2_HOME=/usr/local/bin/apache-maven-3.5.0/
export M2=$M2_HOME/bin
export JAVA_HOME=$JAVA_HOME
export PATH=$PATH:$M2:$JAVA_HOME/bin
echo "export PATH=$PATH:$M2:$JAVA_HOME/bin" >>/etc/profile
. /etc/profile
mvn --version
