//
//  ViewController.h
//  unjailme
//
//  Created by Sem Voigtländer on 27/02/2018.
//  Copyright © 2018 Jailed Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "exploit.h"
@interface ViewController : UIViewController <CBCentralManagerDelegate>
@property SandboxExploit* sbexploit;
@property BOOL bluetoothEnabled;
@property CBCentralManager* bluetoothManager;
@end

