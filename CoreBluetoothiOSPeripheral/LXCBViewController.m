#import "LXCBViewController.h"
#import "LXCBAppDelegate.h"
#import "LXCBPeripheralServer.h"

@interface LXCBViewController ()<UIPickerViewDelegate,UIPickerViewDataSource,LXCBPeripheralServerDelegate,CBPeripheralDelegate>
{
    LXCBAppDelegate *delegate;
    NSMutableArray *pickerDataArray;
    BOOL isSelected;
}

@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
@property (nonatomic, strong) LXCBPeripheralServer *peripheral;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIImageView *dropDownImageView;
@property (weak, nonatomic) IBOutlet UIButton *selectButton;

@end

@implementation LXCBViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    delegate = (LXCBAppDelegate *)[UIApplication sharedApplication].delegate;
    
    [self.dropDownImageView setUserInteractionEnabled:YES];
    UITapGestureRecognizer *downArrowTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showPickerTapped)];
    downArrowTapGestureRecognizer.numberOfTapsRequired = 1;
    downArrowTapGestureRecognizer.numberOfTouchesRequired = 1;
    [self.dropDownImageView addGestureRecognizer:downArrowTapGestureRecognizer];
    
    self.pickerView.hidden = true;
    isSelected = false;

//    self.dropDownImageView.contentMode = UIViewContentModeCenter;
//    self.dropDownImageView.bounds = CGRectInset(self.dropDownImageView.frame, 10.0f, 10.0f);
    
    [self.selectButton setTitle:@"Press here" forState:UIControlStateNormal];
    [self.selectButton addTarget:self action:@selector(showPickerTapped) forControlEvents:UIControlEventTouchUpInside];
    self.selectButton.contentMode = UIViewContentModeCenter;
    
    UIImageView *imageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    imageView2.center = CGPointMake(self.selectButton.frame.size.width - 45, self.selectButton.frame.size.height / 2);
    [imageView2 setContentMode:UIViewContentModeScaleAspectFit];
    imageView2.image = [UIImage imageNamed:@"downArrow"];
    [self.selectButton addSubview:imageView2];
    
    pickerDataArray = [[NSMutableArray alloc]initWithObjects:@"150 lbs",@"151 lbs",@"152 lbs",@"153 lbs",@"154 lbs",@"155 lbs",@"156 lbs",@"157 lbs",@"158 lbs",@"159 lbs",@"160 lbs",@"161 lbs",@"162 lbs",@"163 lbs",@"164 lbs",@"165 lbs",@"166 lbs",@"167 lbs",@"168 lbs",@"169 lbs",@"170 lbs", nil];

    [self insertData:@"150 lbs"];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showPickerTapped
{
    if (isSelected == false)
    {
        isSelected = true;
        self.pickerView.hidden = false;
        self.pickerView.showsSelectionIndicator = YES;
        self.pickerView.hidden = NO;
        self.pickerView.delegate = self;
        self.pickerView.dataSource = self;
//        [self.pickerView selectRow:10 inComponent:0 animated:YES];
    }
    else
    {
        isSelected = false;
        self.pickerView.hidden = true;
    }
}

-(void)insertData:(NSString *)stringValue
{
    self.peripheral = [[LXCBPeripheralServer alloc] initWithDelegate:self];
    self.peripheral.serviceName = @"Weight Scale #01";
    self.peripheral.serviceUUID = [CBUUID UUIDWithString:@"0x181D"];
    self.peripheral.characteristicUUID = [CBUUID UUIDWithString:@"0x2A9D"];
    NSData *datastring;
    datastring = [stringValue dataUsingEncoding:NSUTF16StringEncoding];
    
    self.peripheral.value = datastring;
    
    
    [self.peripheral startAdvertising];
}

- (void)centralDidConnect {
  // Pulse the screen blue.
  [UIView animateWithDuration:0.1
                   animations:^{
                     self.view.backgroundColor = [UIColor blueColor];
                   }
                   completion:^(BOOL finished) {
                     [UIView animateWithDuration:0.1
                                      animations:^{
                                        self.view.backgroundColor =
                                            [UIColor colorWithWhite:0.2 alpha:1.0];
                                      }];
                   }];
}

- (void)centralDidDisconnect {
  // Pulse the screen red.
  [UIView animateWithDuration:0.1
                   animations:^{
                     self.view.backgroundColor = [UIColor redColor];
                   }
                   completion:^(BOOL finished) {
                     [UIView animateWithDuration:0.1
                                      animations:^{
                                        self.view.backgroundColor =
                                        [UIColor colorWithWhite:0.2 alpha:1.0];
                                      }];
                   }];
}


#pragma mark - UIPickerView Delegate Methods
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return pickerDataArray.count;
}

-(NSString*) pickerView:(UIPickerView*)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [pickerDataArray objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component;
{
    NSLog(@"Selcted Items: %@",pickerDataArray[row]);
    [self insertData:pickerDataArray[row]];
}

@end
