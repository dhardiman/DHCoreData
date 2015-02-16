//
//  DHWeakSelf.h
//  DHFoundation
//
//  Created by David Hardiman on 16/07/2013.
//  Copyright (c) 2013 David Hardiman. All rights reserved.
//

#ifndef DHFoundation_DHWeakSelf_h
#define DHFoundation_DHWeakSelf_h

#define DHWeak(x) __weak __typeof(x) _dontusemeim_weak_##x = x
#define DHStrong(x) __strong __typeof(x) x = _dontusemeim_weak_##x

#endif
