---
layout: post
title: Build Hive
---

hadoop のビルドについては、<a href="./../build-hadoop/" target="_blank">こちら</a>を参考に！

### ■各バージョン
- **CentOS 7 x86_64 (2014_09_29) EBS HVM**
- **hadoop-2.6.0**
- **maven-3.2.5**
- **hive-1.1.0**

### ■**Hive**
基本は、<a href="https://cwiki.apache.org/confluence/display/Hive/GettingStarted" target="_blank">公式サイト</a>を参考に、進めていきます。

途中で、エラー出たりしたので、そこら辺もメモしておきます。

#### 1. SVN repository から、コンパイル

{% highlight bash linenos %}
$ svn co http://svn.apache.org/repos/asf/hive/trunk hive
$ cd hive
$ mvn clean install -Phadoop-2,dist
{% endhighlight %}

と公式通りにやると、ここでエラー発生。。

mvn実行時に、オプションを付けてやることで、無事成功した。

{% highlight bash linenos %}
# Before
# mvn clean install -Phadoop-2,dist
# After
$ mvn clean install -DskipTests -Phadoop-2,dist
{% endhighlight %}

以降の{version}は、インストールされたもの(lsとかで確認して)に置き換えてください。

{% highlight bash linenos %}
$ cd packaging/target/apache-hive-{version}-SNAPSHOT-bin/apache-hive-{version}-SNAPSHOT-bin
{% endhighlight %}

### 2. パスを通す
bashrc に HIVE_HOME を指定して置きます。

{version} や homeディレクトリから hive までのパスは、適宜置き換えてください。

{% highlight bash linenos %}
export HIVE_HOME=/home/hadoop/hive/packaging/target/apache-hive-{version}-SNAPSHOT-bin/apache-hive-{version}-SNAPSHOT-bin
{% endhighlight %}

### 3. ディレクトリ作成
以下を実行して、ファイルを保存するディレクトリを作成しておきます。

{% highlight bash linenos %}
$ $HADOOP_HOME/bin/hadoop fs -mkdir       /tmp
$ $HADOOP_HOME/bin/hadoop fs -mkdir       /user/hive/warehouse
$ $HADOOP_HOME/bin/hadoop fs -chmod g+w   /tmp
$ $HADOOP_HOME/bin/hadoop fs -chmod g+w   /user/hive/warehouse
{% endhighlight %}

### 4. Hive 起動
以下のコマンドで、hadoop, YARN を起動させます。
{% highlight bash linenos %}
$ start-dfs.sh
$ start-yarn.sh
{% endhighlight %}

いよいよ Hive を起動させます。

がいきなりこんなエラーが出て、出鼻を挫かれます。。
{% highlight bash linenos %}
$ $HIVE_HOME/bin/hive
Logging initialized using configuration in jar:file:/home/hadoop/hive/packaging/target/apache-hive-1.2.0-SNAPSHOT-bin/apache-hive-1.2.0-SNAPSHOT-bin/lib/hive-common-1.2.0-SNAPSHOT.jar!/hive-log4j.properties
[ERROR] Terminal initialization failed; falling back to unsupported
java.lang.IncompatibleClassChangeError: Found class jline.Terminal, but interface was expected
	at jline.TerminalFactory.create(TerminalFactory.java:101)
	at jline.TerminalFactory.get(TerminalFactory.java:158)
	at jline.console.ConsoleReader.<init>(ConsoleReader.java:229)
	at jline.console.ConsoleReader.<init>(ConsoleReader.java:221)
	at jline.console.ConsoleReader.<init>(ConsoleReader.java:209)
	at org.apache.hadoop.hive.cli.CliDriver.getConsoleReader(CliDriver.java:773)
	at org.apache.hadoop.hive.cli.CliDriver.executeDriver(CliDriver.java:715)
	at org.apache.hadoop.hive.cli.CliDriver.run(CliDriver.java:675)
	at org.apache.hadoop.hive.cli.CliDriver.main(CliDriver.java:615)
	at sun.reflect.NativeMethodAccessorImpl.invoke0(Native Method)
	at sun.reflect.NativeMethodAccessorImpl.invoke(NativeMethodAccessorImpl.java:62)
	at sun.reflect.DelegatingMethodAccessorImpl.invoke(DelegatingMethodAccessorImpl.java:43)
	at java.lang.reflect.Method.invoke(Method.java:497)
	at org.apache.hadoop.util.RunJar.run(RunJar.java:221)
	at org.apache.hadoop.util.RunJar.main(RunJar.java:136)
Exception in thread "main" java.lang.IncompatibleClassChangeError: Found class jline.Terminal, but interface was expected
	at jline.console.ConsoleReader.<init>(ConsoleReader.java:230)
	at jline.console.ConsoleReader.<init>(ConsoleReader.java:221)
	at jline.console.ConsoleReader.<init>(ConsoleReader.java:209)
	at org.apache.hadoop.hive.cli.CliDriver.getConsoleReader(CliDriver.java:773)
	at org.apache.hadoop.hive.cli.CliDriver.executeDriver(CliDriver.java:715)
	at org.apache.hadoop.hive.cli.CliDriver.run(CliDriver.java:675)
	at org.apache.hadoop.hive.cli.CliDriver.main(CliDriver.java:615)
	at sun.reflect.NativeMethodAccessorImpl.invoke0(Native Method)
	at sun.reflect.NativeMethodAccessorImpl.invoke(NativeMethodAccessorImpl.java:62)
	at sun.reflect.DelegatingMethodAccessorImpl.invoke(DelegatingMethodAccessorImpl.java:43)
	at java.lang.reflect.Method.invoke(Method.java:497)
	at org.apache.hadoop.util.RunJar.run(RunJar.java:221)
	at org.apache.hadoop.util.RunJar.main(RunJar.java:136)
{% endhighlight %}
調べてみると、Spark の部分に<a href="https://cwiki.apache.org/confluence/display/Hive/Hive+on+Spark%3A+Getting+Started#HiveonSpark:GettingStarted-CommonIssues(Greenareresolved,willberemovedfromthislist)" target="_blank">Issueと対処法</a>が上がってました。

hadoop があるディレクトリにあるjarファイルを消すか、バックアップ取って動かすかします。
{% highlight bash linenos %}
$ mv ~/home/hadoop/share/hadoop/yarn/lib/jline-0.9.94.jar ~/home/hadoop/share/hadoop/yarn/lib/jline-0.9.94.jar.bk
{% endhighlight %}

もう一度実行すると、無事起動しました。
{% highlight bash linenos %}
$ $HIVE_HOME/bin/hive
{% endhighlight %}
これで、SQLライクに書きながら、ガンガンビッグなデータを扱えます！！
