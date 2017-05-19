//
//  FrameAddress.c
//  InvocationStackSamplingAgent
//
//  Created by Matteo Sassano on 15.05.17.
//  Copyright © 2017 Matteo Sassano. All rights reserved.
//

#include "FrameAddress.h"

uintptr_t frame_address()
{
    return (uintptr_t)__builtin_frame_address(1);
}
