class RootViewController < UIViewController

  def set_default_time_zone
    @defaultTimeZoneLabel.text = NSTimeZone.localTimeZone.name
  end

  def set_default_time
    defaultTimeZone = NSTimeZone.timeZoneWithName(@defaultTimeZoneLabel.text)
    formatter = NSDateFormatter.alloc.init
    formatter.setDateFormat("HH:mm")
    formatter.setTimeZone(defaultTimeZone)
    dateFormat = formatter.stringFromDate(NSDate.date)
    @defaultTimeLabel.text = "UTC" + (NSTimeZone.localTimeZone.secondsFromGMT/3600).to_s + dateFormat
  end

  def set_Convert_Time
    convertZone = NSTimeZone.timeZoneWithName(@converTimeZoneLabel.text)
    formatter = NSDateFormatter.alloc.init
    formatter.setDateFormat('HH:mm')
    formatter.setTimeZone(convertZone)
    dateFormat = formatter.stringFromDate(NSDate.date)
    @convertDate = formatter.dateFromString(dateFormat)
    @convertTimeLabel.text = "UTC "+(convertZone.secondsFromGMT/3600).to_s + "  "+ dateFormat
  end

  def present_local_zone_picker(sender)
    button = sender
    @zonePicker.frame = CGRectMake(0,244,320,216)
    @currentZoneLabel = @defaultTimeZoneLabel

    if @zonePicker.isHidden
      @zonePicker.hidden = false
      button.setTitle("Choose" , forState:UIControlStateNormal)
    else
      @zonePicker.hidden = true
      button.setTitle("Select ", forState:UIControlStateNormal)
      set_default_time
    end
  end

  def present_convert_zone_picker(sender)
    button = sender
    @zonePicker.frame = CGRectMake(0,0, 320, 216)
    @currentZoneLabel = @converTimeZoneLabel

    if @zonePicker.isHidden
      @zonePicker.hidden = false
      button.setTitle("Choose",forState:UIControlStateNormal)
    else
      @zonePicker.hidden = true
      button.setTitle("Select",forState:UIControlStateNormal)
      set_Convert_Time
    end
  end

  # UIPicker View Controller DataSource
  def numberOfComponentsInPickerView(pickerView)
    1
  end

  def pickerView(pickerView, numberOfRowsInComponent:component)
    NSTimeZone.knownTimeZoneNames.count
  end

  # UIPicker View Controller  Delegate
  def pickerView(pickerView, titleForRow:row, forComponent:component)
    NSTimeZone.knownTimeZoneNames[row]
  end

  def pickerView(pickerView, didSelectRow:row, inComponent:component)
    @currentZoneLabel.text = NSTimeZone.knownTimeZoneNames[row]
  end

  def viewDidLoad
    @defaultTimeZoneLabel = location_label(25,120)
    @defaultTimeLabel = time_label(50,150)

    chooseLocalButton = select_time_zone_button(220,115)
    chooseLocalButton.addTarget(self,
                                action: :'present_local_zone_picker:',
                                forControlEvents: UIControlEventTouchUpInside)

    @convertTimeZoneLabel = location_label(25,290)
    @convertTimeLabel = time_label(50,320)
    chooseConvertButton = select_time_zone_button(220,300)
    chooseConvertButton.addTarget(self,
                                action: :'present_convert_zone_picker:',
                                forControlEvents: UIControlEventTouchUpInside)

    view.addSubview(@convertTimeZoneLabel)
    view.addSubview(@convertTimeLabel)
    view.addSubview(chooseConvertButton)

    @zonePicker = zone_picker(0,244)
    @zonePicker.dataSource = self
    @zonePicker.delegate = self

    view.addSubview(@defaultTimeZoneLabel)
    view.addSubview(@defaultTimeLabel)
    view.addSubview(chooseLocalButton)
    view.addSubview(@zonePicker)

    set_default_time_zone
    set_default_time

    view.backgroundColor = UIColor.scrollViewTexturedBackgroundColor  
  end

end