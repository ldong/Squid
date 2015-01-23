//
//  TextViewController.m
//  Squid
//
//  Created by Lin Dong on 1/21/15.
//  Copyright (c) 2015 Lin Dong. All rights reserved.
//

#import "TextViewController.h"
#import <FontasticIcons.h>
#import "DDFileReader.h"
#import "UILabel+FormattedText.h"
#import "AppDelegate.h"

@interface TextViewController ()
// MUST
@property (strong, nonatomic) UIButton *playButton;
@property (strong, nonatomic) UISlider *speedSlider;
@property (strong, nonatomic) UISlider *fontSlider;
@property (strong, nonatomic) UILabel *speedLabel;
@property (strong, nonatomic) UILabel *textLabel;
@property(strong, nonatomic) NSTimer *timer;
@property(strong, nonatomic) NSDate *startTime;
@property(strong, nonatomic) UILabel *timerLabel;
@property(strong, nonatomic) NSString *text;
@property(strong, nonatomic) NSMutableArray *texts;
@property (strong, atomic) NSNumber *sleepInterval;
// TODO
@property(strong, nonatomic) UIButton *forwardButton;
@property(strong, nonatomic) UIButton *backwardButton;

@end



@implementation TextViewController

#define PLAYTAG  1101
#define STOPTAG  1102

BOOL isPlayToggle = NO;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initViews];
  self.sleepInterval = @1.0;
  
  self.text = @"Speed reading is the art of silencing subvocalization. Most readers have an average reading speed of 200 wpm, which is about as fast as they can read a passage out loud. This is no coincidence. It is their inner voice that paces through the text that keeps them from achieving higher reading speeds. They can only read as fast as they can speak because that's the way they were taught to read, through reading systems like Hooked on Phonics.  However, it is entirely possible to read at a much greater speed, with much better reading comprehension, through silencing this inner voice. The solution is simple - absorb reading material faster than that inner voice can keep up.  In the real world, this is achieved through methods like reading passages using a finger to point your way. You read through a page of text by following your finger line by line at a speed faster than you can normally read. This works because the eye is very good at tracking movement. Even if at this point full reading comprehension is lost, it's exactly this method of training that will allow you to read faster.  With the aid of software like Spreeder, it's much easier to achieve this same result with much less effort. Load a passage of text (like this one), and the software will pace through the text at a predefined speed that you can adjust as your reading comprehension increases.  To train to read faster, you must first find your base rate. Your base rate is the speed that you can read a passage of text with full comprehension. We've defaulted to 300 wpm, showing one word at a time, which is about the average that works best for our users. Now, read that passage using spreeder at that base rate.  After you've finished, double that speed by going to the Settings and changing the Words Per Minute value. Reread the passage. You shouldn't expect to understand everything - in fact, more likely than not you'll only catch a couple words here and there. If you have high comprehension, that probably means that you need to set your base rate higher and rerun this test again. You should be straining to keep up with the speed of the words flashing by. This speed should be faster than your inner voice can 'read'.  Now, reread the passage again at your base rate. It should feel a lot slower (if not, try running the speed test again). Now try moving up to a little past your base rate (for example, 400 wpm), and see how much you can comprehend at that speed.  That's basically it - constantly read passages at a rate faster than you can keep up, and keep pushing the edge of what you're capable of. You'll find that when you drop down to lower speeds, you'll be able to pick up much more than you would have thought possible.  One other setting that's worth mentioning in this introduction is the chunk size, which is the number of words that are flashed at each interval on the screen. When you read aloud, you can only say one word at a time. This limit does not apply to reading - with practice, you can read multiple words at a time once your inner voice subsides. As your reading speed increases, this is the best way to achieve reading speeds of 1000+ wpm. Start small with 2 word chunk sizes, but as you increase you'll find that 3, 4, or even higher chunk sizes are possible.  Good luck!";
  

    self.texts = [NSMutableArray arrayWithArray:[self.text componentsSeparatedByString:@" "]];
}

-(id) init{
  if (!(self = [super init])){
    return nil;
  }
  
  return self;
}

