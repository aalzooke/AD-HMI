/*
 *  Copyright (c) 2016, DENSO International America, INC.
 *  All rights reserved.
 *  Code Written by Assam Alzookery.
 *  Redistribution and use in source and binary forms, with or without
 *  modification, are permitted provided that the following conditions are met:
 *
 *  * Redistributions of source code must retain the above copyright notice, this
 *    list of conditions and the following disclaimer.
 *
 *  * Redistributions in binary form must reproduce the above copyright notice,
 *    this list of conditions and the following disclaimer in the documentation
 *    and/or other materials provided with the distribution.
 *
 *  * Neither the name of DENSO International America  nor the names of its
 *    contributors may be used to endorse or promote products derived from
 *    this software without specific prior written permission.
 *
 *  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 *  AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 *  IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 *  DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
 *  FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 *  DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 *  SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
 *  CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
 *  OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
 *  OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */


#import "TabBarController.h"
#import "ViewController1.h"
#import "ViewController2.h"
#import "ViewController3.h"
#import "ViewController4.h"
#import "GCDAsyncSocket.h"
@import Foundation;
@interface TabBarController();

@property (nonatomic,strong) tcpSocketChat *chatSocket;

@end
@implementation TabBarController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tabBar.tintColor = [UIColor redColor];


    // Creating a Swipe Gesture recognizer to be able to swipe from left to right
    //  and from right to left
    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(tappedRightButton:)];
    [swipeLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
    [self.view addGestureRecognizer:swipeLeft];
    
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(tappedLeftButton:)];
    [swipeRight setDirection:UISwipeGestureRecognizerDirectionRight];
    [self.view addGestureRecognizer:swipeRight];
    
  
}
- (IBAction)tappedRightButton:(id)sender
{
    
    
    NSUInteger selectedIndex = [self.tabBarController selectedIndex];
    [self.tabBarController setSelectedIndex:selectedIndex + 1];
    
    CATransition *anim= [CATransition animation];
    [anim setType:kCATransitionPush];
    [anim setSubtype:kCATransitionFromRight];
    [anim setDuration:2];
    [anim setTimingFunction:[CAMediaTimingFunction functionWithName:
                             kCAMediaTimingFunctionEaseIn]];
    [self.tabBarController.view.layer addAnimation:anim forKey:@"fadeTransition"];
    
}


- (IBAction)tappedLeftButton:(id)sender
{
    NSUInteger selectedIndex = [self.tabBarController selectedIndex];
    [self.tabBarController setSelectedIndex:selectedIndex - 1];
    
    CATransition *anim= [CATransition animation];
    [anim setType:kCATransitionPush];
    [anim setSubtype:kCATransitionFromRight];
    [anim setDuration:2];
    [anim setTimingFunction:[CAMediaTimingFunction functionWithName:
                           kCAMediaTimingFunctionEaseIn]];
    [self.tabBarController.view.layer addAnimation:anim forKey:@"fadeTransition"];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    

    // Dispose of any resources that can be recreated.
}
-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    
    self.chatSocket = nil;
    
}

- (void)open {
    
    NSLog(@"Opening streams.");
    
    outputStream = (__bridge NSOutputStream *)writeStream;
    inputStream = (__bridge NSInputStream *)readStream;
    
    [outputStream setDelegate:self];
    [inputStream setDelegate:self];
    
    [outputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [inputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    
    [outputStream open];
    [inputStream open];
    
  //  _connectedLabel.text = @"Connected";
}

- (void)stream:(NSStream *)theStream handleEvent:(NSStreamEvent)streamEvent {
    
    NSLog(@"stream event %lu \n ", (unsigned long)streamEvent);
    
    switch (streamEvent) {
            
        case NSStreamEventOpenCompleted:
            NSLog(@"Stream opened");
      //      _connectedLabel.text = @"Connected";
            break;
        case NSStreamEventHasBytesAvailable:
            
            if (theStream == inputStream)
            {
                uint8_t buffer[1024];
                NSInteger len;
                
                while ([inputStream hasBytesAvailable])
                {
                    len = [inputStream read:buffer maxLength:sizeof(buffer)];
                    if (len > 0)
                    {
                        NSString *output = [[NSString alloc] initWithBytes:buffer length:len encoding:NSASCIIStringEncoding];
                        
                        if (nil != output)
                        {
                            NSLog(@"server said: %@ \n ", output);
                            [self messageReceived:output];
                        }
                    }
                }
            }
            break;
            
        case NSStreamEventHasSpaceAvailable:
            NSLog(@"Stream has space available now");
            break;
            
        case NSStreamEventErrorOccurred:
            NSLog(@"%@\n",[theStream streamError].localizedDescription);
            break;
            
        case NSStreamEventEndEncountered:
            
            [theStream close];
            [theStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
           // _connectedLabel.text = @"Disconnected";
            NSLog(@"close stream");
            break;
        default:
            NSLog(@"Unknown event");
    }
    
}

- (void)close {
    NSLog(@"Closing streams.");
    [inputStream close];
    [outputStream close];
    [inputStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [outputStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [inputStream setDelegate:nil];
    [outputStream setDelegate:nil];
    inputStream = nil;
    outputStream = nil;
    
    //_connectedLabel.text = @"Disconnected";
}
-(void)messageReceived:(NSString *)message{
    
    
    [messages addObject:message];
    
    // _logView.text = message;
    NSLog(@"%@", message);
}


@end
