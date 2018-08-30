//
//  main.m
//  01Socket
//
//  Created by dfang on 2018-8-29.
//  Copyright © 2018年 east. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sys/socket.h>
#import <netinet/in.h>
#import <arpa/inet.h>
void socketDemo();

// nc -lk 12345另一个终端中连接监听12345端口
int main(int argc, const char * argv[]) {
    @autoreleasepool {
        socketDemo();
    }
    return 0;
}


// socket演示
void socketDemo() {
    // 1. 创建socket
    /**
     domain：协议域，又称协议族（family）。常用的协议族有AF_INET、AF_INET6、AF_LOCAL（或称AF_UNIX，Unix域Socket）、AF_ROUTE等。协议族决定了socket的地址类型，在通信中必须采用对应的地址，如AF_INET决定了要用ipv4地址（32位的）与端口号（16位的）的组合、AF_UNIX决定了要用一个绝对路径名作为地址。
     type：指定Socket类型。常用的socket类型有SOCK_STREAM、SOCK_DGRAM、SOCK_RAW、SOCK_PACKET、SOCK_SEQPACKET等。流式Socket（SOCK_STREAM）是一种面向连接的Socket，针对于面向连接的TCP服务应用。数据报式Socket（SOCK_DGRAM）是一种无连接的Socket，对应于无连接的UDP服务应用。
     protocol：指定协议。常用协议有IPPROTO_TCP、IPPROTO_UDP、IPPROTO_STCP、IPPROTO_TIPC等，分别对应TCP传输协议、UDP传输协议、STCP传输协议、TIPC传输协议。
     注意：1.type和protocol不可以随意组合，如SOCK_STREAM不可以跟IPPROTO_UDP组合。当第三个参数为0时，会自动选择第二个参数类型对应的默认协议。
     2.WindowsSocket下protocol参数中不存在IPPROTO_STCP
     */
    int socketClient = socket(AF_INET, SOCK_STREAM, 0);
    NSLog(@"socketClient:%d", socketClient);
    
    // 连接服务器
    struct sockaddr_in addServer;
    addServer.sin_family = AF_INET;
    addServer.sin_port = htons(12345);
    addServer.sin_addr.s_addr = inet_addr("127.0.0.1");
    int connectResult = connect(socketClient, (const struct sockaddr *)&addServer, sizeof(addServer));
    NSLog(@"connectResult:%d", connectResult);
    if (connectResult != 0) {
        NSLog(@"connect fail!");
        return;
    }
    
    // 写数据
    NSString *msg = @"hello server!";
    ssize_t sendLen = send(socketClient, msg.UTF8String, strlen(msg.UTF8String), 0);
    NSLog(@"send message length: %d", sendLen);
    
    // 读数据
    uint8_t buffer[1024];
    while (true) { // 一直读取
        ssize_t recvLen = recv(socketClient, buffer, sizeof(buffer), 0);
        NSLog(@"接收到了 %ld 个字节", recvLen);
        if (recvLen == 0) { // server端关闭socket
            break;
        }
        //获取服务器返回的数据,从缓冲区读取recvLen个字节!!!
        NSData * data = [NSData dataWithBytes:buffer length:recvLen];
        //二进制转字符串
        NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"%@",str);
        
        send(socketClient, [@"socket received:" stringByAppendingString:str].UTF8String, strlen([@"socket received" stringByAppendingString:str].UTF8String), 0);
    }

    // 关闭连接
    int closeResult = close(socketClient);
    NSLog(@"close result:%d", closeResult);
}
