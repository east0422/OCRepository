# Socket


#### 简述
1. socket连接就是所谓的长连接，理论上客服端和服务器端一旦建立起连接将不会主动端掉，基于C跨平台的；但是由于各种环境因素连接可能会断开(eg：服务器端或客服端主机down了，网络故障，或两者之间长时间没有数据传输，网络防火墙可能会断开该连接以释放网络资源)。所以当一个socket连接中没有数据的传输，那么为了维持连接需要发送心跳消息，具体心跳消息格式是开发者自己定义的。
2. socket是通信的基石，是支持TCP/IP协议的网络通信的基本操作单元。它是网络通信过程中端点的抽象表示，包含进行网络通信必须的五种信息：连接使用的协议，本地主机的ip地址，本地进程的协议端口，远地主机的ip地址，远地进程的协议端口。
3. socket是对tcp/ip协议的封装，socket本身并不是协议，而是一个调用接口(api)，通过socket我们才能使用tcp/ip协议。实际上socket跟tcp/ip协议没有必然的联系。socket编程接口在设计的时候就希望也能适应其它的网络协议。所以说socket的出现只是使得程序员更方便地使用tcp/ip协议栈而已，是对tcp/ip协议的抽象，从而形成了我们知道的一些最基本的函数接口，比如create、listen、connect、accept、send、read和write等等。