-(void) initViews{
  [self initBackground];
  [self initPlayButton];
  [self initSpeedSlider];
  [self initSpeedLabel];
  [self initTextLabel];
  [self initFontSlider];
  [self initTimerLabel];
  [self initTimer:1];
}

-(void) initTimerLabel{
  double width = [[UIScreen mainScreen] bounds].size.height/2 * 1.2;
  double height = 20;
  double x = 100;
  double y = 60;
  UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(x, y, width, height)];
  label.text = [NSString stringWithFormat:@"%@: %@", @"Timer", @" here"];
  [self setTimerLabel:label];
  [[self view] addSubview:label];
 
}

-(void) initTimer: (int) interval{
  self.startTime = [NSDate date];
  self.timerLabel.text = @"00:00";
  [self.timer invalidate];
  self.timer = [NSTimer scheduledTimerWithTimeInterval:interval target:self selector:@selector(updateTimer:) userInfo:nil repeats:YES];
}


-(void)updateTimer:(id) sender{
  NSDate *currentTime = [NSDate date];
  NSTimeInterval elapsedTime = [currentTime timeIntervalSinceDate:self.startTime];
  
  NSDate *lastUpdate = [[NSDate alloc] initWithTimeIntervalSince1970:elapsedTime];
  
  NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
  [dateFormatter setDateFormat:@"mm:ss"];
  
  [self.timerLabel setText:[dateFormatter stringFromDate:lastUpdate]];
//  NSLog(@"Called");
}


-(void) initTextLabel{
  double width = [[UIScreen mainScreen] bounds].size.width - 30;
  double height = 100;
  double x = 15;
  double y = 100+30;
  UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(x, y, width, height)];

  label.text = @"Squid!!";
  label.font=[UIFont fontWithName:@"Helvetica" size:30];
  [self setTextLabel:label];
  [self.textLabel setTextAlignment:NSTextAlignmentCenter];
  [[self view] addSubview:label];
}


-(void) initSpeedLabel{
  double width = [[UIScreen mainScreen] bounds].size.height/2 * 1.2;
  double height = 20;
  double x = 100;
  double y = 100;
  UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(x, y, width, height)];
  label.text = [NSString stringWithFormat:@"%@ %@", @"100", @" wpm"];
  [self setSpeedLabel:label];
  [[self view] addSubview:label];
}


-(void) initSpeedSlider{
  double width = [[UIScreen mainScreen] bounds].size.width * 0.55;
  double height = 20;
  double x = self.playButton.center.x - width /2;
  double y = self.playButton.center.y + self.playButton.frame.size.height + height/2;
  UISlider *slider = [[UISlider alloc] initWithFrame: CGRectMake(x, y, width, height)];
  slider.value = 80;
  slider.minimumValue = 60;
  slider.maximumValue = 1000;
  [self setSpeedSlider:slider];
  [slider addTarget:self
             action:@selector(getValueFromSlider:)
   forControlEvents:UIControlEventValueChanged];
  [[self view] addSubview:slider];
}

-(void) getValueFromSlider: (UISlider*) slider{
  self.speedLabel.text = [NSString stringWithFormat:@"%d wpm", (int)slider.value];
  NSLog(@"slider value %f", slider.value);
  self.sleepInterval = [NSNumber numberWithFloat:(double)(60.0/(slider.value))];
  NSLog(@"sleepInterval: %@", self.sleepInterval);
}

-(void) initFontSlider{
  double width = [[UIScreen mainScreen] bounds].size.width * 0.55;
  double height = 20;
  double x = self.speedSlider.center.x - width /2;
  double y = self.speedSlider.center.y + self.playButton.frame.size.height + height/2;
  UISlider *slider = [[UISlider alloc] initWithFrame: CGRectMake(x, y, width, height)];
  slider.value = 26;
  slider.minimumValue = 36;
  slider.maximumValue = 46;
  [self setFontSlider:slider];
  [slider addTarget:self
             action:@selector(changeFont:)
   forControlEvents:UIControlEventValueChanged];
  [[self view] addSubview:slider];
}

