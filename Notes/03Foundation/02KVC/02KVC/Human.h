//
//  Human.h
//  02KVC
//
//  Created by dfang on 2020-5-11.
//  Copyright © 2020 east. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Human : NSObject {
    NSString *_name;
    Boolean _isName;
    NSString *name;
    NSString *isName;
    
    // 不能通过kvo访问到name
//    NSString *isname;
}

@end

NS_ASSUME_NONNULL_END
