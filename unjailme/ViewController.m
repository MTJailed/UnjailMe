//
//  ViewController.m
//  unjailme
//
//  Created by Sem Voigtländer on 27/02/2018.
//  Exploit by https://github.com/rani-i
//  Copyright © 2018 Jailed Inc. All rights reserved.
//

#import <UIKit/UIKit.h> //needed for the Ui i am working on
#import "ViewController.h"
#import "APIManager.h"
#import "exploit.h"
@interface ViewController()
- (IBAction)doExploit:(id)sender;
@property (weak, nonatomic) IBOutlet UITextView *consoleView;
@end

@implementation ViewController

- (void)startBluetoothStatusMonitoring {
    // Horrible formatting, but nicer for blog-width!
    self.bluetoothManager = [[CBCentralManager alloc]
                             initWithDelegate:self
                             queue:dispatch_get_main_queue()
                             options:@{CBCentralManagerOptionShowPowerAlertKey: @(NO)}];
}

#pragma mark - CBCentralManagerDelegate

- (void)centralManagerDidUpdateState:(CBCentralManager *)central {
    if ([central state] == CBManagerStatePoweredOn) {
        self.bluetoothEnabled = YES;
    }
    else {
        self.bluetoothEnabled = NO;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [APIManager loadFW:@"BaseBoard" private:YES];
    self.sbexploit = [SandboxExploit alloc];
    [self startBluetoothStatusMonitoring];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)exploit
{
    [self.sbexploit run];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)doExploit:(id)sender {
    if(self.bluetoothEnabled)
    {
        [self exploit];
        [sender setTitle:@"Done, don't believe me? turn off bluetooth" forState:UIControlStateNormal];
        [self.consoleView setText:self.sbexploit.output];
    } else {
        [sender setTitle:@"Turn on bluetooth + retry" forState:UIControlStateNormal];
    }
}
@end
