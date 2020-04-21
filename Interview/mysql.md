## 目录
- [存储引擎](#存储引擎)
    - [MyISAM](#MyISAM)
    - [InnoDB](#InnoDB)
    - [InnoDB和MyISAM区别](#InnoDB和MyISAM区别)
- [索引](#索引)
    - [哈希索引](#哈希索引)
    - [BTree索引](#BTree索引)
    - [适合创建索引的情况](#适合创建索引的情况)
    - [索引的操作](#索引的操作)
- [事务](#事务)
    - [事务的四个特性ACID](#事务的四个特性ACID)
    - [并发事务带来哪些问题](#并发事务带来哪些问题)
    - [事务的四种隔离级别](#事务的四种隔离级别)
    - [锁机制与InnoDB锁算法](#锁机制与InnoDB锁算法)
    - [表级锁和行级锁的对比](#表级锁和行级锁的对比)
- [数据库优化](#数据库优化)
    - [读写分离](#读写分离)
        - [主从同步延迟](#主从同步延迟)
        - [分配机制](#分配机制)
        - [读写分离小结](#读写分离小结)
    - [分库分表](#读写分离)
        - [垂直分区](#垂直分区)
        - [水平分区](#水平分区)
        - [数据库分片的两种常见方案](#数据库分片的两种常见方案)
        - [水平分区小结](#水平分区小结)
    - [字段](#字段)
    - [索引](#索引)
    - [查询SQL](#查询SQL)
    - [缓存](#缓存)

## 存储引擎
### MyISAM
5.5版之前MyISAM是MySQL的默认数据库引擎。虽然查询性能极佳，而且提供了大量的特性，包括全文索引、压缩、空间函数等，但MyISAM不支持事务和行级锁，而且最大的缺陷就是不能在表损坏后恢复数据。MyISAM管理的数据文件frm(表格式),MYD(数据),MYI(索引)

### InnoDB
5.5版本后默认的存储引擎为InnoDB，支持事务；锁机制改进，支持行级锁；实现外键，InnoDB存储引擎管理的数据文件分别为frm(表格式),idb(数据+索引)  

可以数据多引擎读取，因为存储引擎建立在表之上，所以可以使用InnoDB类型和MyISAM类型的多表查询
大多数时候我们使用的都是 InnoDB 存储引擎，但是在某些情况下使用 MyISAM 也是合适的比如读密集的情况下。

### InnoDB和MyISAM区别
- **是否支持事务：** InnoDB支持事务，MyISAM不支持事务，对于InnoDB每一条SQL语句都默认封装成事务，自动提交，所以最好把多条SQL语句放在begin transaction 和commit之间组成一个事务
- **是否支持行级锁：** MyISAM只支持表级锁，而InnoDB支持行级锁和表级锁，默认行级锁
- **是否支持外键:** InnoDB支持外键，而MyISAM不支持，对于一个包含外键的InnoDB表转为MyISAM会失败
- **是否支持崩溃后的安全恢复：**  MyISAM 强调的是性能，每次查询具有原子性,其执行速度比InnoDB类型更快，但是不提供崩溃后的安全恢复支持。但是InnoDB 提供事务支持。 具有事务(commit)、回滚(rollback)和崩溃修复能力(crash recovery capabilities)的事务安全(transaction-safe (ACID compliant))型表。
- 索引实现方式的区别： InnnoDB是聚簇索引，数据文件和索引绑在一起，必须要有主键，通过主键索引效率很高，但是辅助索引需要两次查询，先查主键，再通过主键查询到数据，主键建议不要太大，而MyISAM是非聚簇索引，数据和文件分离的，索引保存的是数据文件的地址
- 在统计表行数的区别： InnoDB不保存表的具体行数，执行select count(*) from table时进行全表扫描，而MyISAM通过变量来保持表行数，执行上述语句只需要读取该变量即可

## 索引
MySQL索引使用的数据结构主要有BTree索引和哈希索引。
### 哈希索引
底层的数据结构就是哈希表，因此在绝大多数需求为单条记录查询的时候，可以选择哈希索引，查询性能最快；其余大部分场景，建议选择BTree索引。

### BTree索引
不同的存储引擎的实现方式不同：
- **MyISAM:** B+Tree叶节点的data域存放的是数据记录的地址。在索引检索的时候，首先按照B+Tree搜索算法搜索索引，如果指定的Key存在，则取出其 data 域的值，然后以 data 域的值为地址读取相应的数据记录。这被称为非聚簇索引
- **InnoDB:** 其数据文件本身就是索引文件。相比MyISAM，索引文件和数据文件是分离的，其表数据文件本身就是按B+Tree组织的一个索引结构，树的叶节点data域保存了完整的数据记录。这个索引的key是数据表的主键，因此InnoDB表数据文件本身就是主索引。这被称为“聚簇索引（或聚集索引）”。而其余的索引都作为辅助索引，辅助索引的data域存储相应记录主键的值而不是地址，这也是和MyISAM不同的地方。在根据主索引搜索时，直接找到key所在的节点即可取出数据；在根据辅助索引查找时，则需要先取出主键的值，再走一遍主索引。 因此，在设计表的时候，不建议使用过长的字段作为主键，也不建议使用非单调的字段作为主键，这样会造成主索引频繁分裂

### 适合创建索引的情况
- 搜索的列上,可以加快搜索的速度
- 在作为主键的列上,强制该列的唯一性和组织表中数据的排列结构
- 用在连接的列上,这些列主要是一些外键,可以加快连接的速度
- 根据范围进行搜索的列上创建索引,因为索引已经排序,其指定的范围是连续的
- 排序的列上创建索引,因为索引已经排序,这样查询可以利用索引的排序,加快排序查询时间
- 使用在WHERE子句中的列上面创建索引,加快条件的判断速度。建立索引,一般按照select的where条件来建立,比如: select的条件是where f1 and f2,那么如果我们在字段1或字段2上建立索引是没有用的,只有在字段1和2上同时建立索引才有用等。

### 索引的操作
创建索引  
CREATE INDEX index_name ON table_name(column(length))  
查看索引  
SHOW IDNEX FROM table_name  
删除索引  
DROP INDEX index_name ON table_name  


## 事务
### 事务的四个特性ACID
### 并发事务带来哪些问题
### 事务的四种隔离级别

## 锁机制与InnoDB锁算法
MyISAM采用表级锁
InnoDB采用行级锁和表级锁，默认行级锁

### 表级锁和行级锁的对比：
- 表级锁：MySQL中锁定粒度最大的一种锁，对当前操作的整张表枷锁，实现简单，加锁快，不会出现死锁，但汽车锁定粒度最大，触发锁冲突的概率最高，并发度最低
- 行级锁：MySQL中锁定粒度最小的一种锁，只针对当前操作行进行枷锁，行级锁大大减少数据库操作的冲突，其加锁粒度最小，并发度高，所以资源消耗也大，加锁慢，会出现死锁

### InnoDB存储引擎的算法有三种
- Record lock ：单个行记录上的锁
- Gap lock ：间隙锁，锁定一个范围，不包括记录本身
- Next-key lock ： record+gap 锁定一个范围，包含记录本身

## 数据库优化
### 读写分离
主库负责写，从库负责读，这种集群方式的本质是把数据库访问的压力从主库转移到从库上，不适合写操作密集的情况。做主从之后可以单独对从库做索引优化，主库可以减少索引提高写效率

#### 主从同步延迟
在主库有数据写入后，同时也写入binlog(二进制日志文件)中，从库是通过binlog文件来同步数据的，期间可能有一定时间的延迟，如果数据量大的话，时间可能更长  

解决办法：关键业务读写都由主库承担，非关键业务读写分离  
类似付钱的业务，读写都到主库，避免延迟的问题，但例如该个头像等业务比较不重要的业务采用读写分离

#### 分配机制
分配机制，怎么制定写操作是去主库写，读操作是去从库读  

1.代码封装  
在代码中抽出一个中间层，让这个中间层来实现读写分离和数据库连接，提供一个provider，封装了常用数据库操作，save操作的dataSource是主库的，select操作的dataSource是从库的  
优点:实现简单，可以根据业务定制变化  
缺点：如果那个数据库宕机，发生主从切换后，需要修改配置重启  

2.数据库中间件  
数据库中间件是个独立的系统，专门实现读写分离和数据库连接管理，业务服务器和数据库中间件之间通过标准的SQL协议交流，在业务服务器看来数据库中间件其实就是个数据库  
优点：有中间件来实现主从切换，业务服务器不需要关心  
缺点：多了一个系统等于多了一个瓶颈，因为所有的数据库操作都要经过它，所以对中间件的性能要求也很高，有开源数据库中间件,如MySQL Proxy，MySQL Route  

####  读写分离小结
读写分离只能分担访问读的压力，无法分担存储的压力，一般先优化慢查询，优化业务逻辑或加入缓存，如果都不行再考虑读写分离，之后才是分库分表

### 分库分表
#### 垂直分区
根据数据库表的相关性进行拆分，如用表中既有用户登录信息又有用户的基本信息，可以将用户表拆分为两个单独的表，或者放到单独的库做分库，通俗来说就是将一张大表拆分为两张小表  
优点：  
- 使得行数据变小，一个数据库(BLock)能存放更多数据，在查询的时候就会减少I/O次数
- 可以最大化利用Cache，具体在垂直拆分的时候可以将不常变的字段放一起，将经常改变的放一起
- 可以简化表结构，易于维护

缺点：  
- 主键会出现冗余，需要管理冗余列
- 并会引起JOIN操作，增加CPU开销，可以通过在业务服务器上进行JOIN来减少数据库压力
- 事务处理更加复杂

#### 水平分区
保持数据表结构不变，通过某种策略存储数据分片，这样每一片数据分散到不同的表或库中，达到分布式的效果，通俗来说就是将一张300万行的表分成3个100万行的表放在不同的数据库存储，避免数据量过大对数据库性能的影响  
优点：  
- 水平分区可以支撑非常大的数据量，但前提是把数据分布到不同的机器上，不然在同一台机器上分表，竞争同一个物理机上的IO、CPU、网络，对提升MySQL的并发没有什么意义
- 应用端的改造很少
- 提升了系统的稳定性和负载能力

缺点：  
- 分片事务一致性难以解决
- 跨节点JOIN性能差，逻辑复杂
- 数据多次扩展难度和维护量极大

#### 数据库分片的两种常见方案
- 客户端代理：分片逻辑在应用端，封装在jar包中，通过修改或封装JDBC层来实现，如当当网的Sharding-JDBC、阿里的TDDL
- 中间件代理：在应用和数据中间加了一个代理层，分片逻辑统一维护在中间件服务中，Mycat就是这种架构的实现

#### 水平分区小结
尽量不要对数据进行水平分片，因为拆分提升逻辑、部署、运维的各种复杂度，一般的数据表在优化得当的情况下支撑千万以下的数据量是没有多大问题的，如果，必须要做分片，尽量选择客户端分片架构，这样可以减少一次和中间件的网络IO

### 字段
- 尽量使用TINYINT、SMALLINT、MEDIUM_INT作为整数类型而非INT，如果非负则加上UNSIGNED
- VARCHAR的长度只分配真正需要的空间
- 使用枚举或整数代替字符串类型，如性别字段用0，1代替'男''女'
- 尽量使用TIMESTAMP而非DATETIME，
- 单表不要有太多字段，建议在20以内
- 避免使用NULL字段，很难查询优化且占用额外索引空间
- 用整型来存IP

### 索引
- 索引并不是越多越好，要根据查询有针对性的创建，考虑在WHERE和ORDER BY命令上涉及的列建立索引，可根据- EXPLAIN来查看是否用了索引还是全表扫描
- 应尽量避免在WHERE子句中对字段进行NULL值判断，否则将导致引擎放弃使用索引而进行全表扫描
- 值分布很稀少的字段不适合建索引，例如"性别"这种只有两三个值的字段
- 字符字段只建前缀索引
- 字符字段最好不要做主键
- 不用外键，在逻辑上实现外键
- 尽量不用UNIQUE，由程序保证约束
- 使用多列索引时注意顺序和查询条件保持一致，同时删除不必要的单列索引

### 查询SQL
- 可通过开启慢查询日志来处理较慢的SQL
- 不做列运算：任何对列的操作都将导致表扫描，它包括数据库教程函数、计算表达式等等，如 SELECT id WHERE age + 1 = 10， select * from user where YEAR(date)<2019 可以改为 select * from user where date<'2019-01-01',
- sql语句尽可能简单：一条sql只能在一个cpu运算；大语句拆小语句，减少锁时间；一条大sql可以堵死整个库
- 不用SELECT *
- OR改写成IN：OR的效率是n级别，IN的效率是log(n)级别，in的个数建议控制在200以内
- 不用函数和触发器，在应用程序实现
- 少用JOIN
- 使用同类型进行比较，比如用'123'和'123'比，123和123比
- 尽量避免在WHERE子句中使用!=或<>操作符，否则将引擎放弃使用索引而进行全表扫描
- 对于连续数值，使用BETWEEN不用IN：SELECT id FROM t WHERE num BETWEEN 1 AND 5
- 列表数据不要拿全表，要使用LIMIT来分页，每页数量也不要太大
- 不建议使用like操作,like '%aaa%' 不会使用索引，like 'aaa%'会使用索引

### 缓存
缓存可以发生在这些层次：
- MySQL内部：在系统调优参数介绍了相关设置
- 数据访问层：比如MyBatis针对SQL语句做缓存，而Hibernate可以精确到单个记录，这里缓存的对象主要是持久化对象Persistence Object
- 应用服务层：这里可以通过编程手段对缓存做到更精准的控制和更多的实现策略，这里缓存的对象是数据传输对象Data Transfer Object
- Web层：针对web页面做缓存
- 浏览器客户端：用户端的缓存

可以根据实际情况在一个层次或多个层次结合加入缓存。这里重点介绍下服务层的缓存实现，目前主要有两种方式：
- 直写式（Write Through）：在数据写入数据库后，同时更新缓存，维持数据库与缓存的一致性。这也是当前大多数应用缓存框架如Spring Cache的工作方式。这种实现非常简单，同步好，但效率一般。
- 回写式（Write Back）：当有数据要写入数据库时，只会更新缓存，然后异步批量的将缓存数据同步到数据库上。这种实现比较复杂，需要较多的应用逻辑，同时可能会产生数据库与缓存的不同步，但效率非常高。




