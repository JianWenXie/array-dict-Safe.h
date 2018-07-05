//
//  NSMutableArray+Safe.m
//  KVOTest
//
//  Created by StriEver on 16/8/1.
//  Copyright © 2016年 StriEver. All rights reserved.
//

#import "NSMutableArray+Safe.h"
#import <objc/runtime.h>
#import "NSObject+ImpChangeTool.h"
@implementation NSMutableArray (Safe)
+ (void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self SwizzlingMethod:@"addObject:" systemClassString:@"__NSArrayM" toSafeMethodString:@"st_addObject:" targetClassString:@"NSMutableArray"];
        
        [self SwizzlingMethod:@"insertObject:atIndex:" systemClassString:@"__NSArrayM" toSafeMethodString:@"st_insertObject:atIndex:" targetClassString:@"NSMutableArray"];
        
        [self SwizzlingMethod:@"removeObjectAtIndex:" systemClassString:@"__NSArrayM" toSafeMethodString:@"st_removeObjectAtIndex:" targetClassString:@"NSMutableArray"];
        
        [self SwizzlingMethod:@"replaceObjectAtIndex:withObject:" systemClassString:@"__NSArrayM" toSafeMethodString:@"st_safe_replaceObjectAtIndex:withObject:" targetClassString:@"NSMutableArray"];
        
        [self SwizzlingMethod:@"removeObjectsAtIndexes:" systemClassString:@"NSMutableArray" toSafeMethodString:@"st_removeObjectsAtIndexes:" targetClassString:@"NSMutableArray"];
        
        [self SwizzlingMethod:@"removeObjectsInRange:" systemClassString:@"NSMutableArray" toSafeMethodString:@"st_removeObjectsInRange:" targetClassString:@"NSMutableArray"];
        
        [self SwizzlingMethod:@"objectAtIndex:" systemClassString:@"__NSArrayM" toSafeMethodString:@"st_objectAtIndex:" targetClassString:@"NSMutableArray"];
        
        
    });
}
- (void)st_addObject:(id)anObject{
    if (!anObject) {
          NSLog(@"👻插入空数据啦");
        return;
    }
    [self st_addObject:anObject];
}
- (void)st_insertObject:(id)anObject atIndex:(NSUInteger)index {
    if (index > [self count]) {
          NSLog(@"👻插入空值了");
        return;
    }
    if (!anObject) {
        return;
    }
    [self st_insertObject:anObject atIndex:index];
}
- (void)st_removeObjectAtIndex:(NSUInteger)index {
    if (index >= [self count]) {
           NSLog(@"👻数组越界了");
        return;
    }
    
    return [self st_removeObjectAtIndex:index];
}
- (void)safe_replaceObjectAtIndex:(NSUInteger)index withObject:(id)anObject {
    if (index >= [self count]) {
        return;
    }
    if (!anObject) {
        return;
    }
    [self safe_replaceObjectAtIndex:index withObject:anObject];
}
- (void)st_removeObjectsAtIndexes:(NSIndexSet *)indexes{
    NSMutableIndexSet * mutableSet = [NSMutableIndexSet indexSet];
    [indexes enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx < [self count ]) {
            [mutableSet addIndex:idx];
        }
    }];
    [self st_removeObjectsAtIndexes:mutableSet];
}
- (void)st_removeObjectsInRange:(NSRange)range{
    //获取最大索引
    if (range.location + range.length - 1 < [self count]) {
        [self st_removeObjectsInRange:range];
        return;
    }
    if (range.location >= [self count]) {
        return;
    }
    NSInteger tempInteger = range.location + range.length - 1;
    while (tempInteger >= [self count]) {
        tempInteger -= 1;
    }
    NSRange tempRange = NSMakeRange(range.location, tempInteger + 1 -range.location);
    [self st_removeObjectsInRange:tempRange];
}
- (id)st_objectAtIndex:(NSUInteger)index{
    //判断数组是否越界
    if (index >= [self count]) {
        return nil;
    }
    return [self st_objectAtIndex:index];
}
@end
