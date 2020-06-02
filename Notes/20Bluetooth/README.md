# Bluetooth


#### iOS中蓝牙的几种实现
1. GameKit.framework：只能用于iOS设备之间的连接，多用于游戏，从iOS7开始过期。 
2. MultipeerConnectivity.framework：只能用于iOS设备之间的连接，从iOS7开始引入，主要用于文件共享(仅限于沙盒的文件)。
3. ExternalAccessory.framework：可用于第三方蓝牙设备交互，但是蓝牙设备必须经过苹果MFi认证。
4. CoreBluetooth.framework：可用于第三方蓝牙设备交互，必须要支持蓝牙4.0，硬件设备至少是iPhone4s，系统至少iOS6，用于运动手环嵌入式设备、智能家居等。


#### Core Bluetooth
1. 简述
	1. 每个蓝牙4.0设备都是通过服务(Service)和特征(Characteristic)来展示自己的，一个设备必然包含一个或多个服务，每个服务下面又包含若干特征。
	2. 特征是与外界交互的最小单位，比如说，一台蓝牙4.0设备用特征A来描述自己的出厂信息，用特征B来收发数据。
	3. 服务和特征都是用UUID来唯一标识的，通过UUID就能区别不同的服务和特征。设备里面各个服务(service)和特征(characteristic)的功能，均由蓝牙设备硬件厂商提供，比如哪些是用来交互(读写)，哪些可获取模块信息(只读)等。
2. 开发步骤
	1. 建立中心设备CBCentralManager。
	2. 扫描外设[centralManager scanForPeripheralsWithServices:options:]。
	3. 连接外设[centralManager connectPeripheral:]。
	4. 扫描外设中的服务([peripheral discoverServices:])和特征([peripheral discoverCharacteristics:])。
	5. 利用特征与外设做数据交互(peripheral read/write)。
	6. 断开连接[centralManager stopScan]。


