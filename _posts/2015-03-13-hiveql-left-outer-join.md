---
layout: post
title: HiveQL Tips
---

### Hive では、サイズの大きなテーブルをJOINする。
Hiveは、クエリの最後に出てくるテーブルを最大のテーブルと仮定し、
レコード結合をしながら他のテーブルをバッファした後、最後のテーブルをストリーム化しようとする。

### ■巨大なテーブルをJOINする場合
年月日でPartitionが区切られているtable_largeをJOINする時、
以下のようなクエリだと、JOINが先に評価され、JOIN後にWHERE節が働きます。
{% highlight sql linenos %}
SELECT *
FROM
  table_a AS t_a
LEFT OUTER JOIN
  table_large AS t_l
ON (t_a.feature = t_l.feature)
WHERE
  (t_l.year="2015" AND t_l.month="02" AND t_l.day="28") AND
  t_a.column1="hoge"
{% endhighlight %}

以下のようにサブクエリで書き換えて、データ結合前にWHERE節で絞るのがベター。
{% highlight sql linenos %}
SELECT *
FROM
  table_a AS t_a
LEFT OUTER JOIN (
  SELECT *
  FROM table_large
  WHERE (year="2015" AND month="02" AND day="28")
) AS t_l
ON (t_a.feature = t_l.feature)
WHERE t_a.column1="hoge"
{% endhighlight %}
