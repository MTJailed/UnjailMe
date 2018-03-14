//
//  devicehelper.h
//  unjailme
//
//  Created by Sem Voigtländer on 13/03/2018.
//  Copyright © 2018 Jailed Inc. All rights reserved.
//

#ifndef devicehelpers_h
#define devicehelpers_h
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)
#define CPU_IS_64BIT() ((UINT_MAX) == 0xffffffffu)
#endif /* devicehelpers_h */
