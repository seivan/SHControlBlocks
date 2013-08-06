//
//  ExampleTests.m
//  ExampleTests
//
//  Created by Seivan Heidari on 7/27/13.
//  Copyright (c) 2013 Seivan Heidari. All rights reserved.
//


#import "SHControlBlocksSuper.h"

@interface SHControlBlocksCallbacks : SHControlBlocksSuper
@property(nonatomic,assign) NSInteger isAsserted;
@end




@implementation SHControlBlocksCallbacks

#pragma mark - Add block
-(void)testSH_addControlEvents_withBlock; {
  __block BOOL didAssert = NO;
  [self.button SH_addControlEvents:UIControlEventTouchUpInside withBlock:^(UIControl *sender) {
    STAssertEqualObjects(self.button, sender, nil);
    didAssert = YES;
  }];
  
  self.block = [self.button SH_blocksForControlEvents:UIControlEventTouchUpInside].SH_toArray.SH_firstObject;
  self.block(self.button);
  STAssertTrue(didAssert, nil);
  
  
}

-(void)testSH_addControlEventTouchUpInsideWithBlock_theBlock; {
  __block BOOL didAssert = NO;
  [self.button SH_addControlEventTouchUpInsideWithBlock:^(UIControl *sender) {
    STAssertEqualObjects(self.button, sender, nil);
    didAssert = YES;
  }];
  
  self.block = [self.button SH_blocksForControlEvents:UIControlEventTouchUpInside].SH_toArray.SH_firstObject;
  self.block(self.button);

  STAssertTrue(didAssert, nil);
  
}


#pragma mark - Helpers
-(void)testSH_blocksForControlEvents; {
  __block BOOL didAssertFirstBlock  = NO;
  __block BOOL didAssertSecondBlock = NO;
  UIControlEvents event = UIControlEventTouchUpInside;
  [self.button SH_addControlEventTouchUpInsideWithBlock:^(UIControl *sender) {
    STAssertEqualObjects(self.button, sender, nil);
    didAssertFirstBlock = YES;
  }];
  [self.button SH_addControlEvents:event withBlock:^(UIControl *sender) {
    STAssertEqualObjects(self.button, sender, nil);
    didAssertSecondBlock = YES;
  }];
  NSArray * blocks = [self.button SH_blocksForControlEvents:event].SH_toArray;
  
  SHControlEventBlock firstBlock = blocks.SH_firstObject;
  firstBlock(self.button);

  SHControlEventBlock secondBlock = blocks.SH_lastObject;
  secondBlock(self.button);
  
  STAssertTrue(didAssertFirstBlock, nil);
  STAssertTrue(didAssertSecondBlock, nil);
    
}

-(void)testSH_controlEventsForBlock; {
  __block BOOL didAssertFirstBlock  = NO;
  __block BOOL didAssertSecondBlock = NO;
  UIControlEvents event = UIControlEventTouchDragExit;
  SHControlEventBlock firstBlock = ^(UIControl *sender) {
    STAssertEqualObjects(self.button, sender, nil);
    didAssertFirstBlock = YES;

  };
  [self.button SH_addControlEventTouchUpInsideWithBlock:firstBlock];
  
  SHControlEventBlock secondBlock = ^(UIControl *sender) {
    STAssertEqualObjects(self.button, sender, nil);
    didAssertSecondBlock = YES;

  };
  
  [self.button SH_addControlEvents:event withBlock:secondBlock];
  
  UIControlEvents firstEvent  = ((NSNumber *)[self.button
                                                SH_controlEventsForBlock:firstBlock].SH_toArray.SH_firstObject).unsignedIntegerValue;
  UIControlEvents secondEvent = ((NSNumber *)[self.button
                                                SH_controlEventsForBlock:secondBlock].SH_toArray.SH_firstObject).unsignedIntegerValue;
  
  [self.button sendActionsForControlEvents:firstEvent];
  [self.button sendActionsForControlEvents:secondEvent];
  
  STAssertTrue(didAssertFirstBlock, nil);
  STAssertTrue(didAssertSecondBlock, nil);

}


@end
