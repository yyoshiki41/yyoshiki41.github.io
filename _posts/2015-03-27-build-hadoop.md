---
layout: post
title: Build hadoop on CentOS7
---

### ■各バージョン
- **CentOS 7 x86_64 (2014_09_29) EBS HVM**
- **hadoop-2.6.0**

### ■準備

#### EC2
AMIは今回、CentOS 7 を選択しました。

Instance Type は、m3.large にしましたが、大きいほうが良いです。

#### JDK
Hadoop を動かすにはJavaが必要、JDKはJavaに必要なソフトウェアのセットのこと。

<a href="http://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html" target="_blank">Oracle公式サイト</a>から、バージョンを確認して、rpmでinstallします。

今回はLinux環境なので、**jdk-8u40-linux-x64.rpm**を選んだとします。
{% highlight bash linenos %}
$ rpm -ivh jdk-8u40-linux-x64.rpm
$ java -version
java version "1.8.0_40"
Java(TM) SE Runtime Environment (build 1.8.0_40-b25)
Java HotSpot(TM) 64-Bit Server VM (build 25.40-b25, mixed mode)
{% endhighlight %}
インストール後に、Javaのバージョンを確認してみて、"1.8.***"なら成功です。

またパスを通すために`/etc/profile.d/java.sh`に下記のファイルを作成します。
{% highlight bash linenos %}
#!/bin/bash
export JAVA_HOME=/usr/java/default
export PATH=$JAVA_HOME/bin:$PATH
export CLASSPATH=.:$JAVA_HOME/jre/lib:$JAVA_HOME/lib:$JAVA_HOME/lib/tools.jar
{% endhighlight %}
実行権限を与えて、読み込みさせておけば完了です。
{% highlight bash linenos %}
chmod +x /etc/profile.d/java.sh
source /etc/profile.d/java.sh
{% endhighlight %}

#### maven
apacheが運営しているソフトウェアプロジェクトの管理ツールのこと。

※ mavenを動かすには、javaが必要です。
<a href="http://maven.apache.org/download.cgi" target="_blank">公式サイト</a>から、bin.tar.gzをダウンロードしてきて展開します。
{% highlight bash linenos %}
cd /opt/
tar xzvf apache-maven-3.2.5-bin.tar.gz
{% endhighlight %}
.bach_profileに下記を追記して、読み込みさせておけば完了です。
{% highlight bash linenos %}
export M3_HOME=/opt/apache-maven-3.2.5
M3=$M3_HOME/bin
export PATH=$M3:$PATH
{% endhighlight %}

### ■hadoop

#### 1. hadoop ユーザーを作成
{% highlight bash linenos %}
# useradd hadoop
# passwd hadoop
{% endhighlight %}
hadoop ユーザーで、localhostに入れることを確認します。
{% highlight bash linenos %}
# su - hadoop
$ ssh-keygen -t rsa
$ cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
$ chmod 0600 ~/.ssh/authorized_keys
$ ssh localhost
$ exit
{% endhighlight %}

#### 2. hadoop をダウンロード
<a href="http://www.apache.org/dyn/closer.cgi/hadoop/common/" target="_blank">mirrorサイト</a>から、hadoopのtar.gzファイルをダウンロードしてきて、展開します。
{% highlight bash linenos %}
$ cd ~
$ wget http://apache.claz.org/hadoop/common/hadoop-2.6.0/hadoop-2.6.0.tar.gz
$ tar xzf hadoop-2.6.0.tar.gz
$ mv hadoop-2.6.0 hadoop
{% endhighlight %}

#### 3. 環境変数
.bashrc に下記を追記して読み込ませる。
{% highlight bash linenos %}
export HADOOP_HOME=/home/hadoop/hadoop
export HADOOP_INSTALL=$HADOOP_HOME
export HADOOP_MAPRED_HOME=$HADOOP_HOME
export HADOOP_COMMON_HOME=$HADOOP_HOME
export HADOOP_HDFS_HOME=$HADOOP_HOME
export YARN_HOME=$HADOOP_HOME
export HADOOP_COMMON_LIB_NATIVE_DIR=$HADOOP_HOME/lib/native
export PATH=$PATH:$HADOOP_HOME/sbin:$HADOOP_HOME/bin
{% endhighlight %}

