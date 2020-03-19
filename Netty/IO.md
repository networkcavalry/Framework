## 一、I/O 访问方式

## 二、I/O 模型

### 2.1 同步阻塞

### 2.2 同步非阻塞

### 2.3 异步模型

## 三、线程模型





## 一、前言

在线用户量递增，传统的单机服务的性能和网络通讯瓶颈慢慢呈现，应用架构从单应用到应用数据分离，再到分布式集群高可用架构，单台服务的性能不足可以通过构建服务集群的方式水平扩展。

一个高性能的网络通讯框架从硬件设备到操作系统内核以及用户模式都需要精心设计。只要有任何地方有疏漏都会出现短板效应。

## 二、I/O 访问

当我们在读取socket数据时，虽然我们在代码仅仅是调用了一个`Read`操作，但是实际操作系统层面做了许多事情。首先操作系统需要从用户模式转换为内核模式，处理器不会直接操控硬件，因此它会通过网卡驱动对网卡控制器进行操作，网卡控制器则控制网卡。

早期的I/O都是通过CPU直接控制外围设备，后来为了提高效率，后来增加了DMA控制器，它可以模拟处理器获得内存总线控制权，进行I/O的读写。当处理器将控制权交给DMA控制器之后，DMA处理器会先让I/O硬件设备将数据放到I/O硬件的缓冲区中，然后DMA控制器就可以开始传输数据了。在此过程中处理器无需消耗时钟周期。当DMA操作完成时，会通过中断操作通知处理器。

![image-20200307092110511](img/image-20200307092110511.png)

> I/O 访问的发展趋势是尽可能减少CPU干涉I/O操作，让CPU从I/O任务中解放出来，去做其他的事情，来提高性能。

## 三、I/O模型

在讨论I/O模型之前，首先引出一个叫做C10K的问题。在早期的I/O模型使用的是同步阻塞模型，当接收到一个新的TCP连接时，就需要分配一个线程。因此随着连接增加线程增多，频繁的内存复制，上下文切换带来的性能损耗导致性能不佳。因此如何使得单机网络并发连接数达到10K成为通讯开发者热门的讨论话题。

### 1. 同步阻塞

在最原始的I/O模型中，对文件设备数据的读写需要同步等待操作系统内核，即使文件设备并没有数据可读，线程也会被阻塞住，虽然阻塞时不占用CPU时钟周期，但是若需要支持并发连接，则必须启用大量的线程，即每个连接一个线程。这样必不可少的会造成线程大量的上下文切换，随着并发量的增高，性能越来越差。

### 2. select模型/poll模型

为了解决同步阻塞带来线程过多导致的性能问题，同步非阻塞方案产生。通过一个线程不断的判断文件句柄数组是否有准备就绪的文件设备，这样就不需要每个线程同步等待，减少了大量线程，降低了线程上下文切换带来的性能损失，提高了线程利用率。这种方式也称为I/O多路复用技术。但是由于数组是有数组长度上限的(linux默认是1024)，而且select模型需要对数组进行遍历，因此时间复杂度是O(n)O(n)因此当高并发量的时候，select模型性能会越来越差。

poll模型和select模型类似，但是它使用链表存储而非数组存储，解决了并发上限的限制，但是并没有解决select模型的高并发性能底下的根本问题。

### 3. epoll模型

在linux2.6支持了epoll模型，epoll模型解决了select模型的性能瓶颈问题。它通过注册回调事件的方式，当数据可读写时，将其加入到通过回调方式，将其加入到一个可读写事件的队列中。这样每次用户获取时不需要遍历所有句柄，时间复杂度降低为O(1)O(1)。因此epoll不会随着并发量的增加而性能降低。随着epoll模型的出现C10K的问题已经完美解决。

### 4. 异步I/O模型

前面讲的几种模型都是同步I/O模型，异步I/O模型指的是发生数据读写时完全不同步阻塞等待，换句话来说就是数据从网卡传输到用户空间的过程时完全异步的，不用阻塞CPU。为了更详细的说明同步I/O与异步I/O的区别，接下来举一个实际例子。

当应用程序需要从网卡读取数据时，首先需要分配一个用户内存空间用来保存需要读取的数据。操作系统内核会调用网卡缓冲区读取数据到内核空间的缓冲区，然后再复制到用户空间。在这个过程中，同步阻塞I/O在数据读取到用户空间之前都会被阻塞，同步非阻塞I/O只知道数据已就绪，但是从内核空间缓冲区拷贝到用户空间时，线程依然会被阻塞。而异步I/O模型在接收到I/O完成通知时，数据已经传输到用户空间。因此整个I/O操作都是完全异步的，因此异步I/O模型的性能是最佳的。

![20191124140638.png](img/580757-20191124140638993-1878414448.png)

