# MultipeerConnectivity


#### 简述
1. 从iOS7开始引入，用于取代GameKit。
2. 不仅仅支持蓝牙连接，准确的说它是一种支持WiFi网络、P2P以及蓝牙个人局域网的通信框架，它屏蔽了具体的连接技术，让开发人员有统一的接口编程方法。
3. 通过MMultipeerConnectivity连接的节点之间可以安全的传递信息、流或者其他文件资源而不必通过网络服务。
4. 使用MultipeerConnectivity进行近场通信也不再局限于同一个应用之间传输，而是可以在不同的应用之间进行数据传输。

#### 使用
1. Multipeer Connectivity其功能与AirDrop非常接近。相比AirDrop，Multipeer Connectivity在进行发现和会话时并不要求同时打开WiFi和蓝牙，也不想AirDrop那样强制打开这两个开关，而是根据条件适时选择使用蓝牙或WiFi。
	1. 蓝牙和WiFi都未打开：无法发现使用。
	2. 只打开蓝牙：可以正常使用，通常蓝牙发现和传输。
	3. 只打开WiFi但是未连接同一个路由器：可以正常使用，会通过WiFi Direct传输。
	4. 同时打开WiFi、蓝牙：那就是一个AirDrop的完整功能。
2. 常用类
	1. MCPeerID：类似sockaddr，用于标识连接的两端endpoint，通常是昵称或设备名称。该对象只开放了displayName属性，私有MCPeerIDInternal对象持有的设备相关的_idString/_pid64字段并未公开。许多情况下，客户端同时广播并发现同一个服务，这将导致一些混乱，尤其是在client/server模式中，所以每一个服务都应有一个类型标识符——serviceType，它是由ASCII字母、数字和"-"组成的短文本串，最多15个字符。
	2. MCNearbyServiceAdvertiser：类似broadcaster，可以接收并处理用户请求连接的响应。但是这个类会有回调，告知有用户要与您的设备连接，然后可以自定义提示框，以及自定义连接处理。主线程创建MCNearbyServiceAdvertiser并启动startAdvertisingPeer。MCNearbyServiceAdvertiserDelegate异步回调(didReceiveInvitationFromPeer)切换回主线程。在主线程didReceiveInvitationFromPeer中创建MCSession并invitationHandler(YES, session)接受会话连接请求(accept参数为YES)。
	3. MCNearbyServiceBrowser：类似servo listen+client connect，用于搜索附近的用户，并可以对搜索到的用户发出邀请加入某个会话中。主线程创建MCNearbyServiceBrowser并启动startBrowsingForPeers。MCNearbyServiceBrowserDelegate异步回调(foundPeer/lostPeer)切换回主线程。主线程创建MCSession并启动invitePeer。
	4. MCSession：启用和管理Multipeer连接会话中的所有人之间的沟通。通过Session给别人发送数据，注意peerID并不具备设备识别属性。类似TCP连接中的socket。创建MCSession时，需指定自身MCPeerID，类似bind。为避免频繁的会话数据通知阻塞主线程，MCSessionDelegate异步回调(didChangeState/didReceiveCertificate/didReceiveData/didReceiveStream)又一个专门的回调线程———com.apple.MCSession.callbackQueue(serial)。为避免阻塞MCSession回调线程，最好新建数据读(写)线程。
	5. MCAdvertiserAssistant：针对Advertiser封装的管理助手，可以接收并处理用户请求连接的响应，没有回调，会弹出默认的提示框，并处理连接。
	6. MCBrowserViewController：继承自UIViewController，提供了基本的UI应用框架。弹出搜索框，需要手动modal。MCBrowser/MCAdvertiser的回调线程一般是delegate所在线程Queue：com.apple.main-thread(serial)。

