//
//  APIManager.h
//  XTJailed
//
//  Created by Sem Voigtländer on 13/12/2017.
//  Copyright © 2017 Jailed Inc. All rights reserved.
//

#ifndef APIManager_h
#define APIManager_h
#import <Foundation/Foundation.h>

@interface APIManager : NSObject
+(id)tryCallMethod:(NSString*)ClassName methodName:(NSString*)methodName;
+(NSString*)tryReadProperty:(NSString*)ClassName property:(NSString*)property;
+(NSDictionary*)dumpAllFromFramework:(NSString*)framework privateFW:(BOOL)pfw;
//+(void)dumpClasses;
+(NSArray*)dumpClasses:(NSString*)framework privateFW:(BOOL)pfw;
+(NSArray*)dumpMethods:(Class)class;
+(NSArray*)dumpProperties:(Class)class;
+(BOOL)loadFW:(NSString*)name private:(BOOL)isprivate;

@end
#endif /* APIManager_h */

