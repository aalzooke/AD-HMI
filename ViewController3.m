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


#import "ViewController3.h"
#import "GCDAsyncSocket.h"
#import "ViewController1.h"
@import Foundation;

@interface ViewController3 ()
@property (nonatomic,strong) tcpSocketChat *chatSocket;
@property (weak, nonatomic) IBOutlet UIScrollView *ScrollView;

@end

@implementation ViewController3

-(void)viewDidLoad{
    [super viewDidLoad];
    

  //  NSString *ipAddressText = @"192.168.209.174";
    //NSString *portText = @"113";
    
    ViewController1 *secondclass = [[ViewController1 alloc]init];
    _label.text = secondclass.TextField.text;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *loadstring = [defaults objectForKey:@"savedstring"];
    [_label setText:loadstring];
    
    NSLog(@"Setting up connection to %@ : %i", _label.text, 113);
    CFStreamCreatePairWithSocketToHost(kCFAllocatorDefault, (__bridge CFStringRef) _label.text, 113, &readStream, &writeStream);
    
    messages = [[NSMutableArray alloc] init];
    [self open];
    
    _connectedLabel.text = @"Disconnected";

    
    // Creating a Swipe Gesture recognizer to be able to swipe from left to right
    //  and from right to left
    
    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(tappedRightButton:)];
    [swipeLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
    [self.view addGestureRecognizer:swipeLeft];
    
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(tappedLeftButton:)];
    [swipeRight setDirection:UISwipeGestureRecognizerDirectionRight];
    [self.view addGestureRecognizer:swipeRight];
    
    
    // [delegate TCPSOCKET];
    //ViewSwipe *theInstance = [[ViewSwipe alloc]init];
    //[theInstance TCPSOCKET];
}

- (IBAction)tappedRightButton:(id)sender
{
    NSUInteger selectedIndex = [self.tabBarController selectedIndex];
    
    [self.tabBarController setSelectedIndex:selectedIndex + 1];
    
    CATransition *anim= [CATransition animation];
    [anim setType:kCATransitionFade];
    [anim setSubtype:kCATransitionFromRight];
    [anim setDuration:0.30];
    [anim setTimingFunction:[CAMediaTimingFunction functionWithName:
                           kCAMediaTimingFunctionEaseIn]];
    [self.tabBarController.view.layer addAnimation:anim forKey:@"fadeTransition"];
    
  
}

- (IBAction)tappedLeftButton:(id)sender
{
    NSUInteger selectedIndex = [self.tabBarController selectedIndex];
    
    [self.tabBarController setSelectedIndex:selectedIndex - 1];
    
    CATransition *anim= [CATransition animation];
    [anim setType:kCATransitionFade];
    [anim setSubtype:kCATransitionFromLeft];
    [anim setDuration:0.30];
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



-(void)stream:(NSStream *)theStream handleEvent:(NSStreamEvent)streamEvent
{
    NSString *event;
    
    switch (streamEvent)
    {
        case NSStreamEventNone:
            event = @"NSStreamEventNone";
            break;
        case NSStreamEventOpenCompleted:
            event = @"NSStreamEventOpenCompleted";
            _connectedLabel.text = @"Connected";
            
            //[self.connectedButton setBackgroundImage:[UIImage imageNamed:@"Bus.png"] forState:UIControlStateNormal];
            self.tabBarController.tabBar.tintColor = [UIColor blueColor];
            
            break;
        case NSStreamEventHasBytesAvailable:
            event = @"NSStreamEventHasBytesAvailable";
            if (theStream == inputStream)
            {
                uint8_t buffer[1024];
                int len;
                while ([inputStream hasBytesAvailable])
                {
                    len = [inputStream read:buffer maxLength:1024];
                    if (len > 0)
                    {
                        NSMutableString *output = [[NSMutableString alloc] initWithBytes:buffer length:len encoding:NSUTF8StringEncoding];
                        NSLog(@"Received data--------------------%@", output);
                    }
                }
            }
            break;
        case NSStreamEventHasSpaceAvailable:
            event = @"NSStreamEventHasSpaceAvailable";
            break;
        case NSStreamEventErrorOccurred:
            event = @"NSStreamEventErrorOccurred";             
            
            [self close];
            break;
        case NSStreamEventEndEncountered:
            event = @"NSStreamEventEndEncountered";
            self.tabBarController.tabBar.tintColor = [UIColor redColor];
            [self close];
            break;
        default:
            event = @"Unknown";
            break;
    }
    NSLog(@"event------%@",event);
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
    
    _connectedLabel.text = @"Connected";
    //
    //  [self.connectedButton setImage:[UIImage imageNamed:@"Bus.png"] forState:UIControlStateNormal];
    
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
    
    _connectedLabel.text = @"Disconnected";
    self.tabBarController.tabBar.tintColor = [UIColor redColor];
    
    //[self.connectedButton setImage:[UIImage imageNamed:@"r.png"] forState:UIControlStateNormal];
    
}
-(void)messageReceived:(NSString *)message{
    
    
    [messages addObject:message];
    
    // _logView.text = message;
    NSLog(@"%@", message);
}

//Creating IbAction to send data (date, time , and information ) from the client to the server

- (IBAction)button1:(id)sender {
    
    //Getting the current time (system clock)
    NSDate *currentTime = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"dd.MM.YYYY   HH:mm:ss a "];
    NSString *timeString = [formatter stringFromDate:currentTime];
    [outputStream write:[timeString UTF8String]
              maxLength:[timeString lengthOfBytesUsingEncoding:NSUTF8StringEncoding]];
    //Outputting the data to the server (PC device)
    
    
    NSString *response  = @" Slippery Road \n  ";
    NSData *data = [[NSData alloc] initWithData:[response dataUsingEncoding:NSASCIIStringEncoding]];
    [outputStream write:[data bytes] maxLength:[data length]];
}

