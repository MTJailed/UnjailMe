//
//  machhelper.h
//  unjailme
//
//  Created by Sem Voigtländer on 13/03/2018.
//  Copyright © 2018 Jailed Inc. All rights reserved.
//

#ifndef machhelper_h
#define machhelper_h
typedef unsigned int mach_msg_return_value;
extern kern_return_t bootstrap_look_up(mach_port_t bs, const char *service_name, mach_port_t *service);
#endif /* machhelper_h */