> 在我的另一篇文章[《Windows内核原理-同步IO与异步IO》](https://www.cnblogs.com/Jack-Blog/p/11385686.html)对windows操作系统I/O原理做了简要的叙述，感兴趣的同学可以看下。

## 四、I/O线程模型

从线程模型上常见的线程模型有Reactor模型和Proactor模型，无论是哪种线程模型都使用I/O多路复用技术，使用一个线程将I/O读写操作转变为读写事件，我们将这个线程称之为多路分离器。

对应上I/O模型，Reacor模型属于同步I/O模型，Proactor模型属于异步I/O模型。

### Reactor模型

在Reactor中，需要先注册事件就绪事件，网卡接收到数据时，DMA将数据从网卡缓冲区传输到内核缓冲区时，就会通知多路分离器读事件就绪，此时我们需要从内核空间读取到用户空间。

> 同步I/O采用缓冲I/O的方式，首先内核会从申请一个内存空间用于存放输入或输出缓冲区，数据都会先缓存在该缓冲区。

### Proactor模型

Proactor模型，需要先注册I/O完成事件，同时申请一片用户空间用于存储待接收的数据。调用读操作，当网卡接收到数据时，DMA将数据从网卡缓冲区直接传输到用户缓冲区，然后产生完成通知，读操作即完成。

> 异步I/O采用直接输入I/O或直接输出I/O，用户缓存地址会传递给设备驱动程序，数据会直接从用户缓冲区读取或直接写入用户缓冲区，相比缓冲I/O减少内存复制。

## 五、总结

本文通过I/O访问方式，I/O模型，线程模型三个方面解释了操作系统为实现高性能I/O做了哪些事情，通过提高CPU使用效率，减少内存复制是提高性能的关键点。



## I/O

I/O即输入输出。在现在操作系统，输入输出是计算机完整功能必不可少的一部分。处理器负责各种计算任务，然后通过各种输入输出设备与外界进行交互。常见的输入输出设备包括键盘、鼠标、显示器、硬盘、网络适配器接口等。有了硬件设备，在软件层面上，使得操作系统通过以一致的方式与设备驱动交互从而的操控硬件设备。而应用程序通过统一的接口与系统内核进行交互。

在Windows下分为内核模式和用户模式。应用程序运行在用户模式下，操作系统和驱动程序运行在内核模式下。应用程序通过调用`Win32 API`与Windows内核交互。

![20190820191937.png](img/580757-20190820191944686-76354328.png)

**Windows内核则通过设备驱动程序与设备控制器进行通讯，而设备控制器则直接操控硬件设备。**

设备控制器控制 I/O 的两种方式：

- 可以通过内存映射I/O的方式将设备的内存与主存映射，通过内存映射I/O后，处理器访问的就不是主存而是设备控制器的寄存器内存。但是这种方式的访问效率并不高，不适合大数据量I/O读写。
- 通常硬盘和网络驱动器采用直接访问内存(DMA)的方式进行大量数据的I/O操作。DMA需要硬件支持，硬件会有DMA控制器，在硬件执行I/O操作的时候，不会占用CPU的指令周期，DMA控制器会和设备进行I/O操作。当数据传输完成后,DMA则会通知处理器I/O操作完成。

![20190820191613.png](img/580757-20190820191620016-424918110.png)



### 同步I/O

当我们要把文件从硬盘读取到内存时，硬盘的读取速度是远小于内存的写入速度的。因此当我们使用一个线程从硬盘读取文件到内存中时。通常需要等待硬盘将数据从硬盘读取到内存中，此时线程将被阻塞，但是不会消耗指令周期。当读取完毕时，线程继续执行后续操作。
虽然DMA执行的时候当前线程被阻塞，此时处理器可以获取另一个线程内核执行其他操作，由于线程是非常昂贵的资源，因此使用同步I/O的方式若需要并发执行时，需要大量的创建线程资源，这就产生了大量的线程上下文切换。

### 异步I/O

前面提到了当硬件进行I/O传输时，实际上通常使用DMA技术执行I/O操作，不会占用CPU的指令周期。因此只要操作系统支持异步I/O，则可以极大的提升系统性能，最大程度的降低线程数量，减少线程上下文切换产生的性能损失。

> 在Windows下的异步I/O我们也可以称之为重叠(overlapped)I/O。重叠的意思是执行I/O请求的时间与线程执行其他任务的时间是重叠的，即执行真正I/O请求的时候，我们的工作线程可以执行其他请求，而不会阻塞等待I/O请求执行完毕。

当使用一个线程向设备发出一个异步I/O请求时，该请求被传给设备驱动程序，设备驱动程序处理I/O请求时并不会等待I/O请求完成，而是将I/O请求加入到设备驱动程序的队列中，然后返回一个I/O处理中的信号。而实际的I/O操作则由设备驱动程序将I/O请求传给指定的硬件设备的设备控制器执行I/O操作。应用程序的线程并不需要挂起等待I/O请求的完成，从而可以继续执行其他任务。当某一时刻设备驱动程序完成了该I/O请求处理，设备控制器通过中断指令通知I/O请求完成，处理器则将通知I/O请求已完成。

### I/O完成通知

在Windows中一共支持四种接收完成通知的方式。分别为触发设备内核对象、触发时间内核对象、可提醒I/O以及I/O完成端口。

#### 触发设备内核

当设备驱动加载时会创建一个设备驱动对象，设备驱动程序还会为设备创建对应的设备对象。设备对象代表的是每一个物理设备或逻辑设备。设备对象描述了一个特定设备的状态信息，包括I/O请求的状态。在通过异步I/O将I/O请求添加到队列之前，会将设备内核对象设置为未触发，此时就可以使用该设备内核对象进行同步操作，当I/O请求完成后则会将设备内核对象设置为触发状态。使用设备内核对象进行线程同步时，无法区分当前完成通知的I/O是读操作还是写操作，因此无论是读还是写都会将其状态设置为触发状态。

#### 事件内核对象

通过设备内核对象进行I/O通知由于无法区分读写操作，因此并没有什么用。通过事件内核对象我们可以将读写事件分离。在调用读写操作的时候会返回对应的读写事件内核对象。这样我们就可以等待对应的事件内核对象知道是什么I/O操作完成。我们可以通过等待多个事件内核对象，但是一次性最多只能等待64个事件内核对象，即一个线程最多只能创建64个事件内核对象进行等待。若需要监控上万个连接，则需要创建上百个线程进行监控。

#### 可提醒I/O

在系统创建线程的时候会创建一个与线程相关的队列，该队列被称为异步调用(APC)队列，当发出一个I/O请求时，我们可以告诉设备驱动程序在调用线程的APC队列中添加一项完成函数，在I/O完成通知时调用完成函数进行回调。I/O完成通知最大的问题是，请求时哪个线程调用的，必须由哪个线程回调。它不支持负载均衡机制。

#### 完成端口

I/O完成端口的设计理论依据是并发编程的线程数必须有一个上限，即最佳并发线程数为CPU的逻辑线程数。I/O完成端口充分的发挥了并发编程的优势的同时又避免了线程上下文切换带来的性能损失。
完成端口可能是最复杂的内核对现象，但是它又是Windows下性能最佳的I/O通知方式。

首先我们需要创建一个I/O完成端口，创建完成端口的时候可以指定线程数量。通过将设备与I/O完成端口进行关联。此使我们发出的I/O请求时，系统内核返回`IO_PENDDING`状态，然后线程就可以继续处理其他事情。而DMA继续执行I/O操作，将数据从设备读取到设备控制器的缓冲区中，并对其进行必要的校验后，将数据通过系统总线传输到内存中。当数据传输完成后，DMA发出中断指令通知数据传输完毕，系统则会通过前面创建的I/O线程将I/O完成请求加入到I/O完成队列中。

然后我们通过调用`Win32 API`就可以获取到对应的设备I/O完成请求通知，通知会将I/O完成请求从完成队列移除。

## 总结

1. 同步I/O会阻塞线程。由于硬盘的读取速度是远小于内存的写入速度的，因此当某个线程需要从硬盘读取文件时，通常需要等待数据从硬盘读取到内存的过程，等待时线程将被阻塞，当读取完毕时，线程继续执行后续操作。在等待期间，不会消耗指令周期，但在并发量大的情况下，同时启用多个线程会提高线程上下文切换的性能损耗，在维持被阻塞的线程时，也会消耗大量的系统资源。

2. 异步I/O不会阻塞线程。当收到一个异步I/O请求时，该请求会被传递给设备驱动程序并加入到设备驱动程序的请求队列中，然后直接返回`IO_PENDDING`状态表示请求受理成功，此时发送请求的线程（也就是应用程序的线程）并不需要阻塞等待I/O请求的完成，可以继续执行其他任务。而实际的I/O操作则由设备驱动程序以DMA（直接访问内存）的方式进行大量数据的 I/O 操作，它会将队列中的I/O请求传给指定硬件设备的设备控制器执行。当底层设备完成了真实的I/O请求后会通过中断控制器通过中断操作通知CPU，CPU会调度一个线程通知上层设备驱动程序,将完成通知加入到完成队列中。此时上层应用即可获取到完成通知。

3. 完成端口是windows下性能最佳的完成通知方式。它最大程度的减少线程上下文切换。

4. 使用异步I/O和完成端口实现高性能I/O操作的主要原因有三点：

   - 减少线程，减少I/O上下文切换
   - 异步不阻塞线程
   - 避免内存复制

   