//Creating IbAction to send data (date, time , and information ) from the client to the server

- (IBAction)button2:(id)sender {
    
    //Getting the current time (system clock)
    NSDate *currentTime = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"dd.MM.YYYY   HH:mm:ss a "];
    NSString *timeString = [formatter stringFromDate:currentTime];
    [outputStream write:[timeString UTF8String]
              maxLength:[timeString lengthOfBytesUsingEncoding:NSUTF8StringEncoding]];
    //Outputting the data to the server (PC device)
    
    NSString *response  = @" Steep Road  \n  ";
    NSData *data = [[NSData alloc] initWithData:[response dataUsingEncoding:NSASCIIStringEncoding]];
    [outputStream write:[data bytes] maxLength:[data length]];
}

//Creating IbAction to send data (date, time , and information ) from the client to the server

- (IBAction)button3:(id)sender {
    
    //Getting the current time (system clock)
    NSDate *currentTime = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"dd.MM.YYYY   HH:mm:ss a "];
    NSString *timeString = [formatter stringFromDate:currentTime];
    [outputStream write:[timeString UTF8String]
              maxLength:[timeString lengthOfBytesUsingEncoding:NSUTF8StringEncoding]];
    //Outputting the data to the server (PC device)
    
    
    NSString *response  = @" Highway-Rail Crossing \n  ";
    NSData *data = [[NSData alloc] initWithData:[response dataUsingEncoding:NSASCIIStringEncoding]];
    [outputStream write:[data bytes] maxLength:[data length]];
}
//Creating IbAction to send data (date, time , and information ) from the client to the server


- (IBAction)button4:(id)sender {
    
    //Getting the current time (system clock)
    NSDate *currentTime = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"dd.MM.YYYY   HH:mm:ss a "];
    NSString *timeString = [formatter stringFromDate:currentTime];
    [outputStream write:[timeString UTF8String]
              maxLength:[timeString lengthOfBytesUsingEncoding:NSUTF8StringEncoding]];
    //Outputting the data to the server (PC device)
    
    NSString *response  = @" Bump in The Road \n  ";
    NSData *data = [[NSData alloc] initWithData:[response dataUsingEncoding:NSASCIIStringEncoding]];
    [outputStream write:[data bytes] maxLength:[data length]];
}
//Creating IbAction to send data (date, time , and information ) from the client to the server


