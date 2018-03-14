//
//  log.h
//  unjailme
//
//  Created by Sem Voigtländer on 13/03/2018.
//  Copyright © 2018 Jailed Inc. All rights reserved.
//

#ifndef log_h
#define log_h
#define NSLog(str...) _output = [_output stringByAppendingString:[NSString stringWithFormat:str]]; printf("%s",[[NSString stringWithFormat:str] UTF8String]);
#endif /* log_h */
