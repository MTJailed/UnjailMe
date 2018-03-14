//
//  endianhelper.c
//  unjailme
//
//  Created by Sem Voigtländer on 13/03/2018.
//  Copyright © 2018 Jailed Inc. All rights reserved.
//

#include "endianhelper.h"
int64_t swap_int64( int64_t val )
{
    val = ((val << 8) & 0xFF00FF00FF00FF00ULL ) | ((val >> 8) & 0x00FF00FF00FF00FFULL );
    val = ((val << 16) & 0xFFFF0000FFFF0000ULL ) | ((val >> 16) & 0x0000FFFF0000FFFFULL );
    return (val << 32) | ((val >> 32) & 0xFFFFFFFFULL);
}

uint64_t swap_uint64( uint64_t val )
{
    val = ((val << 8) & 0xFF00FF00FF00FF00ULL ) | ((val >> 8) & 0x00FF00FF00FF00FFULL );
    val = ((val << 16) & 0xFFFF0000FFFF0000ULL ) | ((val >> 16) & 0x0000FFFF0000FFFFULL );
    return (val << 32) | (val >> 32);
}