- (IBAction)button5:(id)sender {
    
    //Getting the current time (system clock)
    NSDate *currentTime = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"dd.MM.YYYY   HH:mm:ss a "];
    NSString *timeString = [formatter stringFromDate:currentTime];
    [outputStream write:[timeString UTF8String]
              maxLength:[timeString lengthOfBytesUsingEncoding:NSUTF8StringEncoding]];
    //Outputting the data to the server (PC device)
    
    NSString *response  = @" School Crossing \n  ";
    NSData *data = [[NSData alloc] initWithData:[response dataUsingEncoding:NSASCIIStringEncoding]];
    [outputStream write:[data bytes] maxLength:[data length]];
}
//Creating IbAction to send data (date, time , and information ) from the client to the server

- (IBAction)button6:(id)sender {
    
    //Getting the current time (system clock)
    NSDate *currentTime = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"dd.MM.YYYY   HH:mm:ss a "];
    NSString *timeString = [formatter stringFromDate:currentTime];
    [outputStream write:[timeString UTF8String]
              maxLength:[timeString lengthOfBytesUsingEncoding:NSUTF8StringEncoding]];
    //Outputting the data to the server (PC device)
    
    NSString *response  = @" Detour Ahead \n  ";
    NSData *data = [[NSData alloc] initWithData:[response dataUsingEncoding:NSASCIIStringEncoding]];
    [outputStream write:[data bytes] maxLength:[data length]];
}
//Creating IbAction to send data (date, time , and information ) from the client to the server

- (IBAction)button7:(id)sender {
    
    //Getting the current time (system clock)
    NSDate *currentTime = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"dd.MM.YYYY   HH:mm:ss a "];
    NSString *timeString = [formatter stringFromDate:currentTime];
    [outputStream write:[timeString UTF8String]
              maxLength:[timeString lengthOfBytesUsingEncoding:NSUTF8StringEncoding]];
    //Outputting the data to the server (PC device)
    
    NSString *response  = @" Washboard Road \n  ";
    NSData *data = [[NSData alloc] initWithData:[response dataUsingEncoding:NSASCIIStringEncoding]];
    [outputStream write:[data bytes] maxLength:[data length]];
}
//Creating IbAction to send data (date, time , and information ) from the client to the server

- (IBAction)button8:(id)sender {
    
    
    //Getting the current time (system clock)
    NSDate *currentTime = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"dd.MM.YYYY   HH:mm:ss a "];
    NSString *timeString = [formatter stringFromDate:currentTime];
    [outputStream write:[timeString UTF8String]
              maxLength:[timeString lengthOfBytesUsingEncoding:NSUTF8StringEncoding]];
    //Outputting the data to the server (PC device)
    
    NSString *response  = @" Drain Road \n  ";
    NSData *data = [[NSData alloc] initWithData:[response dataUsingEncoding:NSASCIIStringEncoding]];
    [outputStream write:[data bytes] maxLength:[data length]];
}
//Creating IbAction to send data (date, time , and information ) from the client to the server

- (IBAction)button9:(id)sender {
    
    //Getting the current time (system clock)
    NSDate *currentTime = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"dd.MM.YYYY   HH:mm:ss a "];
    NSString *timeString = [formatter stringFromDate:currentTime];
    [outputStream write:[timeString UTF8String]
              maxLength:[timeString lengthOfBytesUsingEncoding:NSUTF8StringEncoding]];
    //Outputting the data to the server (PC device)
    
    NSString *response  = @" Pothole \n  ";
    NSData *data = [[NSData alloc] initWithData:[response dataUsingEncoding:NSASCIIStringEncoding]];
    [outputStream write:[data bytes] maxLength:[data length]];
}
//Creating IbAction to send data (date, time , and information ) from the client to the server

- (IBAction)button10:(id)sender {
    
    //Getting the current time (system clock)
    NSDate *currentTime = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"dd.MM.YYYY   HH:mm:ss a "];
    NSString *timeString = [formatter stringFromDate:currentTime];
    [outputStream write:[timeString UTF8String]
              maxLength:[timeString lengthOfBytesUsingEncoding:NSUTF8StringEncoding]];
    //Outputting the data to the server (PC device)
    
    NSString *response  = @" Water over Road \n  ";
    NSData *data = [[NSData alloc] initWithData:[response dataUsingEncoding:NSASCIIStringEncoding]];
    [outputStream write:[data bytes] maxLength:[data length]];
}
//Creating IbAction to send data (date, time , and information ) from the client to the server

