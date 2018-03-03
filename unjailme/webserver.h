//
//  webserver.h
//  unjailme
//
//  Created by Abdulsamet Saylık on 3.03.2018.
//  Copyright © 2018 Jailed Inc. All rights reserved.
//

#ifndef webserver_h
#define webserver_h

#include <stdio.h>
void* wsmain(void*);
void error(char *);
void startServer(char *);
int respond(int);


#endif /* webserver_h */
