//
//  ViewController.m
//  AD-HMI
//
//  Created by assam alzookery on 3/16/16.
//  Copyright © 2016 assam alzookery. All rights reserved.
//

#import "ViewController.h"
#import "GCDAsyncSocket.h"
#import "IntersectionView.h"

//#import "IntersectionView.m"
@import Foundation;

@interface ViewController ()
@property (nonatomic,strong) tcpSocketChat *chatSocket;

@end

@implementation ViewController
@synthesize chatSocket =_chatSocket;


- (void)viewDidLoad {
  [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
  
    NSString *ipAddressText = @"192.168.211.62";
    NSString *portText = @"123";
    
    NSLog(@"Setting up connection to %@ : %i", ipAddressText, [portText intValue]);
    CFStreamCreatePairWithSocketToHost(kCFAllocatorDefault, (__bridge CFStringRef) ipAddressText, [portText intValue], &readStream, &writeStream);
    
    messages = [[NSMutableArray alloc] init];
    [self open];
    
   // self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"image.jpg"]];
    
    // register for keyboard notifications
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
   
}



- (void)stream:(NSStream *)theStream handleEvent:(NSStreamEvent)streamEvent {
    
    NSLog(@"stream event %lu \n ", streamEvent);
    
    switch (streamEvent) {
            
        case NSStreamEventOpenCompleted:
            NSLog(@"Stream opened");
            _connectedLabel.text = @"Connected";
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
            _connectedLabel.text = @"Disconnected";
            NSLog(@"close stream");
            break;
        default:
            NSLog(@"Unknown event");
    }
    
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
}


- (IBAction)sunny:(id)sender {
    
    
    NSString *response1  = @"Sunny !!  \n  ";
    NSData *data1 = [[NSData alloc] initWithData:[response1 dataUsingEncoding:NSASCIIStringEncoding]];
    [outputStream write:[data1 bytes] maxLength:[data1 length]];
}

- (IBAction)Cloudy:(id)sender {
    
    NSString *response2  = @"Cloudy \n  ";
    NSData *data2 = [[NSData alloc] initWithData:[response2 dataUsingEncoding:NSASCIIStringEncoding]];
    [outputStream write:[data2 bytes] maxLength:[data2 length]];
}

- (IBAction)sunny_showers:(id)sender {
    NSString *response3  = @"Sunny/Showers\n  ";
    NSData *data3 = [[NSData alloc] initWithData:[response3 dataUsingEncoding:NSASCIIStringEncoding]];
    [outputStream write:[data3 bytes] maxLength:[data3 length]];
}

- (IBAction)Rainy:(id)sender {
    NSString *response4  = @"Rainy \n  ";
    NSData *data4 = [[NSData alloc] initWithData:[response4 dataUsingEncoding:NSASCIIStringEncoding]];
    [outputStream write:[data4 bytes] maxLength:[data4 length]];
}

- (IBAction)snow:(id)sender {
    NSString *response5  = @"Snow \n  ";
    NSData *data5 = [[NSData alloc] initWithData:[response5 dataUsingEncoding:NSASCIIStringEncoding]];
    [outputStream write:[data5 bytes] maxLength:[data5 length]];
}

- (IBAction)Night:(id)sender {
    NSString *response6  = @"Night \n  ";
    NSData *data6 = [[NSData alloc] initWithData:[response6 dataUsingEncoding:NSASCIIStringEncoding]];
    [outputStream write:[data6 bytes] maxLength:[data6 length]];
}

- (IBAction)connectToServer:(id)sender {
    
    NSString *ipAddressText = @"192.168.211.62";
    NSString *portText = @"123";
    
    NSLog(@"Setting up connection to %@ : %i", ipAddressText, [portText intValue]);
    CFStreamCreatePairWithSocketToHost(kCFAllocatorDefault, (__bridge CFStringRef) ipAddressText, [portText intValue], &readStream, &writeStream);
    
    messages = [[NSMutableArray alloc] init];
    
    [self open];
   
}
-(void)messageReceived:(NSString *)message{
    
    [messages addObject:message];
    
    //_logView.text = message;
    NSLog(@"%@", message);
}


@end
