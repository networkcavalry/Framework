## 1.线程和进程  ok！
- [1进程](#1.1进程)
  - [1.1.1进程的由来](#1.1.1进程的由来)
  - [1.1.2并行和并发](#1.1.2并行和并发)
  - [1.1.3从应用层面理解进程](#1.1.3从应用层面理解进程)
- [1.2线程](#1.2线程)
  - [1.2.1线程的由来](#1.2.1线程的由来)
  - [1.2.2Java中的线程](#1.2.2Java中的线程)
- [1.3多线程的优缺点](#1.3多线程的优缺点)
  - [1.3.1多线程的优势](#1.3.1多线程的优势)
  - [1.3.2多线程带来的风险](#1.3.2多线程带来的风险)

## 2.线程的生命周期  ok！
- [1.如何创建一个线程](#1.如何创建一个线程)
  - [1.1实现Runnable接口](#1.1实现Runnable接口)
  - [1.2继承Thread类](#1.2继承Thread类)
  - [1.3实现Callable接口](#1.3实现Callable接口)
  - [1.4对创建线程的一些个人理解](#1.4对创建线程的一些个人理解)
- [2.线程的生命周期和状态](#2.线程的生命周期和状态)

## 3.Thread类的使用  ok！
- [1.Thread中的属性](#1.Thread中的属性)
- [2.Thread中的方法](#2.Thread中的方法)
  - [2.1 start()、run()和stop()](#2.1start()、run()和stop())
  - [2.2 suspend()和resume()](#2.2suspend()和resume())
  - [2.3 sleep()和TimeUnit](#2.3sleep()和TimeUnit)
  - [2.4 interrupt()、isInterrupted()和Thread.interrupted()](#2.4interrupt()、isInterrupted()和Thread.interrupted())
  - [2.5 wait()和notify()/notifyAll()](#2.5wait()和notify()/notifyAll())
  - [2.6 yeild()和join()](#2.6yeild()和join())

## Java内存模型和线程安全  
竞态条件  临界区
ThreadLocal volatile synchronized

## 并发级别和无锁   
并发级别 AQS CAS 无锁类的使用 AtomicXXX类 Unsafe  乐观锁与悲观锁的比较 公平锁
AtomicIntergerArray AtomicIntegerFieldUpdater LockFreeVector


## JDK并发包  
Lock ReentrantLock Semaphore CountDownLatch  CyclicBarrier  
LockSupport ReadWriteLock 

## 并发容器  
同步容器,并发容器,阻塞队列 ConcurrentModificationException
ConcurrentHashMap CopyOnWriteArrayList

## 线程池  
Executors Callable Future FutureTask Timer

## 锁优化  
锁粒度，锁分离，锁粗化，锁消除
偏向锁，轻量级锁，自旋锁总结


## 其他
 JDK8
LongAdder  CompletableFuture StampedLock
多线程中的设计模式
单例模式 不变模式 Future模式 生产者消费者模式