-(void) changeFont: (UISlider*) slider{
  self.textLabel.font = [UIFont fontWithName:@"Helvetica" size: ((int)slider.value)];
}

-(void) initPlayButton{
  double width = 45;
  double height = width;
  double x = [[UIScreen mainScreen] bounds].size.width/2 - width/2;
  double y = [[UIScreen mainScreen] bounds].size.height/2 - height/2;
  UIButton *button = [[UIButton alloc] initWithFrame: CGRectMake(x, y, width, height)];
  FIIcon *icon = [FIEntypoIcon playIcon];
  FIIconLayer *layer = [FIIconLayer new];
  layer.icon = icon;
  layer.frame = button.bounds;
  layer.iconColor = [UIColor blackColor];
  [button.layer addSublayer:layer];
  
  [button addTarget:self
             action:@selector(togglePLayButton:)
   forControlEvents:UIControlEventTouchUpInside];
  [self setPlayButton:button];
  [[self view] addSubview:button];
}

-(void) togglePLayButton:(UIButton*) button {
  FIIcon *icon;
  if(!isPlayToggle){
    icon = [FIEntypoIcon stopIcon];
    isPlayToggle = YES;
    NSLog(@"YES");
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSString *filePath = [appDelegate.url path];
    if(filePath){
      [self readFromFile:filePath];
    } else {
      [self updateTextLabel:self.texts];
    }
  } else {
    icon = [FIEntypoIcon playIcon];
    isPlayToggle = NO;
    NSLog(@"NO");
    self.textLabel.text = @"HALT";
  }
  
  FIIconLayer *layer = [FIIconLayer new];
  layer.icon = icon;
  layer.frame = self.playButton.bounds;
  layer.iconColor = [UIColor blackColor];
  
  NSLog(@"%ld  ---", button.layer.sublayers.count);
  [button.layer setSublayers:@[layer]];
}

-(void) initBackground {
  self.view.backgroundColor = [UIColor colorWithRed:1.000 green:0.750 blue:0.361 alpha:1.000];
//  self.view.backgroundColor = [UIColor clearColor];
}

-(NSArray *)splitLine:(NSString*)line{
  NSArray *myWords = [line componentsSeparatedByString:@" "];
  NSArray *array = [line componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
  return array;
}

-(void) readFromFile: (NSString*) filePath {
  DDFileReader *reader = [[DDFileReader alloc] initWithFilePath:filePath];
  NSString * line = nil;
  
  [reader enumerateLinesUsingBlock:^(NSString * line, BOOL * stop) {
    NSLog(@"read line: %@", line);
    dispatch_async(dispatch_get_main_queue(), ^{ // 2
      [self updateTextLabel:[self splitLine:line]];
    });
  }];
}

-(void) updateTextLabel: (NSMutableArray*) texts{
  NSLog(@"updateTextLabel");

  if(texts){
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{ // 1
      for(int i=0; i<texts.count;){
        if(isPlayToggle){
          dispatch_async(dispatch_get_main_queue(), ^{ // 2
            if(texts[i]){
              self.textLabel.text = texts[i]; // 3
              //              [self.textLabel setTextAlignment:NSTextAlignmentLeft];
              [self.textLabel setTextAlignment:NSTextAlignmentCenter];
              int length = [(NSString*)(texts[i]) length];
              [self.textLabel setTextColor:[UIColor redColor]
                                     range:NSMakeRange(length/2, length/2?1:0)];
            }
          });
          NSLog(@"dispatch ---- sleepInterval: %@", self.sleepInterval);
          ++i;
        }
          usleep([self.sleepInterval floatValue] * 1000000);
      }
    });
  }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Force not to rotate
- (BOOL)shouldAutorotate{
  return NO;
}

/*
- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
  NSLog(@"Called");
  if (toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft || toInterfaceOrientation == UIInterfaceOrientationLandscapeRight) {
    // change positions etc of any UIViews for Landscape

  } else {
    // change position etc for Portait
  }
}
 */

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
