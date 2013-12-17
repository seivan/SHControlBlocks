//
//  ExampleTests.m
//  ExampleTests
//
//  Created by Seivan Heidari on 7/27/13.
//  Copyright (c) 2013 Seivan Heidari. All rights reserved.
//



#import "SHControlBlocksSuper.h"



@implementation SHControlBlocksSuper

-(void)setUp; {
  self.vc = UIViewController.new;
  [UIApplication sharedApplication].keyWindow.rootViewController = self.vc;
  [[UIApplication sharedApplication].keyWindow makeKeyAndVisible];
  self.button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
  self.button.frame = CGRectMake(50, 50, 100, 100);
  self.titleButton = @"Button Title";
  [self.button setTitle:self.titleButton forState:UIControlStateNormal];
  [self.vc.view addSubview:self.button];
  self.block = ^(UIControl * sender) {};
}

@end

