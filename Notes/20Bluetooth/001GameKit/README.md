# GameKit


#### 简述
1. 只能用于iOS设备及同一个应用程序之间的连接，多用于游戏。 
2. 一次性传送(没有中间方法即传输进度比例等)，对于用户而言选择了传输就需要等待传输完成或传输失败告终(所以最好不要用蓝牙传输比较大的数据文件)。
3. 从iOS7开始过期。

#### 使用
1. 实现GKPeerPickerControllerDelegate协议，处理来自GKPeerPickerController(对端选择器)的信息。
2. 创建一个GKPeerPickerController(提供了一个标准的用户界面)设置delegate然后调用对应的show方法即可进行查找(需要注意的是需要为同一个app之间)。
3. 实现协议方法，在连接成功后保存session，使用setDataReceiveHandler:设置数据接收处理并实现receiveData:方法。`setDataReceiveHandler:(id)handler withContext:(void *)context;  // SEL = -receiveData:fromPeer:inSession:context:`