- (IBAction)button11:(id)sender {
    
    //Getting the current time (system clock)
    NSDate *currentTime = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"dd.MM.YYYY   HH:mm:ss a "];
    NSString *timeString = [formatter stringFromDate:currentTime];
    [outputStream write:[timeString UTF8String]
              maxLength:[timeString lengthOfBytesUsingEncoding:NSUTF8StringEncoding]];
    //Outputting the data to the server (PC device)
    
    NSString *response  = @" Ice on Bridges \n  ";
    NSData *data = [[NSData alloc] initWithData:[response dataUsingEncoding:NSASCIIStringEncoding]];
    [outputStream write:[data bytes] maxLength:[data length]];
}
//Creating IbAction to send data (date, time , and information ) from the client to the server

- (IBAction)button12:(id)sender {
    
    
    //Getting the current time (system clock)
    NSDate *currentTime = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"dd.MM.YYYY   HH:mm:ss a "];
    NSString *timeString = [formatter stringFromDate:currentTime];
    [outputStream write:[timeString UTF8String]
              maxLength:[timeString lengthOfBytesUsingEncoding:NSUTF8StringEncoding]];
    //Outputting the data to the server (PC device)
    
    NSString *response  = @" Road Closed \n  ";
    NSData *data = [[NSData alloc] initWithData:[response dataUsingEncoding:NSASCIIStringEncoding]];
    [outputStream write:[data bytes] maxLength:[data length]];
}
//Creating IbAction to send data (date, time , and information ) from the client to the server

- (IBAction)button13:(id)sender {
    
    //Getting the current time (system clock)
    NSDate *currentTime = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"dd.MM.YYYY   HH:mm:ss a "];
    NSString *timeString = [formatter stringFromDate:currentTime];
    [outputStream write:[timeString UTF8String]
              maxLength:[timeString lengthOfBytesUsingEncoding:NSUTF8StringEncoding]];
    //Outputting the data to the server (PC device)
    
    NSString *response  = @" Deer Crossing  \n  ";
    NSData *data = [[NSData alloc] initWithData:[response dataUsingEncoding:NSASCIIStringEncoding]];
    [outputStream write:[data bytes] maxLength:[data length]];
}
//Creating IbAction to send data (date, time , and information ) from the client to the server

- (IBAction)button14:(id)sender {
    
    //Getting the current time (system clock)
    NSDate *currentTime = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"dd.MM.YYYY   HH:mm:ss a "];
    NSString *timeString = [formatter stringFromDate:currentTime];
    [outputStream write:[timeString UTF8String]
              maxLength:[timeString lengthOfBytesUsingEncoding:NSUTF8StringEncoding]];
    //Outputting the data to the server (PC device)
    
    NSString *response  = @" Work Ahead  \n  ";
    NSData *data = [[NSData alloc] initWithData:[response dataUsingEncoding:NSASCIIStringEncoding]];
    [outputStream write:[data bytes] maxLength:[data length]];
}
//Creating IbAction to send data (date, time , and information ) from the client to the server

- (IBAction)button15:(id)sender {
    
    //Getting the current time (system clock)
    NSDate *currentTime = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"dd.MM.YYYY   HH:mm:ss a "];
    NSString *timeString = [formatter stringFromDate:currentTime];
    [outputStream write:[timeString UTF8String]
              maxLength:[timeString lengthOfBytesUsingEncoding:NSUTF8StringEncoding]];
    //Outputting the data to the server (PC device)
    
    NSString *response  = @" Pedestrian Crossing \n  ";
    NSData *data = [[NSData alloc] initWithData:[response dataUsingEncoding:NSASCIIStringEncoding]];
    [outputStream write:[data bytes] maxLength:[data length]];
}
//Creating IbAction to send data (date, time , and information ) from the client to the server

- (IBAction)button16:(id)sender {
    
    //Getting the current time (system clock)
    NSDate *currentTime = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"dd.MM.YYYY   HH:mm:ss a "];
    NSString *timeString = [formatter stringFromDate:currentTime];
    [outputStream write:[timeString UTF8String]
              maxLength:[timeString lengthOfBytesUsingEncoding:NSUTF8StringEncoding]];
    //Outputting the data to the server (PC device)
    
    NSString *response  = @" Dead End  \n  ";
    NSData *data = [[NSData alloc] initWithData:[response dataUsingEncoding:NSASCIIStringEncoding]];
    [outputStream write:[data bytes] maxLength:[data length]];
}
@end
