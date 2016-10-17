//
//  Test-Macros.h
//  CZJUnit
//
//  Created by 陈昭杰 on 2016/10/16.
//  Copyright © 2016年 isExist. All rights reserved.
//

#ifndef Test_Macros_h
#define Test_Macros_h

#define PRINT_DEBUG_INFO 0

#if PRINT_DEBUG_INFO
#define PRINT_CLASS_MATHOD NSLog(@"%@, %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd))
#else
#define PRINT_CLASS_MATHOD
#endif

#endif /* Test_Macros_h */
