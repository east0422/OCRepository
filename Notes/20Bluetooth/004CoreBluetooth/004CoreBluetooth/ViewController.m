//
//  ViewController.m
//  004CoreBluetooth
//
//  Created by dfang on 2020-1-14.
//  Copyright © 2020 east. All rights reserved.
//

#import "ViewController.h"
#import <CoreBluetooth/CoreBluetooth.h>

@interface ViewController () <CBCentralManagerDelegate, CBPeripheralDelegate, UITableViewDataSource>

@property (nonatomic, strong) CBCentralManager *centralManager;
@property (nonatomic, strong) NSMutableArray *peripheralList;

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation ViewController

- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:(UITableViewStylePlain)];
        _tableView.backgroundColor = [UIColor lightGrayColor];
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // 1. 创建中心设备
    _centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
    _peripheralList = [NSMutableArray array];
    
    [self.view addSubview:self.tableView];
}

#pragma mark - CBCentralManagerDelegate
- (void)centralManagerDidUpdateState:(CBCentralManager *)central {
//    NSLog(@"central:%ld",central.state);
    if (central.state == CBManagerStateUnsupported) {
        NSLog(@"该设备不支持蓝牙！");
    } else if (central.state == CBManagerStatePoweredOn) {
        // 2. 扫描外设，services设为nil扫描所有
        [self.centralManager scanForPeripheralsWithServices:nil options:nil];
    }
}

- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary<NSString *,id> *)advertisementData RSSI:(NSNumber *)RSSI {
    if (![self.peripheralList containsObject:peripheral]) {
        [self.peripheralList addObject:peripheral];
        
        NSIndexPath *lastIndexPath = [NSIndexPath indexPathForRow:(self.peripheralList.count - 1) inSection:0];
        [self.tableView insertRowsAtIndexPaths:@[lastIndexPath] withRowAnimation:(UITableViewRowAnimationFade)];
        // 调用reloadRowsAtIndexPaths时，依赖于tableView先前的状态已有要更新的cell，内部是先删除该cell，\
        再重新创建，所以当你在原先没有该cell的状态下调用reloadRowsAtIndexPaths，会报异常你正在尝试不存在的cell。
//        [self.tableView reloadRowsAtIndexPaths:@[lastIndexPath] withRowAnimation:(UITableViewRowAnimationFade)];
        
        // reloadData是完全重新加载，包括cell数量也会重新计算，不会依赖之前tableView的状态
//        [self.tableView reloadData];
    }
    
    // 3. 连接外设
    [self.centralManager connectPeripheral:peripheral options:nil];
    peripheral.delegate = self;
}

- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral {
    // 4. 扫描服务，services为nil扫描所有
    [peripheral discoverServices:nil];
}

#pragma mark - CBPeripheralDelegate
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error {
    for (CBService *service in peripheral.services) {
//        NSLog(@"service:%@", service.debugDescription);
        if ([service.UUID.UUIDString isEqualToString:@"12340981221"]) { // uuid一致
            // 5. 扫描特征，为nil扫描所有
            [peripheral discoverCharacteristics:nil forService:service];
        }
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error {
    for (CBCharacteristic *characteristic in service.characteristics) {
        if ([characteristic.UUID.UUIDString isEqualToString:@"32111"]) {
            // 6. 数据交互
            // 读
            [peripheral readValueForCharacteristic:characteristic];
            // 写
//            [peripheral writeValue:[@"daadadad" dataUsingEncoding:(NSUTF8StringEncoding)] forCharacteristic:characteristic type:(CBCharacteristicWriteWithResponse)];
        }
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    // 7. 断开，停止扫描
    [self.centralManager stopScan];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.peripheralList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellid111"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleSubtitle) reuseIdentifier:@"cellid111"];
        cell.backgroundColor = [UIColor clearColor];
    }
    
    CBPeripheral *peripheral = self.peripheralList[indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"第%zd个", indexPath.row + 1];
    cell.detailTextLabel.text = peripheral.name;
    
    return cell;
}

@end