#### 4. hadoop single node cluster の設定ファイル
{% highlight bash linenos %}
cd $HADOOP_HOME/etc/hadoop
{% endhighlight %}

下記のファイル群を編集する。

{% highlight xml linenos %}
$ vim core-site.xml
<configuration>
<property>
  <name>fs.default.name</name>
    <value>hdfs://localhost:9000</value>
</property>
</configuration>
[/shell]
[shell title="hdfs-site.xml"]
<configuration>
<property>
 <name>dfs.replication</name>
 <value>1</value>
</property>

<property>
  <name>dfs.name.dir</name>
    <value>file:///home/hadoop/hadoopdata/hdfs/namenode</value>
</property>

<property>
  <name>dfs.data.dir</name>
    <value>file:///home/hadoop/hadoopdata/hdfs/datanode</value>
</property>
</configuration>
{% endhighlight %}

{% highlight xml linenos %}
$ vim mapred-site.xml
<configuration>
 <property>
  <name>mapreduce.framework.name</name>
   <value>yarn</value>
 </property>
</configuration>
{% endhighlight %}

{% highlight xml linenos %}
$ vim yarn-site.xml
<configuration>
 <property>
  <name>yarn.nodemanager.aux-services</name>
    <value>mapreduce_shuffle</value>
 </property>
</configuration>
{% endhighlight %}

#### 4. hadoop cluster を起動
※初回起動時は、HDFSデーモンを起動する前にファイルシステムのフォーマットが必要。
{% highlight bash linenos %}
$ hdfs namenode -format
{% endhighlight %}

ここから起動に入ります。
{% highlight bash linenos %}
$ cd $HADOOP_HOME/sbin/
$ start-dfs.sh
$ start-yarn.sh
{% endhighlight %}

#### 5. Browser で確認
Portを指定してアクセスすることで、Hadoopの各サービスをブラウザから見れます。
<table>
<thead>
<tr>
<th>Information</th>
<th>Port</th>
</tr>
</thead>
<tbody>
<tr>
<td>NameNode</td>
<td>50070</td>
</tr>
<tr>
<td>All Applications</td>
<td>8088</td>
</tr>
<tr>
<td>Secondary NameNode</td>
<td>50090</td>
</tr>
<tr>
<td>DataNode</td>
<td>50075</td>
</tr>
</tbody>
</table>

#### 6. Test
HDFSにディレクトリを作成。
{% highlight bash linenos %}
$ bin/hdfs dfs -mkdir /user
$ bin/hdfs dfs -mkdir /user/hadoop
{% endhighlight %}
適当なファイルをコピーして、ブラウザから確認してみる。
http://********:50070/explorer.html#/user/hadoop

{% highlight bash linenos %}
$ bin/hdfs dfs -put /var/log/httpd logs
{% endhighlight %}

π を求めるサンプルプログラムを動かしてみる。
{% highlight bash linenos %}
$ hadoop jar ~/hadoop/share/hadoop/mapreduce/hadoop-mapreduce-examples-2.6.0.jar pi 10 10000
……
Job Finished in 48.932 seconds
Estimated value of Pi is 3.14120000000000000000
{% endhighlight %}
無事動いてることが確認出来ました！

#### 7. Stop
以下のシェルスクリプトで終了させる。
jpsコマンドで確認する。
{% highlight bash linenos %}
$ $HADOOP_HOME/sbin/stop-all.sh
$ jps
4824 Jps
{% endhighlight %}

### ■参考サイト
- <a href="http://www.unixmen.com/install-oracle-java-jdk-8-centos-76-56-4/" target="_blank">JDK</a>
- <a href="http://tecadmin.net/setup-hadoop-2-4-single-node-cluster-on-linux/" target="_blank">hadoop</a>
